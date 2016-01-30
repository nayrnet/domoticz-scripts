-- Turn on lights and seucrity camera displays.
commandArray = {}
if (devicechanged['Bed Safe'] == 'Open') and (timeofday['Nighttime']) then
	commandArray['Bedroom Light']='Set Level 50'
	commandArray['TV']='Set Level 40'		-- Security Cameras
	commandArray['Hallway Light']='Set Level 100'
	commandArray['Living Room Lights']='Set Level 100'
	commandArray['Studio Lamp']='Set Level 100'
	commandArray['Kitchen Sink Light']='Set Level 100'
	commandArray['Mudroom']='Set Level 100'
	commandArray['Front Door Light']='On'
	commandArray['Front Security Lights']='On'
end
return commandArray
