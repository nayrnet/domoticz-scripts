-- ZWave Tamper Alarms, added as motion sensor w/name: tamper-device
commandArray = {}
dev = next(devicechanged)
match = tostring(dev)
if (match:sub(1,7) == 'tamper') and (otherdevices[dev] == 'On') then
	print('** Tamper Alarm triggered **')
	commandArray['SendNotification']='Security Alert#A device was tampered with: ' .. dev .. '#1'
end
return commandArray
