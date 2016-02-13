-- Time script for West PTZ
commandArray = {}
libs = require("libs")	-- Include common functions

-- Idle Timeout (10mins)
if (otherdevices['West PTZ'] ~= 'Idle') and (libs.timedifference(otherdevices_lastupdate['West PTZ']) > 600) then
	commandArray['West PTZ']='Idle'
end

return commandArray

