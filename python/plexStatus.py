#!/usr/bin/python
from __future__ import division
import traceback
import sys
import datetime
import time
import os
import urllib, urllib2, hashlib,subprocess
from xml.etree import ElementTree as ET
ErrorCount = 0
#general Script settings
plex_Interval                 = 5     # Poll Interval. The Plex Server updates the session status every 10 seconds. Leave at 5 to not mis any state change.
plex_ShowPlayProgress         = True 
plex_AutoClearPlayLog         = True  # Should be enabled when showing Play Progress
plex_AutoCreateUserVariables  = False  # Automatically create a user variable for each Client listed under dom_PlexPlayers
plex_ViewOffsetTimeout        = 15    # In seconds.
plex_MaxErrorCount            = 3     # number of consecutive errors until Plex is considered Offline

#RunState values (for user variable)
plex_ServerOffline    = -1
plex_Idle             = 0
plex_Video_Playing    = 1
plex_Video_Paused     = 2
plex_Video_Stopped    = 3
plex_Audio_Playing    = 11
plex_Audio_Paused     = 12
plex_Audio_Stopped    = 13

#Plex Server Settings
plexIP                 = 'plex'
plexPort               = '32400'          # (default port = 32400)

#domoticz settings
domoticz_host          = 'dev:dev@127.0.0.1'
domoticz_port          = '8080'
domoticz_url           = 'json.htm'

#Plex Players Settings - This script handles multiple players
dom_PlexPlayers        = ['Livingroom','Bedroom', 'Charlies Room'] #Players not on this list will be ignored
dom_PlexPlayInfo_ID    = ['113','114','115']
dom_PlexPlayState_ID   = ['plex-livingroom','plex-bedroom','plex-charlie']          # Name of User Variable. Is overwrriten when plex_AutoCreateUserVariables=True

#Various Variables
plex_TimeLastUpdate    = ""
plex_LastOffsetUpdate  = []  # of loop iterations
plex_LastOffset        = []
plex_PreviousState     = []
plex_PreviousTitle     = []
plex_AlreadyIdle       = []

#building url
requestURL = 'http://'+ plexIP + ':' + plexPort + '/status/sessions'

#Ensure equal list sizes
while len(dom_PlexPlayInfo_ID)<len(dom_PlexPlayers):
  dom_PlexPlayInfo_ID.append('-1')
while len(dom_PlexPlayState_ID)<len(dom_PlexPlayers):
  dom_PlexPlayState_ID.append('-1')
while len(plex_LastOffsetUpdate)<len(dom_PlexPlayers):
  plex_LastOffsetUpdate.append(1)
while len(plex_LastOffset)<len(dom_PlexPlayers):
  plex_LastOffset.append(1)
while len(plex_PreviousState)<len(dom_PlexPlayers):
  plex_PreviousState.append('0')
while len(plex_PreviousTitle)<len(dom_PlexPlayers):
  plex_PreviousTitle.append('0')
while len(plex_AlreadyIdle)<len(dom_PlexPlayers):
  plex_AlreadyIdle.append(False)

# create play Status user variable for each client
if plex_AutoCreateUserVariables:
  for client in dom_PlexPlayers:
    try:
      name = "PLEX STATUS [" + client + "]"
      url = "http://" + domoticz_host + ":" + domoticz_port + "/" + domoticz_url+ "?type=command&param=saveuservariable&vname=" + name + "&vtype=Integer&vvalue=" + str(plex_Idle)
      url = urllib.quote(url, safe="%/:=&?~#+!$,;'@()*[]")
      urllib.urlopen(url)
      idx = dom_PlexPlayers.index(client)
      dom_PlexPlayState_ID[idx] = name
    except Exception:
      print 'Connection Error'

pidfile = sys.argv[0] + '_' + plexIP + '.pid'
if os.path.isfile( pidfile ):
  if (time.time() - os.path.getmtime(pidfile)) < (float(5) * 3):
    print datetime.datetime.now().strftime("%H:%M:%S") + "- script seems to be still running, exiting"
    print datetime.datetime.now().strftime("%H:%M:%S") + "- If this is not correct, please delete file " + pidfile
    sys.exit(0)
  else:
    print datetime.datetime.now().strftime("%H:%M:%S") + "- Seems to be an old file, ignoring."
else:
  open(pidfile, 'w').close()

