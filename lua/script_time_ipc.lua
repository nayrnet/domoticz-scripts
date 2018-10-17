-- Time script for IP Cameras

time = os.date("*t")
mins = time.min + time.hour * 60
commandArray = {}
libs = require("libs")	-- Include common functions

-- Garage Temp OSD
--GARtemp = (otherdevices_temperature['Garage'] * 9) / 5 + 32
--GARtemp = libs.round(GARtemp,1)
--if (GARtemp ~= tonumber(uservariables["GARTemp"])) then
--        commandArray["Variable:GARTemp"]=tostring(GARtemp)	
--        commandArray['OpenURL'] = uservariables['camLogin'] .. '@192.168.42.25/cgi-bin/configManager.cgi?action=setConfig&VideoWidget[0].CustomTitle[1].Text=' .. tostring(GARtemp) .. '°F'
--	print('Updating temp on garage osd')
--end

-- Outdoor Temp OSD
ODtemp = (otherdevices_temperature['Online Weather'] * 9) / 5 + 32
ODtemp = libs.round(ODtemp,1)
if (ODtemp ~= tonumber(uservariables["ODTemp"])) then
        commandArray["Variable:ODTemp"]=tostring(ODtemp)	
        commandArray['OpenURL'] = uservariables['camLogin'] .. '@north-ptc/cgi-bin/configManager.cgi?action=setConfig&VideoWidget[0].CustomTitle[1].Text=' .. tostring(ODtemp) .. '°F'
	print('Updating temp on north ptz osd')
end

-- PTZ Idle Timeout (10mins)
if (libs.timedifference(otherdevices_lastupdate['West PTZ']) > 600) then
	print("WestPTZ Preset Idle..")
	commandArray['West PTZ']='Set Level ' .. uservariables["WestPTZ-IdlePreset"]
end
if (libs.timedifference(otherdevices_lastupdate['North PTZ']) > 600) then
	print("NorthPTZ Preset Idle..")
	commandArray['North PTZ']='Set Level ' .. uservariables["NorthPTZ-IdlePreset"]
end

-- PTZ Idle Preset for Day/Evening
if (timeofday['Nighttime']) and (tonumber(uservariables["WestPTZ-IdlePreset"]) ~= 60) and (tonumber(uservariables["away"]) < 1) and (time.hour >= 20) then
	print("Switching PTZ Idle for night.")
	commandArray["Variable:WestPTZ-IdlePreset"]="60"
	commandArray['West PTZ']='Set Level 60'
elseif (timeofday['Daytime']) and (tonumber(uservariables["WestPTZ-IdlePreset"]) ~= 10) then
	print("Switching PTZ Idle for daytime.")
	commandArray["Variable:WestPTZ-IdlePreset"]="10"
	commandArray['West PTZ']='Set Level 10'
elseif (timeofday['Nighttime']) and (tonumber(uservariables["NorthPTZ-IdlePreset"]) ~= 50) and (time.hour >= 21) then
	print("Switching PTZ Idle for night.")
	commandArray["Variable:NorthPTZ-IdlePreset"]="50"
	commandArray['North PTZ']='Set Level 50'
elseif (timeofday['Daytime']) and (tonumber(uservariables["NorthPTZ-IdlePreset"]) ~= 10) then
	print("Switching PTZ Idle for daytime.")
	commandArray["Variable:NorthPTZ-IdlePreset"]="10"
	commandArray['North PTZ']='Set Level 10'
end


-- Day/Night Video Profile Switching
if (mins >= timeofday['SunsetInMinutes']) and (tonumber(uservariables["ODCam-Profile"]) ~= 1) then
	print("Switching Outdoor Cameras to Night Profile.")
	commandArray[1]={ ['OpenURL'] = uservariables['camLogin'] .. '@west-ptz/cgi-bin/configManager.cgi?action=setConfig&VideoInMode[0].Config[0]=2' }
	commandArray[2]={ ['OpenURL'] = uservariables['camLogin'] .. '@north-ptz/cgi-bin/configManager.cgi?action=setConfig&VideoInMode[0].Config[0]=2' }
	commandArray[3]={ ['OpenURL'] = uservariables['camLogin'] .. '@back-ipc/cgi-bin/configManager.cgi?action=setConfig&VideoInMode[0].Config[0]=1' }
	commandArray[4]={ ['OpenURL'] = uservariables['camLogin'] .. '@front-ipc/cgi-bin/configManager.cgi?action=setConfig&VideoInMode[0].Config[0]=1' }
	commandArray[5]={ ['OpenURL'] = uservariables['camLogin'] .. '@south-ipc/cgi-bin/configManager.cgi?action=setConfig&VideoInOptions[0].NightOptions.SwitchMode=3' }
	commandArray[6]={ ['OpenURL'] = uservariables['camLogin'] .. '@east-ipc/cgi-bin/configManager.cgi?action=setConfig&VideoInOptions[0].NightOptions.SwitchMode=3' }
	commandArray[7]={ ['OpenURL'] = uservariables['camLogin'] .. '@north-ipc/cgi-bin/configManager.cgi?action=setConfig&VideoInOptions[0].NightOptions.SwitchMode=3' }
        commandArray[8]={ ['OpenURL'] = uservariables['camLogin'] .. '@alpr/cgi-bin/devVideoInput.cgi?action=adjustFocus&focus=' .. uservariables["alpr-night-focus"] .. '&zoom=0' }
        commandArray[9]={ ['OpenURL'] = uservariables['camLogin'] .. '@alpr/cgi-bin/configManager.cgi?action=setConfig&AlarmOut[0].Mode=1' }
        commandArray[10]={ ["Variable:ODCam-Profile"] = "1" }
