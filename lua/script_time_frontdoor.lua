-- Time script for Front Door
commandArray = {}
libs = require("libs")	-- Include common functions

doorChanged = libs.timedifference(otherdevices_lastupdate['Front Door'])

-- Notify if open for more than 5mins
if (otherdevices['Front Door'] == 'Open') and ((doorChanged > 299) and (doorChanged < 361)) then
	commandArray['SendNotification']='Perimeter Alert#The FRONT door has been open for more than 5 mins!'
	os.execute('ogg123 -q ~/audio/alert-prefix.ogg ~/audio/frontdoor.ogg')
end

-- Force Door to lock after 5mins (zwave funkyness)
if (otherdevices['Front Door'] == 'Closed') and ((doorChanged > 299) and (doorChanged < 361)) then
	commandArray[1]={['OpenURL']='localhost:8080/json.htm?type=command&param=udevice&idx=253&nvalue=0'}
	commandArray[2]={['Front Door Lock']='Open AFTER 30'}
        print('Locking Front Door')
end
return commandArray

