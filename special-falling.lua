--projectile.lua v1.0
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

validArgs = validArgs or utils.invert({
 'help',
 'unit_source',
 'location_source',
 'mat',
 'item',
 'number',
 'height',
})
local args = utils.processArgs({...}, validArgs)

if args.help then -- Help declaration
 print("TODO - Help Section")
 return
end

if args.unit_source and args.location_source then -- Check that unit and location sources have not been both specified
	print("Can't have unit and location specified as source at same time")
	args.location_source = nil
end
if args.unit_source then -- Check for source declaration
	locSource = df.unit.find(tonumber(args.unit_source)).pos
elseif args.location_source then
	locSource = args.location_source
else
	print('No source specified')
end

if args.item then -- Check for item
	object = args.item
else
	print('No item specified')
	return
end
if args.mat then -- Check for material
	mat = args.mat
else
	print('No material specified')
	return
end
if args.number then -- Specify number of falling projectiles (default 1)
	number = tonumber(args.number)
else
	number = 1
end
if args.height then -- Specify height of falling projectiles (default 0)
	height = tonumber(args.height)
else
	height = 0
end

mat_type = dfhack.matinfo.find(mat).type
mat_index = dfhack.matinfo.find(mat).index

for i = 1, number, 1 do
	if split(object,':')[1] == 'BOULDER' then
		item_index = df.item_type['BOULDER']
		item_subtype = -1
		item=df['item_boulderst']:new()
	elseif split(object,':')[1] == 'AMMO' then
		item_index = df.item_type['AMMO']
		item_subtype = -1
		for i=0,dfhack.items.getSubtypeCount(item_index)-1,1 do
			item_sub = dfhack.items.getSubtypeDef(item_index,i)
			if item_sub.id == split(object,':')[2] then item_subtype = item_sub.subtype end
		end
		if item_subtype == 'nil' then
			print("No item of that type found")
			return
		end
		item=df['item_ammost']:new()
	elseif split(object,';')[1] == 'WEAPON' then
		item_index = df.item_type['WEAPON']
		item_subtype = -1
		for i=0,dfhack.items.getSubtypeCount(item_index)-1,1 do
			item_sub = dfhack.items.getSubtypeDef(item_index,i)
			if item_sub.id == split(object,':')[2] then item_subtype = item_sub.subtype end
		end
		item=df['item_weaponst']:new()
	end

	item.id=df.global.item_next_id
	df.global.world.items.all:insert('#',item)
	df.global.item_next_id=df.global.item_next_id+1
	if object ~= 'BOULDER' then item:setSubtype(item_subtype) end
	item:setMaterial(mat_type)
	item:setMaterialIndex(mat_index)
	item:categorize(true)
	pos = {}
	block = dfhack.maps.ensureTileBlock(locSource.x,locSource.y,locSource.z+height)
	pos.x = locSource.x
	pos.y = locSource.y
	pos.z = locSource.z+height
	item.flags.removed=true
	dfhack.items.moveToGround(item,{x=pos.x,y=pos.y,z=pos.z})
	proj = dfhack.items.makeProjectile(item)
	proj.origin_pos.x=locSource.x
	proj.origin_pos.y=locSource.y
	proj.origin_pos.z=locSource.z + height
	proj.prev_pos.x=locSource.x
	proj.prev_pos.y=locSource.y
	proj.prev_pos.z=locSource.z + height
	proj.cur_pos.x=locSource.x
	proj.cur_pos.y=locSource.y
	proj.cur_pos.z=locSource.z + height
	proj.flags.no_impact_destroy=false
	proj.flags.bouncing=true
	proj.flags.piercing=true
	proj.flags.parabolic=true
	proj.flags.unk9=true
	proj.flags.no_collide=true
	proj.speed_x=0
	proj.speed_y=0
	proj.speed_z=0
end


