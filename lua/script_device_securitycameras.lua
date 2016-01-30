-- Changes camera preset when input is changed.
commandArray = {}
if (devicechanged['TV']) and (otherdevices_svalues['TV'] == "40") then
	commandArray['OpenURL']='ptz:ptz@192.168.42.21/cgi-bin/ptz.cgi?action=start&channel=0&code=GotoPreset&arg1=0&arg2=1&arg3=0'
end
return commandArray
