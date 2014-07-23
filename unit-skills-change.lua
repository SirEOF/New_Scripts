--change-skills.lua v1.0
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
function effect(skill,unit,ctype,strength,save,dir)
	local skills = unit.status.current_soul.skills
	local skillid = df.job_skill[skill]
	local value = 0
	local found = false

	if skills ~= nil then
		for i,x in ipairs(skills) do
			if x.id == skillid then
				if dir == 1 then save = x.rating end
				found = true
				if ctype == 'fixed' then
					value = x.rating + strength
				end
				if ctype == 'percent' then
					percent = (100 + strength)/100
					value = x.rating*percent
				end
				if ctype == 'set' then
					value = strength
				end
				if dir == -1 then value = save end
				if value > 20 then value = 20 end
				if value < 0 then value = 0 end
				x.rating = value
			end
		end
	end

	if not found then
		utils = require 'utils'
		utils.insert_or_update(unit.status.current_soul.skills,{new = true, id = skillid, rating = 1},'id')
		skills = unit.status.current_soul.skills
		for i,x in ipairs(skills) do
			if x.id == skillid then
				if dir == 1 then save = x.rating end
				found = true
				if etype == 'fixed' then
					value = x.rating + strength
				end
				if etype == 'percent' then
					percent = (100 + strength)/100
					value = x.rating*percent
				end
				if etype == 'set' then
					value = strength
				end
				if dir == -1 then value = save end
				if value > 20 then value = 20 end
				if value < 0 then value = 0 end
				x.rating = value
			end
		end
	end
	return save
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
if args.token then -- Check which skills to change
	if type(args.token) == 'table' then
		token = args.token
	else
		token = {args.token}
	end
else
	print('No skill to change set')
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
