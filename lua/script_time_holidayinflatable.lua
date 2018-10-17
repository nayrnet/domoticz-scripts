-- Turn off Holiday Inflatables if it gets windy out or starts raining.
commandArray = {} 

if (otherdevices['Outdoor Holiday Lights'] ~= 'Off') then
	if (otherdevices_windspeed['Wind'] > 15) or (otherdevices_windgust['Wind'] > 20) then
		print('Deflating Holiday Decorations, too windy!')
		commandArray['Outdoor Holiday Lights']='Off' 
	end
	if (otherdevices_rain['Rain Fall'] > 0) or (otherdevices_rain_lasthour['Rain Fall'] > 0) then
		print('Deflating Holiday Decorations, its raining or snowing!')
		commandArray['Outdoor Holiday Lights']='Off' 
	end
end

return commandArray

