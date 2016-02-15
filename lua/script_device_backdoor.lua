-- Back door actions
commandArray = {}

-- ZW Groups turn these on, Reset lights durring daytime, they have local light sensors so wont actually turn on.
if (devicechanged['Back Door'] == 'Open') and (timeofday['Daytime']) then
	commandArray['Back Door Light']='Off'
	commandArray['Front Security Lights']='Off'
end

-- Command PTZ only when Away
if (devicechanged['Back Door'] == 'Open') and (tonumber(uservariables["away"]) > 0) then
	commandArray["West PTZ"]="Set Level 50"
end
return commandArray
