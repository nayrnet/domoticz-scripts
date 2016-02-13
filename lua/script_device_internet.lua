-- Speak when Internet is lost or restored
commandArray = {}
if (devicechanged['Internet'] == 'On') then
	os.execute('ogg123 -q ~/audio/internetup.ogg')
elseif (devicechanged['Internet'] == 'Off') then
	os.execute('ogg123 -q ~/audio/internetdown.ogg')
end
return commandArray
