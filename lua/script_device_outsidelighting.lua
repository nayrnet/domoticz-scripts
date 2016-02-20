-- Outdoor Lighting Motion Events
commandArray = {}
libs = require("libs")	-- Include common functions

-- Backyard
if (devicechanged['MD South IPC'] == 'On') and (otherdevices['Back Door Light'] == 'Off') and (timeofday['Nighttime']) then
	-- Only after light been out for more than 10mins to prevent needless cycling
	if (libs.timedifference(otherdevices_lastupdate['Back Door Light']) > 600) then
		commandArray['Back Door Light']='On FOR 10'
	end
end

-- East Yard
if (devicechanged['MD East IPC'] == 'On') and (otherdevices['Front Door Light'] == 'Off') and (timeofday['Nighttime']) then
	-- Only after light been out for more than 10mins to prevent needless cycling
	if (libs.timedifference(otherdevices_lastupdate['Back Door Light']) > 600) then
		commandArray['Back Door Light']='On FOR 10'
		commandArray['Front Security Lights']='On FOR 10'
	end
end


return commandArray
