--script_time_washingmachine.lua

--Change the values below to reflect to your own setup
local washer_status_uservar   = 'washingmachine_status'
local energy_consumption      = 'Washing Machine'	         --Name of Z-Wave plug that contains actual consumption of washingmachine (in Watts)
local washer_counter_uservar  = 'washingmachine_counter'        --Name of the uservariable that will contain the counter that is needed
local idle_minutes            = 5                               --The amount of minutes the consumption has to stay below the 'consumption_lower' value
local consumption_upper       = 20                              --If usage is higher than this value (Watts), the washingmachine has started
local consumption_lower       = 4.3                             --If usage is lower than this value (Watts), the washingmachine is idle for a moment/done washing

sWatt, sTotalkWh              = otherdevices_svalues[energy_consumption]:match("([^;]+);([^;]+)")
washer_usage                  = tonumber(sWatt)
-- washer_usage                  = tonumber(otherdevices_svalues[energy_consumption])

commandArray = {}

--Virtual switch is off, but consumption is higher than configured level, so washing has started
if (washer_usage > consumption_upper) and uservariables[washer_status_uservar] == 0 then
  commandArray['Variable:' .. washer_status_uservar]='1'
  print('Current power usage (' ..washer_usage.. 'W) is above upper boundary (' ..consumption_upper.. 'W), so washing has started!')
  commandArray['Variable:' .. washer_counter_uservar]=tostring(idle_minutes)
end

--Washing machine is not using a lot of energy, check the counter
if (washer_usage < consumption_lower) and uservariables[washer_status_uservar] == 1 then 
  commandArray['Variable:' .. washer_counter_uservar]=tostring(math.max(tonumber(uservariables[washer_counter_uservar]) - 1, 0))
  print('Current power usage (' ..washer_usage.. 'W) is below lower boundary (' ..consumption_lower.. 'W), washer is idle or almost ready')
  print('Subtracting counter, old value: ' ..uservariables[washer_counter_uservar].. ' minutes')
elseif ((uservariables[washer_counter_uservar] ~= idle_minutes) and uservariables[washer_status_uservar] == 1) then
  commandArray['Variable:' .. washer_counter_uservar]=tostring(idle_minutes)
  print('Resetting Washing Machine Timer')
end

--Washingmachine is done
if ((uservariables[washer_status_uservar] == 1) and uservariables[washer_counter_uservar] == 0) then
  print('Washingmachine is DONE')
  print('Current power usage washingmachine ' ..washer_usage.. 'W')
  print('Washingmachine is done, please go empty it!')
  commandArray['SendNotification']='Cycle Ended: Washing Machine#The load in the washing machine has finsihed, please move it to the dryer!#0'                                         
  commandArray['Variable:' .. washer_status_uservar]='0'
  time = os.date("*t")
  if (time.hour > 6) then
	  os.execute('ogg123 -q ~/audio/alert-prefix.ogg ~/audio/washingmachine.ogg')
  end
end

return commandArray
