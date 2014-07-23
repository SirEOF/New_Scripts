--special-eruption.lua v1.0
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

function eruptionunit(etype,unit,radius,depth,offset)
	local i
	local posx = unit.pos.x
	local posy = unit.pos.y
	local posz = unit.pos.z
	local rando = dfhack.random.new()
	local radiusa = split(radius,',')
	local rx = tonumber(radiusa[1])
	local ry = tonumber(radiusa[2])
	local rz = tonumber(radiusa[3])
	local offseta = split(offset,',')
	local ox = tonumber(offseta[1])
	local oy = tonumber(offseta[2])
	local oz = tonumber(offseta[3])
	
	local mapx, mapy, mapz = dfhack.maps.getTileSize()
	local xmin = posx - rx + ox
	local xmax = posx + rx + ox
	local ymin = posy- ry + oy
	local ymax = posy + ry + oy
	local zmax = posz + rz + oz
	local zmin = posz - rz + oz
	if xmin < 1 then xmin = 1 end
	if ymin < 1 then ymin = 1 end
	if zmin < 1 then zmin = 1 end
	if xmax > mapx then xmax = mapx-1 end
	if ymax > mapy then ymax = mapy-1 end
	if zmax > mapz then zmax = mapz-1 end

	local dx = xmax - xmin
	local dy = ymax - ymin
	local dz = zmax - zmin
	local hx = 0
	local hy = 0
	local hz = 0
	if dx == 0 then
		hx = depth
	else
		hx = depth/dx
	end
	if dy== 0 then
		hy = depth
	else
		hy = depth/dy
	end
	if dz == 0 then
		hz = depth
	else
		hz = depth/dz
	end

	for i = xmin, xmax, 1 do
		for j = ymin, ymax, 1 do
			for k = zmin, zmax, 1 do
				if (math.abs(i-posx) + math.abs(j-posy) + math.abs(k-posz)) <= math.sqrt(rx*rx+ry*ry+rz*rz) then
					block = dfhack.maps.ensureTileBlock(i,j,k)
					dsgn = block.designation[i%16][j%16]
					if not dsgn.hidden then
						size = math.floor(depth-hx*math.abs(posx-i)-hy*math.abs(posy-j)-hz*math.abs(posz-k))
						if size < 1 then size = 1 end
						dsgn.flow_size = size
						if etype == 'magma' then
							dsgn.liquid_type = true
						end
						flow = block.liquid_flow[i%16][j%16]
						flow.temp_flow_timer = 10
						flow.unk_1 = 10
						block.flags.update_liquid = true
						block.flags.update_liquid_twice = true
					end
				end
			end
		end
	end
end
function eruptionlocation(etype,location,radius,depth,offset)
	local i
	local posx = location.x
	local posy = location.y
	local posz = location.z
	local rando = dfhack.random.new()
	local radiusa = split(radius,',')
	local rx = tonumber(radiusa[1])
	local ry = tonumber(radiusa[2])
	local rz = tonumber(radiusa[3])
	local offseta = split(offset,',')
	local ox = tonumber(offseta[1])
	local oy = tonumber(offseta[2])
	local oz = tonumber(offseta[3])
	
	local mapx, mapy, mapz = dfhack.maps.getTileSize()
	local xmin = posx - rx + ox
	local xmax = posx + rx + ox
	local ymin = posy- ry + oy
	local ymax = posy + ry + oy
	local zmax = posz + rz + oz
	local zmin = posz - rz + oz
	if xmin < 1 then xmin = 1 end
	if ymin < 1 then ymin = 1 end
	if zmin < 1 then zmin = 1 end
	if xmax > mapx then xmax = mapx-1 end
	if ymax > mapy then ymax = mapy-1 end
	if zmax > mapz then zmax = mapz-1 end

	local dx = xmax - xmin
	local dy = ymax - ymin
	local dz = zmax - zmin
	local hx = 0
	local hy = 0
	local hz = 0
	if dx == 0 then
		hx = depth
	else
		hx = depth/dx
	end
	if dy== 0 then
		hy = depth
	else
		hy = depth/dy
	end
	if dz == 0 then
		hz = depth
	else
		hz = depth/dz
	end

	for i = xmin, xmax, 1 do
		for j = ymin, ymax, 1 do
			for k = zmin, zmax, 1 do
				if (math.abs(i-posx) + math.abs(j-posy) + math.abs(k-posz)) <= math.sqrt(rx*rx+ry*ry+rz*rz) then
					block = dfhack.maps.ensureTileBlock(i,j,k)
					dsgn = block.designation[i%16][j%16]
					if not dsgn.hidden then
						size = math.floor(depth-hx*math.abs(posx-i)-hy*math.abs(posy-j)-hz*math.abs(posz-k))
						if size < 1 then size = 1 end
						dsgn.flow_size = size
						if etype == 'magma' then
							dsgn.liquid_type = true
						end
						flow = block.liquid_flow[i%16][j%16]
						flow.temp_flow_timer = 10
						flow.unk_1 = 10
						block.flags.update_liquid = true
						block.flags.update_liquid_twice = true
					end
				end
			end
		end
	end
end

validArgs = validArgs or utils.invert({
 'help',
 'unit',
 'magma',
 'location',
 'radius',
 'depth',
 'offset',
})
local args = utils.processArgs({...}, validArgs)

if args.help then -- Help declaration
 print("TODO - Help Section")
 return
end

if args.radius then -- Specify radius of eruption (default 0,0,0)
	radius = args.radius
else
	radius = '0,0,0'
end
if args.depth then -- Specify depth of eruption (default 7)
	depth = tonumber(args.depth)
else
	depth = 7
end
if args.offset then -- Specify offset of eruption (default 0,0,0)
	offset = args.offset
else
	offset = '0,0,0'
end
if args.unit and tonumber(args.unit) then -- Check for unit or location declaration. !!RUN ERUPTION!!
	unit = df.unit.find(tonumber(args.unit))
	eruptionunit(etype,unit,radius,depth,offset)
elseif args.location then
	location = args.location
	eruptionlocation(etype,location,radius,depth,offset)
else
	print ('No origin declaration')
	return
end
