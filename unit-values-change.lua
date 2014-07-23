--change-values.lua v1.0
--[[TODO
--]]

function split(str, pat)
   local t = {}  -- NOTE: use {n = 0} in Lua-5.0
   local fpat = "(.-)" .. pat
   local last_end = 1
   local s, e, cap = str:find(fpat, 1)
   while s do
      if s ~= 1 or cap ~= "" then
	 table.insert(t,cap)
      end
      last_end = e+1
      s, e, cap = str:find(fpat, last_end)
   end
   if last_end <= #str then
      cap = str:sub(last_end)
      table.insert(t, cap)
   end
   return t
end

function createcallback(etype,unitTarget,ctype,strength,save)
	return function(reseteffect)
		effect(etype,unitTarget,ctype,strength,save,-1)
	end
end
function effect(e,unitTarget,ctype,strength,save,dir)
	local value = 0
	local t = 0
	local int16 = 30000
	local int32 = 200000000
	if (e == 'webbed' or e == 'stunned' or e == 'winded' or e == 'unconscious' or e == 'pain'
	or e == 'nausea' or e == 'dizziness') then
		value = unitTarget.counters[e]
		if dir == 1 then save = value end
		if ctype == 'fixed' then
			value = value + strength
		elseif ctype == 'percent' then
			local percent = (100+strength)/100
			value = math.floor(value*percent)
		elseif ctype == 'set' then
			value = strength
		end
		if value > int16 then value = int16 end
		if value < 0 then value = 0 end
		if dir == -1 then value = save end
		unitTarget.counters[e] = value
	elseif (e == 'paralysis' or e == 'numbness' or e == 'fever' or e == 'exhaustion' 
	or e == 'hunger' or e == 'thirst' or e == 'sleepiness') then
		if (e == 'hunger' or e == 'thirst' or e == 'sleepiness') then e = e .. '_timer' end
		value = unitTarget.counters2[e]
		if dir == 1 then save = value end
		if ctype == 'fixed' then
			value = value + strength
		elseif ctype == 'percent' then
			local percent = (100+strength)/100
			value = math.floor(value*percent)
		elseif ctype == 'set' then
			value = strength
		end
		if value > int16 then value = int16 end
		if value < 0 then value = 0 end
		if dir == -1 then value = save end
		unitTarget.counters2[e] = value
	elseif e == 'blood' then
		if dir == 1 then save = value end
		if ctype == 'fixed' then
			value = value + strength
		elseif ctype == 'percent' then
			local percent = (100+strength)/100
			value = math.floor(value*percent)
		elseif ctype == 'set' then
			value = strength
		end
		if value > unitTarget.body.blood_max then value = unitTarget.body.blood_max end
		if value < 0 then value = 0 end
		unitTarget.body.blood_count = value
	elseif e == 'infection' then
		value = unitTarget.body.infection_level
		if dir == 1 then save = value end
		if ctype == 'fixed' then
			value = value + strength
		elseif ctype == 'percent' then
			local percent = (100+strength)/100
			value = math.floor(value*percent)
		elseif ctype == 'set' then
			value = strength
		end
		if value > int16 then value = int16 end
		if value < 0 then value = 0 end
		unitTarget.body.infection_level = value
	end
end

validArgs = validArgs or utils.invert({
 'help',
 'token',
 'fixed',
 'percent',
 'set',
 'dur',
 'unit',
})
local args = utils.processArgs({...}, validArgs)

if args.help then -- Help declaration
 print("TODO - Help Section")
 return
end

if args.unit and tonumber(args.unit) then -- Check for unit declaration
	unit = df.unit.find(tonumber(args.unit))
else
	print('No unit selected')
	return
end
if args.token then -- Check which tokens to change
	if type(args.token) == 'table' then
		token = args.token
	else
		token = {args.token}
	end
else
	print('No token to change set')
	return
end
if args.fixed then -- Check for type of change to make (fixed, percent, or set)
	mode = 'fixed'
	if type(args.fixed) == 'table' then
		value = args.fixed
	else
		value = {args.fixed}
	end
elseif args.percent then
	mode = 'percent'
	if type(args.percent) == 'table' then
		value = args.percent
	else
		value = {args.percent}
	end
elseif args.set then
	mode = 'set'
	if type(args.set) == 'table' then
		value = args.set
	else
		value = {args.set}
	end
else
	print('No method of changing token set')
	return
end
if args.dur and tonumber(args.dur) then -- Check if there is a duration
	dur = tonumber(args.dur)
else
	dur = 0
end

for i,etype in ipairs(token) do -- !!RUN EFFECT!!
	save = effect(etype,unit,mode,tonumber(value[i]),0,1)
	if dur > 0 then
		dfhack.timeout(dur,'ticks',createcallback(etype,unit,mode,tonumber(value[i]),save))
	end
end


