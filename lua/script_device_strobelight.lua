-- Activate external strobe light
commandArray = {}
time = os.date("*t")

if (devicechanged['Mailbox'] == 'On') and (time.hour < 7) then
	commandArray['Front Strobe']='On FOR 1' -- minutes
	print("Strobe Activated because its too late at night for normal access")
end

if (devicechanged['Parcel Box'] == 'Open') and (time.hour < 7) then
	commandArray['Front Strobe']='On FOR 1' -- minutes
	print("Strobe Activated because its too late at night for normal access")
end

if (devicechanged['West Gate'] == 'Open') and (time.hour < 7) then
	commandArray['Front Strobe']='On FOR 1' -- minutes
	print("Strobe Activated because its too late at night for normal access")
end

if (devicechanged['East Gate'] == 'Open') and (time.hour < 7) then
	commandArray['Front Strobe']='On FOR 1' -- minutes
	print("Strobe Activated because its too late at night for normal access")
end
return commandArray
