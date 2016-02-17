-- Time script for IP Cameras

time = os.date("*t")
mins = time.min + time.hour * 60
commandArray = {}
libs = require("libs")	-- Include common functions

-- PTZ Idle Timeout (10mins)
if (libs.timedifference(otherdevices_lastupdate['West PTZ']) > 600) then
	commandArray['West PTZ']='Set Level ' .. uservariables["WestPTZ-IdlePreset"]
end

-- PTZ Idle Preset for Day/Evening
if (timeofday['Nighttime']) and (tonumber(uservariables["WestPTZ-IdlePreset"]) ~= 60) and (tonumber(uservariables["away"]) < 1) and (time.hour > 20) then
	commandArray["Variable:WestPTZ-IdlePreset"]="60"
elseif (timeofday['Daytime']) and (tonumber(uservariables["WestPTZ-IdlePreset"]) ~= 10) then
	commandArray["Variable:WestPTZ-IdlePreset"]="10"
end

-- Day/Night Video Profile Switching
if (mins == timeofday['SunsetInMinutes'] + 10) then
	print("Switching Outdoor Cameras to Night Profile.")
	commandArray[1]={ ['OpenURL'] = uservariables['camLogin'] .. '@west-ptz/cgi-bin/configManager.cgi?action=setConfig&VideoInMode[0].Config[0]=2' }
	commandArray[2]={ ['OpenURL'] = uservariables['camLogin'] .. '@north-ptc/cgi-bin/configManager.cgi?action=setConfig&VideoInOptions[0].NightOptions.SwitchMode=3' }
	commandArray[3]={ ['OpenURL'] = uservariables['camLogin'] .. '@south-ipc/cgi-bin/configManager.cgi?action=setConfig&VideoInOptions[0].NightOptions.SwitchMode=3' }
	commandArray[4]={ ['OpenURL'] = uservariables['camLogin'] .. '@east-ipc/cgi-bin/configManager.cgi?action=setConfig&VideoInOptions[0].NightOptions.SwitchMode=3' }
elseif (mins == timeofday['SunriseInMinutes'] - 10) then
	print("Switching Outdoor Cameras to Day Profile.")
	commandArray[1]={ ['OpenURL'] = uservariables['camLogin'] .. '@west-ptz/cgi-bin/configManager.cgi?action=setConfig&VideoInMode[0].Config[0]=1' }
	commandArray[2]={ ['OpenURL'] = uservariables['camLogin'] .. '@north-ptc/cgi-bin/configManager.cgi?action=setConfig&VideoInOptions[0].NightOptions.SwitchMode=0' }
	commandArray[3]={ ['OpenURL'] = uservariables['camLogin'] .. '@south-ipc/cgi-bin/configManager.cgi?action=setConfig&VideoInOptions[0].NightOptions.SwitchMode=0' }
	commandArray[4]={ ['OpenURL'] = uservariables['camLogin'] .. '@east-ipc/cgi-bin/configManager.cgi?action=setConfig&VideoInOptions[0].NightOptions.SwitchMode=0' }
end

return commandArray
