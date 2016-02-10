-- Automatically adjust heating setpoint to 60F when back door is left open.

t1 = os.time()
s = otherdevices_lastupdate['Back Door']
heater = otherdevices_svalues['Heater Setpoint']
 
year = string.sub(s, 1, 4)
month = string.sub(s, 6, 7)
day = string.sub(s, 9, 10)
hour = string.sub(s, 12, 13)
minutes = string.sub(s, 15, 16)
seconds = string.sub(s, 18, 19)
 
commandArray = {}
 
t2 = os.time{year=year, month=month, day=day, hour=hour, min=minutes, sec=seconds}
difference = (os.difftime (t1, t2))

if (otherdevices['Back Door'] == 'Open' and difference > 299 and difference < 360) then
	commandArray['SendNotification']='Perimeter Warning#The back door has been open for more than 5 mins..'
	os.execute('espeak "Warning, the back door has been open for more than 5 minutes"')
	commandArray['UpdateDevice']='24|0|60'
	print("Back door left open, adjusting heater setpoint to 60F")
elseif (otherdevices['Back Door'] == 'Open' and difference > 361 and heater ~= '15.56') then
	commandArray['UpdateDevice']='24|0|60'
        print("Back door left open, adjusting heater setpoint to 60F")
elseif (otherdevices['Back Door'] == 'Closed' and difference > 599 and difference < 660 and heater == '15.56') then
	commandArray['UpdateDevice']='24|0|70'
	print("Back door finally closed, adjusting heater setpoint to 70F")
end 
 
return commandArray

