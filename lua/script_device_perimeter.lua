-- Security Perimeter
perimeterArray = { 'Front Door', 'Back Door', 'Garage Bay Door', 'Bed Safe' }
commandArray = {}
device = next(devicechanged)

-- Perimeter Monitoring
if (tonumber(uservariables["away"]) > 0) and (perimeterArray[device]) and ((devicechanged[device] == 'On') or (devicechanged[device] == 'Open')) then
	print('** Perimeter Breach while Away **')
	os.execute('ogg123 -q ~/audio/siren.ogg &')
	commandArray['SendNotification'] 	= 'Security Alert#The ' .. device .. ' was just accessed while you were away.#1'
	commandArray['WebCam'] 			= 'On AFTER 30'
	commandArray['Front Door Light'] 	= 'On' 
	commandArray['Front Security Lights'] 	= 'On' 
	commandArray['Back Door Light']		= 'On'
	commandArray['Living Room Lights'] 	= 'Set Level 100' 
	commandArray['Kitchen Sink Light'] 	= 'Set Level 100'
	commandArray['MudRoom']			= 'Set Level 100'
end

return commandArray
