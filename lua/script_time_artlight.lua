-- Time script for dining room art light
commandArray = {} 
time = os.date("*t") 

-- Art Light - After 10pm Dim the Artlight until TV shuts off..
if (otherdevices['Art Light'] ~= 'Off') and ((time.hour >= 22) or (time.hour < 12)) then
	if (otherdevices['TV'] == 'Off') then
		commandArray['Art Light']='Off' 
	elseif (tonumber(otherdevices_svalues["Art Light"]) > 50) then
		commandArray['Art Light']='Set Level 35' 
	end
elseif (otherdevices['Art Light'] == 'Off') and (time.hour < 22) and (time.hour > 12) and (timeofday['Nighttime']) then
	if (tonumber(uservariables["away"]) < 1) then
		commandArray['Art Light']='Set Level 100'
	end
end

return commandArray

