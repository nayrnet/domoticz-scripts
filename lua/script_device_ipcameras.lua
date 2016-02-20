-- Intelligent IP Camera Actions
commandArray = {}
libs = require("libs")	-- Include common functions

-- Determine if its Windy or Raining, as that will alter events triggered by Video Motion detectors.
sWindDirectionDegrees, sWindDirection, sWindSpeed, sWindGust, sWindTemperature, sWindFeel = otherdevices_svalues['Wind']:match("([^;]+);([^;]+);([^;]+);([^;]+);([^;]+);([^;]+)")
sRainmeterCurrent, sRainmeterTotal = otherdevices_svalues['Rain Fall']:match("([^;]+);([^;]+)")
sWindGust = tonumber(sWindGust)
sRainmeterCurrent = tonumber(sRainmeterCurrent)
if (sWindGust > 5) then notWindy = false else notWindy = true end
if (sRainmeterCurrent) then noRain = false else noRain = true end

-- Motion Sensor: Back Parking
if (devicechanged['MD Back Parking'] == 'On') and (libs.timedifference(uservariables_lastupdate['md-backpark']) > 900) and (notWindy) and (noRain) then
	if (tonumber(otherdevices_svalues["West PTZ"]) == uservariables["WestPTZ-IdlePreset"]) then	-- Only if idle
		commandArray['West PTZ']='Set Level 20'
		commandArray['Variable:md-backpark']='1'
	end
elseif (devicechanged['MD Back Parking'] == 'Off') and (tonumber(otherdevices_svalues["West PTZ"]) == 20) then
	commandArray['West PTZ']='Set Level ' .. uservariables["WestPTZ-IdlePreset"] .. ' AFTER 120'
end

-- Contact Switch: West Gate
if (devicechanged['West Gate'] == 'Open') then
	print("West Gate Open!")
	commandArray[1]={['SendNotification']='Perimeter Alert#The West Gate was just accessed.#1'}
	commandArray[2]={['West PTZ']='Set Level 80'}
	commandArray[3]['Variable:WestPTZ-IdlePreset']='20'
	commandArray[4]={['West PTZ']='Set Level 20 AFTER 30'}

	os.execute('ogg123 -q ~/audio/alert-prefix.ogg ~/audio/westgate.ogg &')
	if (otherdevices['Back Door Light'] == 'Off') and (timeofday['Nighttime']) then
		commandArray[5]={['Back Door Light']='On FOR 15'}
	end
	if (otherdevices['Front Security Lights'] == 'Off') and (timeofday['Nighttime']) then
		commandArray[6]={['Front Security Lights']='On FOR 15'}
	end
	if (otherdevices['Front Door Light'] == 'Off') and (timeofday['Nighttime']) then
		commandArray[7]={['Front Security Lights']='On FOR 15'}
	end
	if (otherdevices['Bedroom Light'] == 'Off') and (timeofday['Nighttime']) then
		commandArray[8]={['Bedroom Light']='On FOR 5'}
	end
elseif (devicechanged['West Gate'] == 'Closed') then
	commandArray[2]['Variable:WestPTZ-IdlePreset']='10'
	commandArray[3]={['West PTZ']='Set Level 10 AFTER 60'}
end

-- Light Trigger: Back Patio
if (devicechanged['MD South IPC'] == 'On') and (otherdevices['Back Door Light'] == 'Off') and (timeofday['Nighttime']) and (notWindy) and (noRain) then
	-- Only after light been out for more than 10mins to prevent needless cycling
	if (libs.timedifference(otherdevices_lastupdate['Back Door Light']) > 600) then
		commandArray['Back Door Light']='On FOR 10'
	end
end

-- Light Trigger: Car Parking
if (devicechanged['MD West PTZ'] == 'On') and (otherdevices['Front Security Lights'] == 'Off') and (timeofday['Nighttime']) then
	-- Only after light been out for more than 10mins to prevent needless cycling
	if (libs.timedifference(otherdevices_lastupdate['Front Security Lights']) > 600) then
		commandArray['Front Security Lights']='On FOR 10'
	end
end

-- Light Trigger: Trailer Parking
if (devicechanged['MD East IPC'] == 'On') and (otherdevices['Front Door Light'] == 'Off') and (timeofday['Nighttime']) and (notWindy) and (noRain) then
	-- Only after light been out for more than 10mins to prevent needless cycling
	if (libs.timedifference(otherdevices_lastupdate['Back Door Light']) > 600) then
		commandArray['Back Door Light']='On FOR 10'
		commandArray['Front Security Lights']='On FOR 10'
	end
end


return commandArray
