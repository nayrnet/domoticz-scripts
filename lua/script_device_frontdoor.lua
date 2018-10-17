-- Front door actions
commandArray = {}
if (devicechanged['Front Door Mat'] == 'Open') and (timeofday['Nighttime']) then
	commandArray['Mudroom']='On FOR 10'
	if (otherdevices['Security Display'] == 'Off') then
	        commandArray['Security Display']='On FOR 15'
	end
elseif (devicechanged['Front Door Mat'] == 'Open') and (timeofday['Daytime']) then
	commandArray['Mudroom']='On FOR 2'
	commandArray['Front Door Light']='Off'
	commandArray['Front Security Lights']='Off'
end

return commandArray
