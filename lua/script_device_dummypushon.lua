-- turn dummy push-on switches back off

commandArray = {}
if (devicechanged['West PTZ Car Location'] == 'On') then
        commandArray['West PTZ Car Location']='Off AFTER 5'
end

return commandArray
