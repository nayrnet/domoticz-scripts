-- Time script for MudRoom
commandArray = {}
libs = require("libs")	-- Include common functions

-- Shut off if on for more than 10mins.
if (otherdevices['MudRoom'] ~= 'Off') and (libs.timedifference(otherdevices_lastupdate['MudRoom']) > 600) then
	commandArray['MudRoom']='Off'
	print("Shutting off mudroom lights after 10mins")
end
return commandArray

