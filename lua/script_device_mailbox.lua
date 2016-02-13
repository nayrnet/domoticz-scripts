-- Send notification when mail has arrived, newmail is reset with script_time_mailbox.lua
commandArray = {}
if (devicechanged['Mailbox'] == 'Open') and (tonumber(uservariables["newmail"]) == 0) then
	commandArray['Variable:newmail']="1"
	print("Today's Mail has arrived.")
	commandArray['SendNotification']='Mail Dispatch#Todays post was just delivered.#0'
	os.execute('ogg123 -q ~/audio/newmail.ogg')
elseif (devicechanged['Mailbox'] == 'Open') and (tonumber(uservariables["newmail"]) == 1) then
	print("Mailbox was just accessed.")
	commandArray['SendNotification']='Perimeter Alert#The Mailbox was just accessed.#0'
	os.execute('ogg123 -q ~/audio/mailopen.ogg')
end
return commandArray
