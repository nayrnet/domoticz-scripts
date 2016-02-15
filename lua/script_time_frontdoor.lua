-- Time script for Front Door
commandArray = {}
libs = require("libs")	-- Include common functions

-- Notify if open for more than 5mins
if (otherdevices['Front Door'] == 'Open') and (libs.timedifference(otherdevices_lastupdate['Front Door']) > 300) then
	commandArray['SendNotification']='Perimeter Alert#The FRONT door has been open for more than 5 mins!'
	os.execute('ogg123 -q ~/audio/alert-prefix.ogg ~/audio/frontdoor.ogg')
end
return commandArray

