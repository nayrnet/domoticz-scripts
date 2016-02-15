-- Back door actions
commandArray = {}
if (devicechanged['Back Door'] == 'Open') and (timeofday['Daytime']) then
	commandArray['Back Door Light']='Off'
	commandArray['Front Security Lights']='Off'
end
return commandArray
