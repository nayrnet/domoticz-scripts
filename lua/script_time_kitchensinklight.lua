-- Time script for Kitchen Sink
commandArray = {}
libs = require("libs")	-- Include common functions

-- Shut off if on for more than an hour.
if (otherdevices['Kitchen Sink Light'] ~= 'Off') and (libs.timedifference(otherdevices_lastupdate['Kitchen Sink Light']) > 3600) then
	commandArray['Kitchen Sink Light']='Off'
	print("Shutting off Kitchen Sink lights after 60mins")
end
return commandArray

