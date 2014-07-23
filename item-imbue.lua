--imbueitem.lua v1.0
--[[TODO
--]]

function createcallback(item,stype,sindex)
	return function (resetweapon)
		item.mat_type = stype
		item.mat_index = sindex
	end
end
function imbue(v,mat,dur)
	local mat_type = dfhack.matinfo.find(mat).type
	local mat_index = dfhack.matinfo.find(mat).index

	local inv = unit.inventory
	local items = {}
	local j = 1
	for i = 0, #inv - 1, 1 do
		if v:is_instance(inv[i].item) then
			items[j] = i
			j = j+1
		end
	end

	if #items == 0 then 
		print('No necessary item equiped')
		return
	end

	for i,x in ipairs(items) do
		local sitem = inv[x].item
		local stype = sitem.mat_type
		local sindex = sitem.mat_index
		sitem.mat_type = mat_type
		sitem.mat_index = mat_index

		if dur ~= 0 then
			dfhack.timeout(dur,'ticks',createcallback(sitem,stype,sindex))
		end
	end
end

validArgs = validArgs or utils.invert({
 'help',
 'unit',
 'weapon',
 'armor',
 'helm',
 'shoes',
 'shield',
 'gloves',
 'pants',
 'ammo',
 'mat',
 'dur',
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
if args.weapon then imbue(df.item_weaponst,mat,dur) end
if args.armor then imbue(df.item_armorst,mat,dur) end
if args.helm then imbue(df.item_helmst,mat,dur) end
if args.shoes then imbue(df.item_shoesst,mat,dur) end
if args.shield then imbue(df.item_shieldst,mat,dur) end
if args.gloves then imbue(df.item_glovest,mat,dur) end
if args.pants then imbue(df.item_pantsst,mat,dur) end
if args.ammo then imbue(df.item_ammost,mat,dur) end

