-- turn dummy push-on switches back off

commandArray = {}
if (devicechanged['West PTZ Idle (Update)'] == 'On') then
        commandArray['West PTZ Idle (Update)']='Off AFTER 5'
end

return commandArray
