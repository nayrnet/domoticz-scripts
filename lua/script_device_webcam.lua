-- WebCam Virtural Switch (Take Snapshot)
commandArray = {}
if (devicechanged['WebCam'] == 'On') then
	commandArray['WebCam']='Off AFTER 10'
end

if (devicechanged['TV'] ~= 'Off') and (otherdevices['Ryans Android'] ~= 'On') then
	commandArray['WebCam']='On AFTER 7'
end
return commandArray
