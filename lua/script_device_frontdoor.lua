-- Devices are turned on via ZWave Group association but have Domoticz handle daytime/nightime behavior.
commandArray = {}
if (devicechanged['Front Door'] == 'Open') and (timeofday['Nighttime']) then
	commandArray['Mudroom']='On FOR 10'
	commandArray['Front Door Light']='On FOR 10'
	commandArray['Front Security Lights']='On FOR 60'
elseif (devicechanged['Front Door'] == 'Open') and (timeofday['Daytime']) then
	commandArray['Mudroom']='Off'
	commandArray['Front Door Light']='Off'
	commandArray['Front Security Lights']='Off'
end
return commandArray