elseif (mins >= timeofday['SunriseInMinutes']) and (tonumber(uservariables["ODCam-Profile"]) ~= 0) and (mins < timeofday['SunsetInMinutes']) then
	print("Switching Outdoor Cameras to Day Profile.")
	commandArray[1]={ ['OpenURL'] = uservariables['camLogin'] .. '@west-ptz/cgi-bin/configManager.cgi?action=setConfig&VideoInMode[0].Config[0]=1' }
	commandArray[2]={ ['OpenURL'] = uservariables['camLogin'] .. '@north-ptz/cgi-bin/configManager.cgi?action=setConfig&VideoInMode[0].Config[0]=0' }
	commandArray[3]={ ['OpenURL'] = uservariables['camLogin'] .. '@back-ipc/cgi-bin/configManager.cgi?action=setConfig&VideoInMode[0].Config[0]=0' }
	commandArray[4]={ ['OpenURL'] = uservariables['camLogin'] .. '@front-ipc/cgi-bin/configManager.cgi?action=setConfig&VideoInMode[0].Config[0]=0' }
	commandArray[5]={ ['OpenURL'] = uservariables['camLogin'] .. '@south-ipc/cgi-bin/configManager.cgi?action=setConfig&VideoInOptions[0].NightOptions.SwitchMode=0' }
	commandArray[6]={ ['OpenURL'] = uservariables['camLogin'] .. '@east-ipc/cgi-bin/configManager.cgi?action=setConfig&VideoInOptions[0].NightOptions.SwitchMode=0' }
	commandArray[7]={ ['OpenURL'] = uservariables['camLogin'] .. '@north-ipc/cgi-bin/configManager.cgi?action=setConfig&VideoInOptions[0].NightOptions.SwitchMode=0' }
        commandArray[8]={ ['OpenURL'] = uservariables['camLogin'] .. '@alpr/cgi-bin/devVideoInput.cgi?action=adjustFocus&focus=' .. uservariables["alpr-day-focus"] .. '&zoom=0' }
        commandArray[9]={ ['OpenURL'] = uservariables['camLogin'] .. '@alpr/cgi-bin/configManager.cgi?action=setConfig&AlarmOut[0].Mode=0' }
        commandArray[10]={ ["Variable:ODCam-Profile"] = "0" }
end

-- ALPR Day/Night Video Profile Switching
if (mins >= timeofday['SunsetInMinutes'] - 30) and (tonumber(uservariables["ALPR-Profile"]) < 1) then
        print("Switching ALPR Camera to Night Profile.")
        commandArray[1]={ ['OpenURL'] = uservariables['camLogin'] .. '@alpr/cgi-bin/configManager.cgi?action=setConfig&VideoInMode[0].Config[0]=1' }
        --commandArray[2]={ ['OpenURL'] = uservariables['camLogin'] .. '@alpr/cgi-bin/configManager.cgi?action=setConfig&VideoInExposure[0][0].Backlight=0' }
        commandArray[2]={ ["Variable:ALPR-Profile"] = "1" }
elseif (mins >= timeofday['SunriseInMinutes'] + 30) and (tonumber(uservariables["ALPR-Profile"]) > 0) and (mins < timeofday['SunsetInMinutes'] - 30) then
        print("Switching ALPR Camera to Day Profile.")
        commandArray[1]={ ['OpenURL'] = uservariables['camLogin'] .. '@alpr/cgi-bin/configManager.cgi?action=setConfig&VideoInMode[0].Config[0]=0' }
        --commandArray[2]={ ['OpenURL'] = uservariables['camLogin'] .. '@alpr/cgi-bin/configManager.cgi?action=setConfig&VideoInExposure[0][0].Backlight=1' }
        commandArray[2]={ ["Variable:ALPR-Profile"] = "0" }
end

return commandArray

