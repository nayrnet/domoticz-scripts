-- Time script for West PTZ
commandArray = {}
libs = require("libs")	-- Include common functions

-- Idle Timeout (10mins)
if (libs.timedifference(otherdevices_lastupdate['West PTZ']) > 600) then
	commandArray['West PTZ']='Set Level ' .. uservariables["WestPTZ-IdlePreset"]
end

-- Change Idle Preset for Day/Night
if (timeofday['Nighttime']) and (tonumber(uservariables["WestPTZ-IdlePreset"]) ~= 60) and (tonumber(uservariables["away"]) < 1) then
	commandArray["Variable:WestPTZ-IdlePreset"]="60"
elseif (timeofday['Daytime']) and (tonumber(uservariables["WestPTZ-IdlePreset"]) ~= 10) then
	commandArray["Variable:WestPTZ-IdlePreset"]="10"
end

return commandArray

