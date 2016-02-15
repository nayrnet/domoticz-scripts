-- Time script for West PTZ
commandArray = {}
libs = require("libs")	-- Include common functions

-- Idle Timeout (10mins)
if (libs.timedifference(otherdevices_lastupdate['West PTZ']) > 600) then
	commandArray['West PTZ']='Set Level ' .. uservariables["WestPTZ-IdlePreset"]
end

return commandArray

