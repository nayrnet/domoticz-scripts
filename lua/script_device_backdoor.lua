-- Back door actions
commandArray = {}

-- ZW Groups turn these on, Reset lights durring daytime, they have local light sensors so wont actually turn on.
if (devicechanged['Back Door'] == 'Open') and (timeofday['Daytime']) then
	commandArray['Back Door Light']='Off'
	commandArray['Front Security Lights']='Off'
elseif (devicechanged['Back Door'] == 'Open') and (timeofday['Nighttime']) then
	if (otherdevices['Back Door Light'] == 'Off') then
		commandArray['Back Door Light']='On FOR 10'
	end
	if (otherdevices['Front Security Lights'] == 'Off') then
		commandArray['Front Security Lights']='On FOR 10'
	end
end

-- Command PTZ only when Away
if (devicechanged['Back Door'] == 'Open') and (tonumber(uservariables["away"]) > 0) then
	commandArray[1]={['West PTZ']='Set Level 50'}
	commandArray[2]={['West PTZ']='Set Level 40 AFTER 30'}
        commandArray[3]={['West PTZ']='Set Level ' .. uservariables["WestPTZ-IdlePreset"] .. ' AFTER 120'}
end
return commandArray
