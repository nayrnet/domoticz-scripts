-- Backyard Gate Monitoring
commandArray = {}

-- West Gate
if (devicechanged['West Gate'] == 'Open') then
	print("West Gate Open!")
	commandArray[1]={['SendNotification']='Perimeter Alert#The West Gate was just accessed.#1'}
	commandArray[2]={['West PTZ']='Set Level 80'}
	commandArray[3]={['West PTZ']='Set Level 10 AFTER 120'}
	os.execute('ogg123 -q ~/audio/alert-prefix.ogg ~/audio/westgate.ogg &')
	if (otherdevices['Back Door Light'] == 'Off') and (timeofday['Nighttime']) then
		commandArray[4]={['Back Door Light']='On FOR 15'}
	end
	if (otherdevices['Front Security Lights'] == 'Off') and (timeofday['Nighttime']) then
		commandArray[5]={['Front Security Lights']='On FOR 15'}
	end
	if (otherdevices['Front Door Light'] == 'Off') and (timeofday['Nighttime']) then
		commandArray[6]={['Front Security Lights']='On FOR 15'}
	end
	if (otherdevices['Bedroom Light'] == 'Off') and (timeofday['Nighttime']) then
		commandArray[7]={['Bedroom Light']='On FOR 5'}
	end
end

return commandArray
