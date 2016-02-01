-- Front door actions
commandArray = {}
if (devicechanged['Front Door'] == 'Open') and (timeofday['Nighttime']) then
	commandArray['Mudroom']='On FOR 10'
elseif (devicechanged['Front Door'] == 'Open') and (timeofday['Daytime']) then
	commandArray['Mudroom']='On FOR 2'
	commandArray['Front Door Light']='Off'
	commandArray['Front Security Lights']='Off'
end
return commandArray
