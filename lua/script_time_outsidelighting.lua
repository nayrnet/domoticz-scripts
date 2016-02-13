-- Time script for Outside Lighting, they have onboard light sensors and brighten with motion.
-- They are very sensitive so I shut them off late at night unless something physical happens.

commandArray = {}
time = os.date("*t")
libs = require("libs")	-- Include common functions

-- Front Door: Shut off if on for more than 15mins after 10pm. Otherwise force it on in evening.
if (otherdevices['Front Door Light'] ~= 'Off') and (libs.timedifference(otherdevices_lastupdate['Front Door Light']) >= 900)
	and ((time.hour >= 22) or (time.hour < 12)) then
		commandArray['Front Door Light']='Off' 
elseif (otherdevices['Front Door Light'] == 'Off') and (time.hour < 22) and (time.hour > 12) and (timeofday['Nighttime']) then
		commandArray['Front Door Light']='On'
end

-- Back Door: Shut off if on for more than 30mins after 10pm once the TV is Off. Otherwise force it on in evening.
if (otherdevices['Back Door Light'] ~= 'Off') and (libs.timedifference(otherdevices_lastupdate['Back Door Light']) >= 1800)
	and ((time.hour >= 22) or (time.hour < 12)) and (otherdevices['TV'] == 'Off') then
		commandArray['Back Door Light']='Off' 
elseif (otherdevices['Back Door Light'] == 'Off') and (time.hour < 22) and (time.hour > 12) and (timeofday['Nighttime']) and (otherdevices['Patio Lighting'] ~= 'On') then
		commandArray['Back Door Light']='On'
end

-- Front Security Lighting: Shut off if on for more than 60mins after Midnight once the TV is Off. Otherwise force it on in evening. 
if (otherdevices['Front Security Lights'] ~= 'Off') and (libs.timedifference(otherdevices_lastupdate['Front Security Lights']) >= 3600)
	and (time.hour < 12) and (otherdevices['TV'] == 'Off') then
		commandArray['Front Security Lights']='Off'
elseif (otherdevices['Front Security Lights'] == 'Off') and (time.hour > 12) and (timeofday['Nighttime']) then
		commandArray['Front Security Lights']='On'
end

return commandArray

