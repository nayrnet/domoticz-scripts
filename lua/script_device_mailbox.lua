-- Send notification when mail has arrived, newmail is reset with script_time_mailbox.lua
commandArray = {}
if (devicechanged['Mailbox'] == 'On') then
	commandArray[1]={['West PTZ']='Set Level 70'}
	commandArray[2]={['West PTZ']='Set Level 10 AFTER 10'}
	if (tonumber(uservariables["newmail"]) == 0) then
		commandArray[3]={['Variable:newmail']='1'}
		commandArray[4]={['SendNotification']='Mail Dispatch#Todays post was just delivered.#0'}
		print("Today's Mail has arrived.")
		os.execute('ogg123 -q ~/audio/alert-prefix.ogg ~/audio/newmail.ogg &')
	else
		commandArray[3]={['SendNotification']='Perimeter Alert#The Mailbox was just accessed.#0'}
		print("Mailbox was just accessed.")
		os.execute('ogg123 -q ~/audio/alert-prefix.ogg ~/audio/mailopen.ogg &')
	end
end
return commandArray
