--item-improve.lua v1.0
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

function createcallback(x,sid)
	return function(resetitem)
		x:setQuality(sid)
	end
end
function itemSubtypes(item) -- Taken from Putnam's itemSyndrome
   local subtypedItemTypes =
    {
    ARMOR = df.item_armorst,
    WEAPON = df.item_weaponst,
    HELM = df.item_helmst,
    SHOES = df.item_shoesst,
    SHIELD = df.item_shieldst,
    GLOVES = df.item_glovest,
    PANTS = df.item_pantsst,
    TOOL = df.item_toolst,
    SIEGEAMMO = df.item_siegeammost,
    AMMO = df.item_ammost,
    TRAPCOMP = df.item_trapcompst,
    INSTRUMENT = df.item_instrumentst,
    TOY = df.item_toyst}
    for x,v in pairs(subtypedItemTypes) do
        if v:is_instance(item) then 
			return df.item_type[x]
		end
    end
    return false
end
function upgradeitem(args,v,unit,dur,subtype)
	local sitems = {}
	if args.equipped and args.unit then
-- Upgrade only the input items with preserve reagent
		local inv = unit.inventory
		local j = 1
		for i,x in ipairs(inv) do
			if (v:is_instance(x.item) and (x.item.subtype.id == subtype or subtype == 'ALL')) then
				sitems[j] = x.item
				j = j+1
			end
		end
	elseif args.all then
-- Upgrade all items of the same type as input
		local itemList = df.global.world.items.all
		local k = 1
		for i,x in ipairs(itemList) do
			if (v:is_instance(x) and (x.subtype.id == subtype or subtype == 'ALL')) then 
				sitems[k] = itemList[i] 
				k = k + 1
			end
		end
	else
-- Randomly upgrade one specific item
		local itemList = df.global.world.items.all
		local k = 1
		for i,x in ipairs(itemList) do
			if (v:is_instance(x) and (x.subtype.id == subtype or subtype == 'ALL')) then 
				sitems[k] = itemList[i] 
				k = k + 1
			end
		end
		local rando = dfhack.random.new()
		sitems = {sitems[rando:random(#sitems)]}
	end

	if args.upgrade then
-- Increase items number by one
		for _,x in ipairs(sitems) do
			sid = x.quality
			x:setQuality(sid+1)
			if dur > 0 then dfhack.timeout(dur,'ticks',createcallback(x,sid)) end
		end
	elseif args.downgrade then
-- Decrease items number by one
		for _,x in ipairs(sitems) do
			sid = x.quality
			x:setQuality(sid-1)
			if dur > 0 then dfhack.timeout(dur,'ticks',createcallback(x,sid)) end
		end
	else
-- Change item to new quality
		for _,x in ipairs(sitems) do
			sid = x.quality
			x:setQuality(tonumber(args.quality))
			if dur > 0 then dfhack.timeout(dur,'ticks',createcallback(x,sid)) end
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
 'equipped',
 'all',
 'quality',
 'dur',
 'upgrade',
 'downgrade',
})
local args = utils.processArgs({...}, validArgs)

if args.help then -- Help declaration
 print("TODO - Help Section")
 return
end

if args.unit and tonumber(args.unit) then -- Check for unit declaration
	unit = df.unit.find(tonumber(args.unit))
else
	unit = 0
end
if args.dur then -- Specify duration of material change (default 0)
	dur = tonumber(args.dur)
else
	dur = 0
end
if args.weapon then upgradeitem(args,df.item_weaponst,unit,dur,args.weapon) end
if args.armor then upgradeitem(args,df.item_armorst,unit,dur,args.armor) end
if args.helm then upgradeitem(args,df.item_helmst,unit,dur,args.helm) end
if args.shoes then upgradeitem(args,df.item_shoesst,unit,dur,args.shoes) end
if args.shield then upgradeitem(args,df.item_shieldst,unit,dur,args.shield) end
if args.gloves then upgradeitem(args,df.item_glovest,unit,dur,args.gloves) end
if args.pants then upgradeitem(args,df.item_pantsst,unit,dur,args.pants) end
if args.ammo then upgradeitem(args,df.item_ammost,unit,dur,args.ammo) end

upgradeitem(args)
