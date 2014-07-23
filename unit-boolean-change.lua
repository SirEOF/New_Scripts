--change-boolean.lua v1.0
--DO NOT USE - Causes crashes in the game when certain flags are toggled on and off, will investigate when time allows.
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

local function createcallback(unitTarget,etype)
	return function (resetboolean)
		unitTarget.flags1[etype] = false
	end
end
local function effect(etype,unitTarget,dur)
	unitTarget.flags1[etype] = true
	if dur ~= 0 then
		dfhack.timeout(time,'ticks',createcallback(unitTarget,etype))
	end
end

validArgs = validArgs or utils.invert({
 'help',
 'boolean',
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
if args.dur and tonumber(args.dur) then -- Check if there is a duration
	dur = tonumber(args.dur)
else
	dur = 0
end
if args.boolean then -- Check which boolean to change
	if type(args.boolean) == 'table' then
		token = args.boolean
	else
		token = {args.boolean}
	end
else
	print('No boolean to change')
	return
end

for i,etype in ipairs(token) do -- !!RUN EFFECT!!
	effect(etype,unit,dur)
end
