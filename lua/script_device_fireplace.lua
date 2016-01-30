-- Fireplace Script / Turn on fireplace when its colder than 21C/70F and security disarmed; otherwords shut it off.

commandArray = {}
if(devicechanged['Online Weather']) then
	if (devicechanged['Online Weather_Temperature'] < 21 and otherdevices['Security Panel'] == 'Normal') then
		if (otherdevices['Fireplace'] == 'Off') then
			commandArray['Fireplace']='On'
			print("Its cold outside, turning the fireplace on.")
		end
	elseif (otherdevices['Fireplace'] == 'On') then
		commandArray['Fireplace']='Off'
                print("Turning the fireplace off, proabibly because its too hot outside.")
	end

end
return commandArray
