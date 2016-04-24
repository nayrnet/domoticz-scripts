-- Front door actions
commandArray = {}
if (devicechanged['Front Door'] == 'Open') and (timeofday['Nighttime']) then
	commandArray['Mudroom']='On FOR 10'
	commandArray['Front Door Lock']='Off'
	if (otherdevices['Security Display'] == 'Off') then
	        commandArray['Security Display']='On FOR 15'
	end
elseif (devicechanged['Front Door'] == 'Open') and (timeofday['Daytime']) then
	commandArray['Mudroom']='On FOR 2'
	commandArray['Front Door Light']='Off'
	commandArray['Front Security Lights']='Off'
	commandArray['Front Door Lock']='Off'
end

return commandArray
