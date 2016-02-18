-- Outdoor Lighting Motion Events
commandArray = {}

-- Backyard
if (devicechanged['MD South IPC'] == 'On') and (otherdevices['Back Door Light'] == 'Off') and (timeofday['Nighttime']) then
	commandArray['Back Door Light']='On FOR 10'
end

-- East Yard
if (devicechanged['MD East IPC'] == 'On') and (otherdevices['Front Door Light'] == 'Off') and (timeofday['Nighttime']) then
	commandArray['Back Door Light']='On FOR 10'
	commandArray['Front Security Lights']='On FOR 10'
end


return commandArray
