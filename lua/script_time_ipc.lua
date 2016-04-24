-- Time script for IP Cameras

time = os.date("*t")
mins = time.min + time.hour * 60
commandArray = {}
libs = require("libs")	-- Include common functions

-- Garage Temp OSD
GARtemp = (otherdevices_temperature['Garage'] * 9) / 5 + 32
GARtemp = libs.round(GARtemp,1)
if (GARtemp ~= tonumber(uservariables["GARTemp"])) then
        commandArray["Variable:GARTemp"]=tostring(GARtemp)	
        commandArray['OpenURL'] = uservariables['camLogin'] .. '@192.168.42.25/cgi-bin/configManager.cgi?action=setConfig&VideoWidget[0].CustomTitle[1].Text=' .. tostring(GARtemp) .. '°F'
	print('Updating temp on garage osd')
end

-- Outdoor Temp OSD
ODtemp = (otherdevices_temperature['Online Weather'] * 9) / 5 + 32
ODtemp = libs.round(ODtemp,1)
if (ODtemp ~= tonumber(uservariables["ODTemp"])) then
        commandArray["Variable:ODTemp"]=tostring(ODtemp)	
        commandArray['OpenURL'] = uservariables['camLogin'] .. '@north-ptc/cgi-bin/configManager.cgi?action=setConfig&VideoWidget[0].CustomTitle[1].Text=' .. tostring(ODtemp) .. '°F'
	print('Updating temp on north ptz osd')
end

-- PTZ Idle Timeout (10mins)
if (libs.timedifference(otherdevices_lastupdate['West PTZ']) > 600) and (otherdevices['Back Door'] == 'Closed') then
	commandArray['West PTZ']='Set Level ' .. uservariables["WestPTZ-IdlePreset"]
end
if (libs.timedifference(otherdevices_lastupdate['North PTZ']) > 600) then
	commandArray['North PTZ']='Set Level ' .. uservariables["NorthPTZ-IdlePreset"]
end

-- PTZ Idle Preset for Day/Evening
if (timeofday['Nighttime']) and (tonumber(uservariables["WestPTZ-IdlePreset"]) ~= 60) and (tonumber(uservariables["away"]) < 1) and (time.hour >= 20) then
	print("Switching PTZ Idle for night.")
	commandArray["Variable:WestPTZ-IdlePreset"]="60"
elseif (timeofday['Daytime']) and (tonumber(uservariables["WestPTZ-IdlePreset"]) ~= 10) then
	print("Switching PTZ Idle for daytime.")
	commandArray["Variable:WestPTZ-IdlePreset"]="10"
end

-- Day/Night Video Profile Switching
if (mins == timeofday['SunsetInMinutes'] + 10) then
	print("Switching Outdoor Cameras to Night Profile.")
	commandArray[1]={ ['OpenURL'] = uservariables['camLogin'] .. '@west-ptz/cgi-bin/configManager.cgi?action=setConfig&VideoInMode[0].Config[0]=2' }
	commandArray[2]={ ['OpenURL'] = uservariables['camLogin'] .. '@north-ptc/cgi-bin/configManager.cgi?action=setConfig&VideoInMode[0].Config[0]=2' }
	commandArray[3]={ ['OpenURL'] = uservariables['camLogin'] .. '@south-ipc/cgi-bin/configManager.cgi?action=setConfig&VideoInOptions[0].NightOptions.SwitchMode=3' }
	commandArray[4]={ ['OpenURL'] = uservariables['camLogin'] .. '@east-ipc/cgi-bin/configManager.cgi?action=setConfig&VideoInOptions[0].NightOptions.SwitchMode=3' }
	-- WestPTZ needs to be kicked into BackLight mode at night
	-- commandArray[5]={ ['OpenURL'] = uservariables['camLogin'] .. '@west-ptz/cgi-bin/configManager.cgi?action=setConfig&VideoInExposure[0][2].Backlight=1' }
elseif (mins == timeofday['SunriseInMinutes'] - 10) then
	print("Switching Outdoor Cameras to Day Profile.")
	commandArray[1]={ ['OpenURL'] = uservariables['camLogin'] .. '@west-ptz/cgi-bin/configManager.cgi?action=setConfig&VideoInMode[0].Config[0]=1' }
	commandArray[2]={ ['OpenURL'] = uservariables['camLogin'] .. '@north-ptc/cgi-bin/configManager.cgi?action=setConfig&VideoInMode[0].Config[0]=1' }
	commandArray[3]={ ['OpenURL'] = uservariables['camLogin'] .. '@south-ipc/cgi-bin/configManager.cgi?action=setConfig&VideoInOptions[0].NightOptions.SwitchMode=0' }
	commandArray[4]={ ['OpenURL'] = uservariables['camLogin'] .. '@east-ipc/cgi-bin/configManager.cgi?action=setConfig&VideoInOptions[0].NightOptions.SwitchMode=0' }
	-- WestPTZ needs to be kicked into BackLight mode at night
	-- commandArray[5]={ ['OpenURL'] = uservariables['camLogin'] .. '@west-ptz/cgi-bin/configManager.cgi?action=setConfig&VideoInExposure[0][2].Backlight=0' }
end

-- ALPR Day/Night Video Profile Switching
if (mins == timeofday['SunsetInMinutes'] + 60) then
        print("Switching ALPR Camera to Night Profile.")
        commandArray[1]={ ['OpenURL'] = uservariables['camLogin'] .. '@alpr/cgi-bin/configManager.cgi?action=setConfig&VideoInMode[0].Config[0]=2' }
        commandArray[2]={ ['OpenURL'] = uservariables['camLogin'] .. '@alpr/cgi-bin/devVideoInput.cgi?action=adjustFocus&focus=0.475207&zoom=0' }
        commandArray[3]={ ['OpenURL'] = uservariables['camLogin'] .. '@alpr/cgi-bin/configManager.cgi?action=setConfig&VideoInExposure[0][2].Backlight=1' }
        commandArray[4]={ ['OpenURL'] = uservariables['camLogin'] .. '@alpr/cgi-bin/configManager.cgi?action=setConfig&AlarmOut[0].Mode=1' }
elseif (mins == timeofday['SunriseInMinutes'] - 60) then
        print("Switching ALPR Camera to Day Profile.")
        commandArray[1]={ ['OpenURL'] = uservariables['camLogin'] .. '@alpr/cgi-bin/configManager.cgi?action=setConfig&VideoInMode[0].Config[0]=1' }
        commandArray[2]={ ['OpenURL'] = uservariables['camLogin'] .. '@alpr/cgi-bin/devVideoInput.cgi?action=adjustFocus&focus=0.475207&zoom=0' }
        commandArray[3]={ ['OpenURL'] = uservariables['camLogin'] .. '@alpr/cgi-bin/configManager.cgi?action=setConfig&VideoInExposure[0][2].Backlight=0' }
        commandArray[4]={ ['OpenURL'] = uservariables['camLogin'] .. '@alpr/cgi-bin/configManager.cgi?action=setConfig&AlarmOut[0].Mode=0' }
end


return commandArray

