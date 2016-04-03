-- simply reset the newmail variable every typical postal day a few hours before the mail typically arrives.

time = os.date("*t")
day = os.date("%A")

commandArray = {}
if (time.hour == 13) and (time.min == 15) and (day ~= 'Sunday') then
        commandArray['Variable:newmail']="0"
elseif (time.hour == 06) and (time.min == 30) then
        commandArray['Variable:newparcel']="0"
end
return commandArray

