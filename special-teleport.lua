--special=teleport.lua v1.0
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

function isSelected(unit,Target,rx,ry,rz)
	local pos = Target.pos

	local mapx, mapy, mapz = dfhack.maps.getTileSize()
	local xmin = unit.pos.x - rx
	local xmax = unit.pos.x + rx
	local ymin = unit.pos.y - ry
	local ymax = unit.pos.y + ry
	local zmin = unit.pos.z
	local zmax = unit.pos.z + rz
	if xmin < 1 then xmin = 1 end
	if ymin < 1 then ymin = 1 end
	if xmax > mapx then xmax = mapx-1 end
	if ymax > mapy then ymax = mapy-1 end
	if zmax > mapz then zmax = mapz-1 end

	if pos.x < xmin or pos.x > xmax then return false end
	if pos.y < ymin or pos.y > ymax then return false end
	if pos.z < zmin or pos.z > zmax then return false end

	return true
end
	dir = args.direction
else
	print('No direction selected')
	return
end
function teleport(unit,radius,ttype,dir)
	local radiusa = split(radius,',')
	local rx = tonumber(radiusa[1])
	local ry = tonumber(radiusa[2])
	local rz = tonumber(radiusa[3])
	local locx,locy,locz = 0,0,0

	if dir == '1' or dir == '2' then
		pers,status = dfhack.persistent.get('teleport')
		if dir == '1' and pers.ints[7] == 1 then
			locx = pers.ints[1]
			locy = pers.ints[2]
			locz = pers.ints[3]
		elseif dir == '2' and pers.ints[7] == 1 then
			locx = pers.ints[4]
			locy = pers.ints[5]
			locz = pers.ints[6]
		end
	elseif split(dir,':')[1] == 'UNIT' then
		unitT = df.unit.find(tonumber(split(dir,':')[2]))
		locx = unitT.pos.x
		locy = unitT.pos.y
		locz = unitT.pos.z
	else
		local array = {}
		local a = 1
		local dira = split(dir,':')
		if dira[1] == 'IDLE' then
			local unitList = df.global.world.units.active
			for i,x in ipairs(unitList) do
				if x.idle_area.x > 0 then
					array[a] = tostring(x.idle_area.x)..'_'..tostring(x.idle_area.y)..'_'..tostring(x.idle_area.z)
					a = a + 1
				end
			end
		elseif dira[1] == 'BUILDING' then
			local bldgList = df.global.world.buildings.all
			for i,bldg in ipairs(bldgList) do
				if dira[2] == 'WORKSHOP' then
					if df.building_workshopst:is_instance(bldg) then
						array[a] = tostring(bldg.centerx)..'_'..tostring(bldg.centery)..'_'..tostring(bldg.z)
						a = a + 1
					end
				elseif dira[2] == 'FURNACE' then
					if df.building_furnacest:is_instance(bldg) then
						array[a] = tostring(bldg.centerx)..'_'..tostring(bldg.centery)..'_'..tostring(bldg.z)
						a = a + 1
					end
				else
					if df.building_workshopst:is_instance(bldg) or df.building_furnacest:is_instance(bldg) then
						local btype = bldg.custom_type
						local all_bldgs = df.global.world.raws.buildings.all
						if btype >= 0 then
							if all_bldgs[btype].code == dira[2] then
								array[a] = tostring(bldg.centerx)..'_'..tostring(bldg.centery)..'_'..tostring(bldg.z)
								a = a + 1
							end
						end
					end
				end
			end
		elseif dira[1] == 'ROOM' then
			local bldgList = df.global.world.buildings.all
			for i,bldg in ipairs(bldgList) do
				if bldg.is_room then
					array[a] = tostring(bldg.centerx)..'_'..tostring(bldg.centery)..'_'..tostring(bldg.z)
					a = a + 1
				end
			end
		else
			print('No valid teleport location specified, aborting')
		end
		if #array > 0 then
			local rando = dfhack.random.new()
			local roll = rando:random(#array)+1
			locx = tonumber(split(array[roll],'_')[1])
			locy = tonumber(split(array[roll],'_')[2])
			locz = tonumber(split(array[roll],'_')[3])
		end
	end

	if locx <= 0 or locy <= 0 or locz <= 0 or locx == nil then
		print('No valid teleport location found, aborting')
		return
	end

	if ttype == 'unit' or ttype == 'both' then
		local unitList = df.global.world.units.active
		for i = #unitList - 1, 0, -1 do
			local unitTarget = unitList[i]
			if isSelected(unit,unitTarget,rx,ry,rz) then
				local unitoccupancy = dfhack.maps.getTileBlock(unitTarget.pos).occupancy[unitTarget.pos.x%16][unitTarget.pos.y%16]
				unitTarget.pos.x = locx
				unitTarget.pos.y = locy
				unitTarget.pos.z = locz
				if not unit.flags1.on_ground then unitoccupancy.unit = false else unitoccupancy.unit_grounded = false end
			end
		end
	end
	if ttype == 'item' or ttype == 'both' then
		local itemList = df.global.world.items.all
		for i = #itemList - 1, 0, -1 do
			local itemTarget = itemList[i]
			if isSelected(unit,itemTarget,rx,ry,rz) then
				local pos = {}
				pos.x = pers.locx
				pos.y = pers.locy
				pos.z = pers.locz
				dfhack.items.moveToGround(itemTarget, pos)
			end
		end
	end
end

validArgs = validArgs or utils.invert({
 'help',
 'unit',
 'direction',
 'type',
 'radius',
})
types = types or utils.invert({
 'unit',
 'item',
 'both',
})
local args = utils.processArgs({...}, validArgs)

if args.help then -- Help declaration
 print("TODO - Help Section")
 return
end

args.type = types[args.type or 'both']
if args.radius then -- Specify radius to teleport from (default 0,0,0)
	radius = args.radius
else
	radius = '0,0,0'
end
if args.unit and tonumber(args.unit) then -- Check for unit declaration
	unit = df.unit.find(tonumber(args.unit))
else
	print('No unit selected')
	return
end
if args.direction then -- Check for direction declaration
	dir = args.direction
else
	print('No direction selected')
	return
end

teleport(unit,radius,args.type,dir)