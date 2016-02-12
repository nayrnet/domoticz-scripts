-- Time Script for Fireplace
commandArray = {} 
time = os.date("*t") 

-- Fireplace: Shut off after 10pm once the TV turns off, otherwise turn on after 7am if under 50F
if (otherdevices['Fireplace'] ~= 'Off') and ((time.hour >= 22) or (time.hour < 7)) and (otherdevices['TV'] == 'Off') then
		commandArray['Fireplace']='Off' 
elseif (otherdevices['Fireplace'] == 'Off') and (time.hour < 22) and (time.hour > 6) and (otherdevices_temperature['Online Weather'] < 10) then
	if (tonumber(uservariables["away"]) < 1) then
		commandArray['Fireplace']='On'
		print('Its cold outside, turning on fireplace..')
	end
end

-- Fireplace: Shutoff if its warmer than 55F outside
if (otherdevices['Fireplace'] ~= 'Off') and (otherdevices_temperature['Online Weather'] > 13) then
		commandArray['Fireplace']='Off' 
		print('Too warm outside for fireplace, shutting off..')
end

return commandArray

