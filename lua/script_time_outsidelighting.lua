-- Time script for Outside Lighting
commandArray = {}
time = os.date("*t")
libs = require("libs")	-- Include common functions

-- Front Door: Shut off if on for more than 30mins after 10pm.
if (otherdevices['Front Door Light'] ~= 'Off') and (libs.timedifference(otherdevices_lastupdate['Front Door Light']) > 1800) and 
	((time.hour > 22) or (time.hour < 16)) then
		commandArray['Front Door Light']='Off'
end

-- Front Security Lighting: Shut off if on for more than 30mins after Midnight once the TV is Off.
if (otherdevices['Front Security Lights'] ~= 'Off') and (libs.timedifference(otherdevices_lastupdate['Front Security Lights']) > 1800) and 
	((time.hour > 0) or (time.hour < 5)) and (otherdevices['TV'] == 'Off') then
		commandArray['Front Security Lights']='Off'
end
return commandArray

