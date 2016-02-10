-- Actions to take when input is changed.
commandArray = {}
if (devicechanged['TV'] == 'NVR') then
	-- WestPTZ Preset
	commandArray['OpenURL']='ptz:ptz@192.168.42.21/cgi-bin/ptz.cgi?action=start&channel=0&code=GotoPreset&arg1=0&arg2=1&arg3=0'
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
