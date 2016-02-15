-- Speak when Internet is lost or restored
commandArray = {}
if (devicechanged['Internet'] == 'On') then
	os.execute('ogg123 -q ~/audio/alert-prefix.ogg ~/audio/internetup.ogg')
elseif (devicechanged['Internet'] == 'Off') then
	os.execute('ogg123 -q ~/audio/alert-prefix.ogg ~/audio/internetdown.ogg')
end
return commandArray
