-- Send notification when mail has arrived, newmail is reset with script_time_mailbox.lua
commandArray = {}
if (devicechanged['Mailbox'] == 'Open') and (uservariables["newmail"] == "0") then
	commandArray['Variable:newmail']="1"
	print("Today's Mail has arrived.")
	commandArray['SendNotification']='Mail Dispatch#Todays post was just delivered.#0'
elseif (devicechanged['Mailbox'] == 'Open') and (uservariables["newmail"] == "1") then
	print("Mailbox was just accessed.")
end
return commandArray
