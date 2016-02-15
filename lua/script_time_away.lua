-- Go Away when Mobiles are off, come back when Mobiles are on

commandArray = {}
if (otherdevices["Ryans Android"] == "On") or (otherdevices["Cassidis iPhone"] == "On") then
	if (tonumber(uservariables["away"]) > 0) then
		commandArray["Variable:WestPTZ-IdlePreset"]="60"
		commandArray["Variable:away"]="0"
		print("Away mode inactive")
	end
elseif (otherdevices["Ryans Android"] == "Off") and (otherdevices["Cassidis iPhone"] == "Off") then
	if (tonumber(uservariables["away"]) < 1) then
		commandArray["Variable:WestPTZ-IdlePreset"]="10"
		commandArray["Variable:away"]="1"
		print("Away mode active")
	end
end
return commandArray

