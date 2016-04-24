-- Send notification when mail has arrived, newmail is reset with script_time_mailbox.lua
commandArray = {}
time = os.date("*t")

if (devicechanged['Mailbox'] == 'On') then
	commandArray[1]={['West PTZ']='Set Level 70'}
	commandArray[2]={['North PTZ']='Set Level 20'}
	commandArray[3]={['North PTZ']='Set Level 10 AFTER 90'}
        commandArray[4]={['West PTZ']='Set Level ' .. uservariables["WestPTZ-IdlePreset"] .. ' AFTER 10'}
	if (tonumber(uservariables["newmail"]) == 0) and ((time.hour < 21) or (time.hour > 11))  then
		commandArray[5]={['Variable:newmail']='1'}
		commandArray[6]={['SendNotification']='Mail Dispatch#Todays post was just delivered.#0'}
		print("Today's Mail has arrived.")
		os.execute('ogg123 -q ~/audio/alert-prefix.ogg ~/audio/newmail.ogg &')
	else
		commandArray[5]={['SendNotification']='Perimeter Alert#The Mailbox was just accessed.#0'}
		print("Mailbox was just accessed.")
		os.execute('ogg123 -q ~/audio/alert-prefix.ogg ~/audio/mailopen.ogg &')
	end
end

if (devicechanged['Parcel Box'] == 'Open') then
	commandArray[1]={['North PTZ']='Set Level 40'}
	if (tonumber(uservariables["newparcel"]) == 0) and ((time.hour < 21) or (time.hour > 6)) then
		commandArray[2]={['Variable:newparcel']='1'}
		commandArray[3]={['SendNotification']='Mail Dispatch#A parcel was just delivered.#0'}
		print("A Parcel was just delivered.")
		os.execute('ogg123 -q ~/audio/alert-prefix.ogg ~/audio/newpackage.ogg &')
	else
		commandArray[2]={['SendNotification']='Perimeter Alert#The parcel box was just accessed.#0'}
		print("Parcel box just accessed.")
		os.execute('ogg123 -q ~/audio/alert-prefix.ogg ~/audio/mailopen.ogg &')
	end
elseif (devicechanged['Parcel Box'] == 'Closed') then
	commandArray[1]={['North PTZ']='Set Level 20'}
	commandArray[2]={['North PTZ']='Set Level 10 AFTER 15'}
end
return commandArray
