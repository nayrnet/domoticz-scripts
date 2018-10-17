-- Time script for Bathroom Lights
commandArray = {}
libs = require("libs")	-- Include common functions

-- Shut off if on for more than 60 mins.
if (otherdevices['Bathroom Light'] ~= 'Off') and (libs.timedifference(otherdevices_lastupdate['Bathroom Light']) > 3600) then
	commandArray['Bathroom Light']='Off'
	print("Shutting off bathroom lights after 1h")
end
return commandArray
