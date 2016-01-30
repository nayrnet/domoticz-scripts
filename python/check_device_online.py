#!/usr/bin/python
#   Title: check_device_online.py
#   Author: Chopper_Rob
#   Date: 25-02-2015
#   Info: Checks the presence of the given device on the network and reports back to domoticz
#   URL : https://www.chopperrob.nl/domoticz/5-report-devices-online-status-to-domoticz
#   Version : 1.6.2
 
import sys
import datetime
import time
import os
import subprocess
import urllib2
import json
import base64
 
# Settings for the domoticz server
domoticzserver="192.168.2.1:8080"
domoticzusername = "admin"
domoticzpassword = "admin"
 
# If enabled. The script will log to the file _.log
# Logging to file only happens after the check for other instances, before that it only prints to screen.
log_to_file = False
 
# The script supports two types to check if another instance of the script is running.
# One will use the ps command, but this does not work on all machine (Synology has problems)
# The other option is to create a pid file named _.pid. The script will update the timestamp
# every interval. If a new instance of the script spawns it will check the age of the pid file.
# If the file doesn't exist or it is older then 3 * Interval it will keep running, otherwise is stops.
# Please chose the option you want to use "ps" or "pid", if this option is kept empty it will not check and just run.
check_for_instances = "pid"
 
 
 
# DO NOT CHANGE BEYOND THIS LINE
if len(sys.argv) != 5 :
  print ("Not enough parameters. Needs %Host %Switchid %Interval %Cooldownperiod.")
  sys.exit(0)
 
device=sys.argv[1]
switchid=sys.argv[2]
interval=sys.argv[3]
cooldownperiod=sys.argv[4]
previousstate=-1
lastsuccess=datetime.datetime.now()
lastreported=-1
base64string = base64.encodestring('%s:%s' % (domoticzusername, domoticzpassword)).replace('\n', '')
domoticzurl = 'http://'+domoticzserver+'/json.htm?type=devices&filter=all&used=true&order=Name'
 
if check_for_instances.lower() == "pid":
  pidfile = sys.argv[0] + '_' + sys.argv[1] + '.pid'
  if os.path.isfile( pidfile ):
    print datetime.datetime.now().strftime("%H:%M:%S") + "- pid file exists"
    if (time.time() - os.path.getmtime(pidfile)) < (float(interval) * 3):
      print datetime.datetime.now().strftime("%H:%M:%S") + "- script seems to be still running, exiting"
      print datetime.datetime.now().strftime("%H:%M:%S") + "- If this is not correct, please delete file " + pidfile
      sys.exit(0)
    else:
      print datetime.datetime.now().strftime("%H:%M:%S") + "- Seems to be an old file, ignoring."
  else:
    open(pidfile, 'w').close() 
 
if check_for_instances.lower() == "ps":
  if int(subprocess.check_output('ps x | grep \'' + sys.argv[0] + ' ' + sys.argv[1] + '\' | grep -cv grep', shell=True)) > 2 :
    print (datetime.datetime.now().strftime("%H:%M:%S") + "- script already running. exiting.")
    sys.exit(0)
 
def log(message):
  print message
  if log_to_file == True:
    logfile = open(sys.argv[0] + '_' + sys.argv[1] + '.log', "a")
    logfile.write(message + "\n")
    logfile.close()
 
def domoticzstatus ():
  json_object = json.loads(domoticzrequest(domoticzurl))
  status = 0
  switchfound = False
  if json_object["status"] == "OK":
    for i, v in enumerate(json_object["result"]):
      if json_object["result"][i]["idx"] == switchid and "Lighting" in json_object["result"][i]["Type"] :
        switchfound = True
        if json_object["result"][i]["Status"] == "On": 
          status = 1
        if json_object["result"][i]["Status"] == "Off": 
          status = 0
  if switchfound == False: print (datetime.datetime.now().strftime("%H:%M:%S") + "- Error. Could not find switch idx in Domoticz response. Defaulting to switch off.")
  return status
 
def domoticzrequest (url):
  request = urllib2.Request(url)
  request.add_header("Authorization", "Basic %s" % base64string)
  response = urllib2.urlopen(request)
  return response.read()
 
log (datetime.datetime.now().strftime("%H:%M:%S") + "- script started.")
 
lastreported = domoticzstatus()
if lastreported == 1 :
  log (datetime.datetime.now().strftime("%H:%M:%S") + "- according to domoticz, " + device + " is online")
if lastreported == 0 :
  log (datetime.datetime.now().strftime("%H:%M:%S") + "- according to domoticz, " + device + " is offline")
 
while 1==1:
  currentstate = subprocess.call('ping -q -c1 -W 1 '+ device + ' > /dev/null', shell=True)
 
  if currentstate == 0 : lastsuccess=datetime.datetime.now()
  if currentstate == 0 and currentstate != previousstate and lastreported == 1 : 
    log (datetime.datetime.now().strftime("%H:%M:%S") + "- " + device + " online, no need to tell domoticz")
  if currentstate == 0 and currentstate != previousstate and lastreported != 1 :
    if domoticzstatus() == 0 :
      log (datetime.datetime.now().strftime("%H:%M:%S") + "- " + device + " online, tell domoticz it's back")
      domoticzrequest("http://" + domoticzserver + "/json.htm?type=command&param=switchlight&idx=" + switchid + "&switchcmd=On&level=0")
    else:
      log (datetime.datetime.now().strftime("%H:%M:%S") + "- " + device + " online, but domoticz already knew")
    lastreported=1
 
  if currentstate == 1 and currentstate != previousstate :
    log (datetime.datetime.now().strftime("%H:%M:%S") + "- " + device + " offline, waiting for it to come back")
 
  if currentstate == 1 and (datetime.datetime.now()-lastsuccess).total_seconds() > float(cooldownperiod) and lastreported != 0 :
    if domoticzstatus() == 1 :
      log (datetime.datetime.now().strftime("%H:%M:%S") + "- " + device + " offline, tell domoticz it's gone")
      domoticzrequest("http://" + domoticzserver + "/json.htm?type=command&param=switchlight&idx=" + switchid + "&switchcmd=Off&level=0")
    else:
      log (datetime.datetime.now().strftime("%H:%M:%S") + "- " + device + " offline, but domoticz already knew")
    lastreported=0
 
  time.sleep (float(interval))
 
  previousstate=currentstate
  if check_for_instances.lower() == "pid": open(pidfile, 'w').close()  
