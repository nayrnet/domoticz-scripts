-- Play Sound file automatically

commandArray = {}
time = os.date("*t")
day = os.date("%A")

if ((time.hour == 7) or (time.hour == 19)) and (time.min == 45) then 
	commandArray['SendNotification']='Feed Crash#And give him his shot'
        os.execute('ogg123 -q ~/audio/alert-prefix.ogg ~/audio/crash-shot.ogg &')
end 
 
return commandArray

