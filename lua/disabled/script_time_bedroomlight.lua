-- Time script for Bedroom
commandArray = {}
libs = require("libs")	-- Include common functions

-- Shut off if on for more than 30mins.
if (otherdevices['Bedroom Light'] ~= 'Off') and (libs.timedifference(otherdevices_lastupdate['Bedroom Light']) > 1800) then
	commandArray['Bedroom Light']='Off'
	print("Shutting off bedroom lights after 30mins.")
end
return commandArray

