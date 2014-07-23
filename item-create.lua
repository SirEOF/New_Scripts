--item-create.lua v1.0
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

function createcallback(item)
	return function (deleteitem)
		dfhack.items.remove(item)
	end
end
function createitem(unit,mat,location,dur,itemtype)
local mat_type = dfhack.matinfo.find(mat).type
local mat_index = dfhack.matinfo.find(mat).index
local t = split(itemtype,':')[1]
if t == 'WEAPON' then v = 'item_weaponst' end
if t == 'ARMOR' then v = 'item_armorst' end
if t == 'HELM' then v = 'item_helmst' end
if t == 'SHOES' then v = 'item_shoesst' end
if t == 'SHIELD' then v = 'item_shieldst' end
if t == 'GLOVE' then v = 'item_glovest' end
if t == 'PANTS' then v = 'item_pantsst' end
if t == 'AMMO' then v = 'item_ammost' end

local item_index = df.item_type[t]
local item_subtype = 'nil'

for i=0,dfhack.items.getSubtypeCount(item_index)-1 do
  local item_sub = dfhack.items.getSubtypeDef(item_index,i)
  if item_sub.id == split(itemtype,':')[2] then
	  item_subtype = item_sub.subtype
	end
end

if item_subtype == 'nil' then
  print("No item of that type found")
  return
end

local item=df[v]:new() --incredible
item.id=df.global.item_next_id
df.global.world.items.all:insert('#',item)
df.global.item_next_id=df.global.item_next_id+1
item:setSubtype(item_subtype)
item:setMaterial(mat_type)
item:setMaterialIndex(mat_index)
item:categorize(true)
item.flags.removed=true
if t == 'WEAPON' then item:setSharpness(1,0) end
item:setQuality(0)
if location == 'ground' then dfhack.items.moveToGround(item,{x=unit.pos.x,y=unit.pos.y,z=unit.pos.z}) end
if location == 'inventory' then
	local umode = 0
	local bpart = 0
	dfhack.items.moveToInventory(item,unit,umode,bpart) 
end
if dur ~= 0 then dfhack.timeout(dur,'ticks',createcallback(item)) end
end

validArgs = validArgs or utils.invert({
 'help',
 'unit',
 'item',
 'mat',
 'dur',
 'ground',
 'inventory',
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
if args.dur then -- Specify duration of material change (default 0)
	dur = tonumber(args.dur)
else
	dur = 0
end
if args.mat then -- Check for material
	mat = args.mat
else
	print('No material specified')
	return
end
if args.item then -- Check for item
	itemtype = args.item
else
	print('No item specified')
	return
end
if args.ground then -- Check for item placement location
	loc = 'ground'
elseif args.inventory then
	loc = 'inventory'
else
	print('No location to place item specified')
	return
end

createitem(unit,mat,loc,dur,itemtype)
