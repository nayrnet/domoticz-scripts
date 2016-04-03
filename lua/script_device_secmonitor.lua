-- Actions to take for security monitor.
commandArray = {}
if (devicechanged['Front Door Lock'] == 'Closed') and (otherdevices['Security Display'] == 'Off') then
	commandArray['Security Display']='On for 30'
end
return commandArray
