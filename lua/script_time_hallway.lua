-- Time script for Hallway Light
commandArray = {}
libs = require("libs")	-- Include common functions

-- Shut off if on for more than an hour.
if (otherdevices['Hallway Light'] ~= 'Off') and (libs.timedifference(otherdevices_lastupdate['Hallway Light']) > 1800) then
	commandArray['Hallway Light']='Off'
	print("Shutting off hallway lights after 30mins")
end
return commandArray

