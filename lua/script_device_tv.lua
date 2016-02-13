-- Actions to take when input is changed.
commandArray = {}
if (devicechanged['TV'] == 'NVR') then
	-- WestPTZ Preset
	commandArray['West PTZ']='Front Yard'
elseif (devicechanged['TV'] == 'FM') then
	-- Extended Stereo
	commandArray['Receiver'] = 'Set Level 70'
elseif (devicechanged['TV'] == 'PS3') then
	-- Stream Direct
	commandArray['Receiver'] = 'Set Level 30'
elseif (devicechanged['TV'] == 'PS4') then
	-- Stream Direct
	commandArray['Receiver'] = 'Set Level 30'
elseif (devicechanged['TV'] == 'TV') then
	-- Auto Surround
	commandArray['Receiver'] = 'Set Level 10'
end
return commandArray
