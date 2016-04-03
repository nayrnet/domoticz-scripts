-- Front door actions
commandArray = {}
if (devicechanged['Front Door'] == 'Open') and (timeofday['Nighttime']) then
	commandArray['Mudroom']='On FOR 10'
elseif (devicechanged['Front Door'] == 'Open') and (timeofday['Daytime']) then
	commandArray['Mudroom']='On FOR 2'
	commandArray['Front Door Light']='Off'
	commandArray['Front Security Lights']='Off'
end

if (devicechanged['Front Door'] == 'Open') and (otherdevices['Security Display'] == 'Off') then
        commandArray['Security Display']='On FOR 600'
end

return commandArray
