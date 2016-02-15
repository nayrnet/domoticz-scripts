-- WebCam Virtural Switch (Take Snapshot)
commandArray = {}
if (devicechanged['WebCam'] == 'On') then
	commandArray['WebCam']='Off AFTER 10'
end

return commandArray
