-- simply reset the newmail variable every day before the mail arrives.
time = os.date("*t")
commandArray = {}
if (time.hour == 13) and (time.min == 15) then
        commandArray['Variable:newmail']="0"
end
return commandArray

