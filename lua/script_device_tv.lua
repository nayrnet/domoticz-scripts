-- Actions to take when input is changed.
commandArray = {}
if (devicechanged['TV'] == 'NVR') then
	-- WestPTZ Preset
	commandArray['West PTZ']='Set Level 10'
end
return commandArray
