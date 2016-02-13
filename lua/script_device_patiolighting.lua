-- Disable Motion Sensor on back patio so it stays on full bright constantly.

commandArray = {}
if (devicechanged['Patio Lighting'] == 'On') and (otherdevices['Back Door Light'] == 'Off') then
	commandArray['Patio Lighting']='Off'
	commandArray['Back Door Light']='On'	
        commandArray['Patio Lighting']='On AFTER 30'
elseif (devicechanged['Patio Lighting'] == 'On') and (otherdevices['Back Door Light'] == 'On') then
	commandArray['Back Door Light']='Off'
end

if (devicechanged['Back Door Light'] == 'Off') and (otherdevices['Patio Lighting'] == 'On') then
	commandArray['Back Door Light']='On AFTER 1'
	commandArray['Patio Lighting']='Off'	
end
return commandArray