while 1==1:
  try:
    #call session url
    test = urllib.urlopen(requestURL).read()
    root = ET.XML(test)
    ProcessedIDs=[]
    #Video Support
    for video in root.findall('Video'):
      # Get Attributes for each player
      player = video.find('Player').attrib['title']
      state = video.find('Player').attrib['state']
      parenttitle = video.get('grandparentTitle')
      videotitle = video.get('title')
      videotype = video.get('type')
      videoduration = video.get('duration')
      viewOffset = video.get('viewOffset')
      PlayProgress=''
      if plex_ShowPlayProgress and videoduration is not None:
        durTotalSeconds = long(long(videoduration) / 1000)
        durSeconds = int(durTotalSeconds % 60)
        durTotalSeconds /=60
        durMinutes = int(durTotalSeconds % 60)
        durTotalSeconds /=60
        durHours = int(durTotalSeconds)
        if viewOffset is not None:
          runTotalSeconds = long(long(viewOffset) / 1000)
          runSeconds = int(runTotalSeconds % 60)
          runTotalSeconds /=60
          runMinutes = int(runTotalSeconds % 60)
          runTotalSeconds /=60
          runHours = int(runTotalSeconds)
        else:
          runSeconds=0
          runMinutes=0
          runHours=0
        PlayProgress= ' (' + str(runHours) + ':' + str(runMinutes).zfill(2) + ':' + str(runSeconds).zfill(2) + '/' + str(durHours) + ':' + str(durMinutes).zfill(2) + ':' + str(durSeconds).zfill(2) + ')'
      else:
        PlayProgress=""
      PlayString = ""
      StateChange = 0
      PlayerID = dom_PlexPlayers.index(player) if player in dom_PlexPlayers else -1
      if PlayerID >= 0:  #only process players that are on the list
        try:
          # Check if there is progress
          if (viewOffset>plex_LastOffset[PlayerID] and state=="playing") or  (videotitle!=plex_PreviousTitle[PlayerID]):
            plex_LastOffsetUpdate[PlayerID] = 0
          elif viewOffset == plex_LastOffset[PlayerID]:
            plex_LastOffsetUpdate[PlayerID] += 1

          if plex_LastOffsetUpdate[PlayerID] >= int(plex_ViewOffsetTimeout/plex_Interval) and state == "playing":
            state = "stopped"

          if plex_PreviousState[PlayerID] == state:
            StateChange = 0
          else:
            StateChange = 1
            plex_PreviousState[PlayerID]=state

          plex_PreviousTitle[PlayerID] = videotitle
          
          if videotype == 'movie':
            PlayString = state.capitalize() + " Movie: " + videotitle + PlayProgress
            print 'Movie ' + state.capitalize() + ': '+ videotitle + PlayProgress
          elif videotype =='episode':
            PlayString = state.capitalize() + " Episode: " + parenttitle + " - " + videotitle + PlayProgress
            print 'Episode ' + state.capitalize() + ': ' + parenttitle + " - " + videotitle + PlayProgress
          else:
            PlayString = "Video " + state.capitalize() + ": " + videotitle + PlayProgress
            print 'Video ' + state.capitalize() + ': ' + videotitle + PlayProgress
          #uploading log message to domoticz
          PlayString = urllib.quote(PlayString)
          if StateChange == 1:
            url = "http://" + domoticz_host + ":" + domoticz_port + "/" + domoticz_url + "?type=command&param=addlogmessage&message=" + PlayString
            urllib.urlopen(url)
            plex_AlreadyIdle[PlayerID] = False
          #uploading values to domoticz
          url = "http://" + domoticz_host + ":" + domoticz_port + "/" + domoticz_url + "?type=command&param=udevice&idx=" + dom_PlexPlayInfo_ID[PlayerID] + "&nvalue=0&svalue=" + PlayString
          urllib.urlopen(url)
          
          statusValue = 0
          if state == "playing":
            statusValue = plex_Video_Playing
          elif state == "paused":
            statusValue = plex_Video_Paused
          elif state == "stopped":
            statusValue = plex_Video_Stopped

          if plex_LastOffset[PlayerID] != viewOffset:
            if plex_AutoClearPlayLog:
              url = "http://" + domoticz_host + ":" + domoticz_port + "/" + domoticz_url + "?type=command&param=clearlightlog&idx=" + dom_PlexPlayInfo_ID[PlayerID]
              urllib.urlopen(url)
          if StateChange == 1:
            url = ("http://" + domoticz_host + ":" + domoticz_port + "/" + domoticz_url + "?type=command&param=updateuservariable&vname=" + dom_PlexPlayState_ID[PlayerID] + "&vtype=integer&vvalue=" + str(statusValue))
            url = urllib.quote(url, safe="%/:=&?~#+!$,;'@()*[]")
            urllib.urlopen(url)
          plex_LastOffset[PlayerID] = viewOffset
          
          ProcessedIDs.append(PlayerID)
      
        except Exception,e:
          print 'IDLE'
          print e
          print traceback.print_exc()
          #uploading values to domoticz
          
          url = ("http://" + domoticz_host + ":" + domoticz_port + "/" + domoticz_url+ "?type=command&param=udevice&idx=" + dom_PlexPlayInfo_ID[PlayerID] + "&nvalue=0&svalue=No%20Media%20Playing")
          urllib.urlopen(url)
          pass
    #Audio Support
    for audio in root.findall('Track'):
      # Get Attributes for each player
      player = audio.find('Player').attrib['title']
      state = audio.find('Player').attrib['state']
      parenttitle = "Unknown"
      parenttitle = audio.get('grandparentTitle')
      audiotitle = audio.get('title')
      audioduration = audio.get('duration')
      viewOffset = audio.get('viewOffset')
      PlayProgress=''
      if plex_ShowPlayProgress:
        durTotalSeconds = long(long(audioduration) / 1000)
        durSeconds = int(durTotalSeconds % 60)
        durTotalSeconds /=60
        durMinutes = int(durTotalSeconds % 60)
        durTotalSeconds /=60
        durHours = int(durTotalSeconds)
        if viewOffset is not None:
          runTotalSeconds = long(long(viewOffset) / 1000)
          runSeconds = int(runTotalSeconds % 60)
          runTotalSeconds /=60
          runMinutes = int(runTotalSeconds % 60)
          runTotalSeconds /=60
          runHours = int(runTotalSeconds)
        else:
          runSeconds=0
          runMinutes=0
          runHours=0
        PlayProgress= ' (' + str(runHours) + ':' + str(runMinutes).zfill(2) + ':' + str(runSeconds).zfill(2) + '/' + str(durHours) + ':' + str(durMinutes).zfill(2) + ':' + str(durSeconds).zfill(2) + ')'
      else:
        PlayProgress=""
      PlayString = ""
      StateChange = 0
      PlayerID = dom_PlexPlayers.index(player) if player in dom_PlexPlayers else -1
      if PlayerID >= 0:  #only process players that are on the list
        try:
          # Check if there is progress
          if (viewOffset>plex_LastOffset[PlayerID] and state=="playing") or  (audiotitle!=plex_PreviousTitle[PlayerID]):
            plex_LastOffsetUpdate[PlayerID] = 0
          elif viewOffset == plex_LastOffset[PlayerID]:
            plex_LastOffsetUpdate[PlayerID] += 1

          if plex_LastOffsetUpdate[PlayerID] >= int(plex_ViewOffsetTimeout/plex_Interval) and state == "playing":
            state = "stopped"

          if plex_PreviousState[PlayerID] == state:
            StateChange = 0
          else:
            StateChange = 1
            plex_PreviousState[PlayerID]=state

          plex_PreviousTitle[PlayerID] = audiotitle
          PlayString = state.capitalize() + " Audio: " + parenttitle + " - " + audiotitle + PlayProgress
          PlayString = urllib.quote(PlayString)
          print 'Audio ' + state.capitalize() + ': '+ audiotitle + PlayProgress
          #uploading log message to domoticz
          if StateChange == 1:
            url = "http://" + domoticz_host + ":" + domoticz_port + "/" + domoticz_url + "?type=command&param=addlogmessage&message=" + PlayString
            urllib.urlopen(url)
            plex_AlreadyIdle[PlayerID] = False
          #uploading values to domoticz
          url = "http://" + domoticz_host + ":" + domoticz_port + "/" + domoticz_url + "?type=command&param=udevice&idx=" + dom_PlexPlayInfo_ID[PlayerID] + "&nvalue=0&svalue=" + PlayString
          urllib.urlopen(url)
          
          statusValue = 0
          if state == "playing":
            statusValue = plex_Audio_Playing
          elif state == "paused":
            statusValue = plex_Audio_Paused
          elif state == "stopped":
            statusValue = plex_Audio_Stopped

          if plex_LastOffset[PlayerID] != viewOffset:
            if plex_AutoClearPlayLog:
              url = "http://" + domoticz_host + ":" + domoticz_port + "/" + domoticz_url + "?type=command&param=clearlightlog&idx=" + dom_PlexPlayInfo_ID[PlayerID]
              urllib.urlopen(url)
          if StateChange == 1:
            url = ("http://" + domoticz_host + ":" + domoticz_port + "/" + domoticz_url + "?type=command&param=updateuservariable&vname=" + dom_PlexPlayState_ID[PlayerID] + "&vtype=integer&vvalue=" + str(statusValue))
            url = urllib.quote(url, safe="%/:=&?~#+!$,;'@()*[]")
            urllib.urlopen(url)
          plex_LastOffset[PlayerID] = viewOffset
          ProcessedIDs.append(PlayerID)
      
        except Exception,e:
          print 'IDLE'
          print e
          print traceback.print_exc()
          #uploading values to domoticz
          
          url = ("http://" + domoticz_host + ":" + domoticz_port + "/" + domoticz_url+ "?type=command&param=udevice&idx=" + dom_PlexPlayInfo_ID[PlayerID] + "&nvalue=0&svalue=No%20Media%20Playing")
          urllib.urlopen(url)
          pass
    for photo in root.findall('Photo'):
      # Get Attributes for each player
      player = photo.find('Player').attrib['title']
      state = photo.find('Player').attrib['state']
      parenttitle = "Unknown"
      parenttitle = photo.get('parentTitle')
      phototitle = photo.get('title')
      PlayString = ""
      StateChange = 0
      PlayerID = dom_PlexPlayers.index(player) if player in dom_PlexPlayers else -1
      if PlayerID >= 0:  #only process players that are on the list
        try:
          if plex_PreviousState[PlayerID] == state:
            StateChange = 0
          else:
            StateChange = 1
            plex_PreviousState[PlayerID]=state
          plex_PreviousTitle[PlayerID] = phototitle
          PlayString = state.capitalize() + " Slideshow: " + parenttitle + " - " + phototitle
          PlayString = urllib.quote(PlayString)
          print 'Slideshow ' + state.capitalize() + ': '+ phototitle
          #uploading log message to domoticz
          if StateChange == 1:
            url = "http://" + domoticz_host + ":" + domoticz_port + "/" + domoticz_url + "?type=command&param=addlogmessage&message=" + PlayString
            urllib.urlopen(url)
            plex_AlreadyIdle[PlayerID] = False
            #uploading values to domoticz
            url = "http://" + domoticz_host + ":" + domoticz_port + "/" + domoticz_url + "?type=command&param=udevice&idx=" + dom_PlexPlayInfo_ID[PlayerID] + "&nvalue=0&svalue=" + PlayString
            urllib.urlopen(url)
            statusValue = 0
            if state == "playing":
              statusValue = plex_Audio_Playing
            elif state == "paused":
              statusValue = plex_Audio_Paused
            elif state == "stopped":
              statusValue = plex_Audio_Stopped
            url = ("http://" + domoticz_host + ":" + domoticz_port + "/" + domoticz_url + "?type=command&param=updateuservariable&vname=" + dom_PlexPlayState_ID[PlayerID] + "&vtype=integer&vvalue=" + str(statusValue))
            url = urllib.quote(url, safe="%/:=&?~#+!$,;'@()*[]")
            urllib.urlopen(url)

          ProcessedIDs.append(PlayerID)
      
        except Exception,e:
          print 'IDLE'

          #uploading values to domoticz
          url = ("http://" + domoticz_host + ":" + domoticz_port + "/" + domoticz_url+ "?type=command&param=udevice&idx=" + dom_PlexPlayInfo_ID[PlayerID] + "&nvalue=0&svalue=No%20Media%20Playing")
          urllib.urlopen(url)
          pass
    #set play status to IDLE
    for i in range(0, len(dom_PlexPlayers)):
      if i not in ProcessedIDs and plex_AlreadyIdle[i] == False:
        print 'IDLE'
        url = ("http://" + domoticz_host + ":" + domoticz_port + "/" + domoticz_url+ "?type=command&param=udevice&idx=" + dom_PlexPlayInfo_ID[i] + "&nvalue=0&svalue=No%20Media%20Playing")
        urllib.urlopen(url)
        url = ("http://" + domoticz_host + ":" + domoticz_port + "/" + domoticz_url+ "?type=command&param=updateuservariable&vname=" + dom_PlexPlayState_ID[i] + "&vtype=integer&vvalue=0")
        url = urllib.quote(url, safe="%/:=&?~#+!$,;'@()*[]")
        urllib.urlopen(url)
        plex_AlreadyIdle[i] = True
    ErrorCount = 0 
  except Exception,e:
    print traceback.print_exc()
    ErrorCount+=1
    if ErrorCount == plex_MaxErrorCount:
      print 'PLEX OFFLINE'
      for i in range(0, len(dom_PlexPlayers)):
        if plex_AlreadyIdle[i] == False:
          url = ("http://" + domoticz_host + ":" + domoticz_port + "/" + domoticz_url+ "?type=command&param=udevice&idx=" + dom_PlexPlayInfo_ID[i] + "&nvalue=0&svalue=No%20Media%20Playing")
          urllib.urlopen(url)
          url = ("http://" + domoticz_host + ":" + domoticz_port + "/" + domoticz_url+ "?type=command&param=updateuservariable&vname=" + dom_PlexPlayState_ID[i] + "&vtype=integer&vvalue=" + str(plex_ServerOffline))
          url = urllib.quote(url, safe="%/:=&?~#+!$,;'@()*[]")
          urllib.urlopen(url)
          plex_AlreadyIdle[i] = True
      pass
  time.sleep (plex_Interval)
  open(pidfile, 'w').close()
