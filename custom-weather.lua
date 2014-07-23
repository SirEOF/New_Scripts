--custom-weather.lua v1.0
--[[TODO
--]]

flowtypes = {
miasma = 0,
mist = 1,
mist2 = 2,
dust = 3,
lavamist = 4,
smoke = 5,
dragonfire = 6,
firebreath = 7,
web = 8,
undirectedgas = 9,
undirectedvapor = 10,
oceanwave = 11,
seafoam = 12
}

function weather3(stype,number,itype,strength,frequency)
	if weathercontinue then
		dfhack.timeout(frequency,'ticks',weather(stype,number,itype,strength,frequency))
	else
		return
	end
end
function weather2(cbid)
	return function (stopweather)
		weathercontinue = false
	end
end
function weather(stype,number,itype,strength,frequency)
	return function (startweather)
		local i
		local rando = dfhack.random.new()
		local snum = flowtypes[stype]
		local inum = 0
		if itype ~= 0 then
			inum = dfhack.matinfo.find(itype).index
		end

		local mapx, mapy, mapz = dfhack.maps.getTileSize()
		local xmin = 2
		local xmax = mapx - 1
		local ymin = 2
		local ymax = mapy - 1

		local dx = xmax - xmin
		local dy = ymax - ymin
		local pos = {}
		pos.x = 0
		pos.y = 0
		pos.z = 0

		for i = 1, number, 1 do

			local rollx = rando:random(dx)
			local rolly = rando:random(dy)

			pos.x = rollx
			pos.y = rolly
			pos.z = 20
		
			local j = 0
			while not dfhack.maps.ensureTileBlock(pos.x,pos.y,pos.z+j).designation[pos.x%16][pos.y%16].outside do
				j = j + 1
			end
			pos.z = pos.z + j
			dfhack.maps.spawnFlow(pos,snum,0,inum,strength)
		end
		weather3(stype,number,itype,strength,frequency)
	end
end

validArgs = validArgs or utils.invert({
 'help',
 'flow',
 'dur',
 'size',
 'frequency',
 'number',
 'inorganic',
})
local args = utils.processArgs({...}, validArgs)

if args.help then -- Help declaration
 print("TODO - Help Section")
 return
end

if args.flow then -- Specify type of flow (default mist)
	stype = args.flow
else
	stype = 'mist'
end
if args.dur then -- Specify duration of flow spawning (default 1)
	duration = tonumber(args.dur)
else
	duration = 1
end
if args.size then -- Specify size of flows to spawn (default 1)
	strength = tonumber(args.size)
else
	strength = 1
end
if args.frequency then -- Specify frequency to spawn flows (default 1000)
	frequency = tonumber(args.frequency)
else
	frequency = 100
end
if args.number then -- Specify number of flows to spawn (default 1)
	number = tonumber(args.number)
else
	number = 1
end
if args.inorganic then -- Specify flow inorganic (default NONE)
	itype = args.inorganic
else
	itype = 0
end

local test = 'abc'
weathercontinue = true

dfhack.timeout(1,'ticks',weather(stype,number,itype,strength,frequency))
dfhack.timeout(duration,'ticks',weather2(test))
