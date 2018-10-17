-- Time Script for Fireplace
commandArray = {} 
libs = require("libs")	-- Include common functions
time = os.date("*t") 
coolerChanged = libs.timedifference(otherdevices_lastupdate['Office Cooler'])

if (otherdevices['Office Cooler'] == 'Off') and (otherdevices_temperature['Online Weather'] > 25) and (coolerChanged > 3600) then
	commandArray['Office Cooler']='On'
	print('Its hot outside, turning on office cooler..')
end

if (otherdevices['Office Cooler'] ~= 'Off') and (otherdevices_temperature['Online Weather'] < 24) and (coolerChanged > 3600) then
	commandArray['Office Cooler']='Off' 
	print('Too cold outside for office cooler, shutting off..')
end

return commandArray

