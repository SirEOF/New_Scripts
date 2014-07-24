--wrapper_test.lua v0.1

s1 = ':'

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
function permute(tab)
 math.randomseed()
 math.random()
 n = #tab
 for i = 1, n do
  local j = math.random(i, n)
  tab[i], tab[j] = tab[j], tab[i]
 end
 return tab
end
function callback(script)
 return function (delayTrigger)
  dfhack.run_script(script[1],select(2,table.unpack(script)))
 end
end

function getAttrValue(unit,attr,mental) -- CHECK 1
 if unit.curse.attr_change then
  if mental then
   return (unit.status.current_soul.mental_attrs[attr].value+unit.curse.attr_change.ment_att_add[attr])*unit.curse.attr_change.ment_att_perc[attr]/100
  else
   return (unit.body.physical_attrs[attr].value+unit.curse.attr_change.phys_att_add[attr])*unit.curse.attr_change.phys_att_perc[attr]/100
  end
 else
  if mental then
   return unit.status.current_soul[attr].value
  else
   return unit.body.physical_attrs[attr].value
  end
 end
end

function getValue(selected,targetList,unitSelf,unitTarget,svalue) -- CHECK 1
 local valuea = split(svalue,';')
 local value = tonumber(valuea[3])
 local inc = tonumber(valuea[4])
 local int32 = 200000000
 if valuea[1] == 'stacking' then
  if valua[2] == 'total' then
   value = value + inc*(#selected)
  elseif valuea[2] == 'allowed' then
   for _,x in ipairs(selected) do
    if x then value = value + inc end
   end
  elseif valuea[2] == 'immune' then
   for _,x in ipairs(selected) do
    if not x then value = value + inc end
   end
  else
   value = value
  end
 elseif valuea[1] == 'destacking' then
  if valua[2] == 'total' then
   value = value - inc*(#selected)
  elseif valuea[2] == 'allowed' then
   for _,x in ipairs(selected) do
    if x then value = value - inc end
   end
  elseif valuea[2] == 'immune' then
   for _,x in ipairs(selected) do
    if not x then value = value - inc end
   end
  else
   value = value
  end
 else
  if valuea[1] == 'self' then unitTarget = unitSelf end
  etype = valuea[2]
  if etype == 'strength' then
   value = unitTarget.body.physical_attrs.STRENGTH*value/100 + inc
  elseif etype == 'agility' then
   value = unitTarget.body.physical_attrs.AGILITY*value/100 + inc
  elseif etype == 'endurance' then
   value = unitTarget.body.physical_attrs.ENDURANCE*value/100 + inc
  elseif etype == 'toughness' then
   value = unitTarget.body.physical_attrs.TOUGHNESS*value/100 + inc
  elseif etype == 'resistance' then
   value = unitTarget.body.physical_attrs.DISEASE_RESISTANCE*value/100 + inc
  elseif etype == 'recuperation' then
   value = unitTarget.body.physical_attrs.RECUPERATION*value/100 + inc
  elseif etype == 'analytical' then
   value = unitTarget.status.current_soul.mental_attrs.ANALYTICAL_ABILITY*value/100 + inc
  elseif etype == 'focus' then
   value = unitTarget.status.current_soul.mental_attrs.FOCUS*value/100 + inc
  elseif etype == 'wlllpower' then
   value = unitTarget.status.current_soul.mental_attrs.WILLPOWER*value/100 + inc
  elseif etype == 'creativity' then
   value = unitTarget.status.current_soul.mental_attrs.CREATIVITY*value/100 + inc
  elseif etype == 'intuition' then
   value = unitTarget.status.current_soul.mental_attrs.INTUITION*value/100 + inc
  elseif etype == 'patience' then
   value = unitTarget.status.current_soul.mental_attrs.PATIENCE*value/100 + inc
  elseif etype == 'memory' then
   value = unitTarget.status.current_soul.mental_attrs.MEMORY*value/100 + inc
  elseif etype == 'linguistic' then
   value = unitTarget.status.current_soul.mental_attrs.LINGUISTIC_ABILITY*value/100 + inc
  elseif etype == 'spatial' then
   value = unitTarget.status.current_soul.mental_attrs.SPATIAL_SENSE*value/100 + inc
  elseif etype == 'musicality' then
   value = unitTarget.status.current_soul.mental_attrs.MUSICALITY*value/100 + inc
  elseif etype == 'kinesthetic' then
   value = unitTarget.status.current_soul.mental_attrs.KINESTHETIC_SENSE*value/100 + inc
  elseif etype == 'empathy' then
   value = unitTarget.status.current_soul.mental_attrs.EMPATHY*value/100 + inc
  elseif etype == 'social' then
   value = unitTarget.status.current_soul.mental_attrs.SOCIAL_AWARENESS*value/100 + inc
  elseif etype == 'web' then
   value = unitTarget.counters.webbed*value/100 + inc
  elseif etype == 'stun' then
   value = unitTarget.counters.stunned*value/100 + inc
  elseif etype == 'winded' then 
   value = unitTarget.counters.winded*value/100 + inc
  elseif etype == 'unconscious' then 
   value = unitTarget.counters.unconscious*value/100 + inc
  elseif etype == 'pain' then 
   value = unitTarget.counters.pain*value/100 + inc
  elseif etype == 'nausea' then 
   value = unitTarget.counters.nausea*value/100 + inc
  elseif etype == 'dizziness' then 
   value = unitTarget.counters.dizziness*value/100 + inc
  elseif etype == 'paralysis' then 
   value = unitTarget.counters.paralysis*value/100 + inc
  elseif etype == 'numbness' then 
   value = unitTarget.counters.numbness*value/100 + inc
  elseif etype == 'fever' then 
   value = unitTarget.counters.fever*value/100 + inc
  elseif etype == 'exhaustion' then 
   value = unitTarget.counters.exhaustion*value/100 + inc
  elseif etype == 'hunger' then 
   value = unitTarget.counters.hunger_timer*value/100 + inc
  elseif etype == 'thirst' then 
   value = unitTarget.counters.thirst_timer*value/100 + inc
  elseif etype == 'sleep' then 
   value = unitTarget.counters.sleepiness_timer*value/100 + inc
  elseif etype == 'infection' then 
   value = unitTarget.body.infection_level*value/100 + inc
  elseif etype == 'blood' then
   value = unitTarget.body.blood_count*value/100 + inc
  end
 end
 return value
end

function checkDistance(unitTarget,array,plan) -- CHECK 1
 local unumber = 1

 local selected,targetList,announcement = {},{},{''}

 if plan ~= 'NONE' then
  local file = plan..".txt"
  local path = dfhack.getDFPath().."/hack/scripts/"..file

  local iofile = io.open(path,"r")
  local read = iofile:read("*all")
  iofile:close()

  local reada = split(read,',')
  local x = {}
  local y = {}
  local t = {}
  local xi = 0
  local yi = 1
  local x0 = 0
  local y0 = 0
  for i,v in ipairs(reada) do
   if split(v,'\n')[1] ~= v then
    xi = 1
    yi = yi + 1
   else
    xi = xi + 1
   end
   if v == 'X' or v == '\nX' then
    x0 = xi
    y0 = yi
   end
   if v == 'X' or v == '\nX' or v == '1' or v == '\n1' then
    t[i] = true
   else
    t[i] = false
   end
   x[i] = xi
   y[i] = yi
  end

  for i,_ in ipairs(x) do
   x[i] = x[i] - x0 + unitTarget.pos.x
   y[i] = y[i] - y0 + unitTarget.pos.y
   t[tostring(x[i])..'_'..tostring(y[i])] = t[i]
  end

  local unitList = df.global.world.units.active
  local mapx, mapy, mapz = dfhack.maps.getTileSize()

  for i = 0, #unitList - 1, 1 do
   local unit = unitList[i]

   if (t[tostring(unit.pos.x)..'_'..tostring(unit.pos.y)] and unit.pos.z == unitTarget.pos.z) and unit.id ~= unitTarget.id then
    targetList[unumber] = unit
    announcement[unumber] = ''
    selected[unumber] = true
    unumber = unumber + 1
   end
  end
 else
  local rx = tonumber(split(array,',')[1])
  local ry = tonumber(split(array,',')[2])
  local rz = tonumber(split(array,',')[3])
  if rx*ry*rz >= 0 then
   local unitList = df.global.world.units.active
   local mapx, mapy, mapz = dfhack.maps.getTileSize()

   for i = 0, #unitList - 1, 1 do
    local unit = unitList[i]
    local xmin = unitTarget.pos.x - rx
    local xmax = unitTarget.pos.x + rx
    local ymin = unitTarget.pos.y - ry
    local ymax = unitTarget.pos.y + ry
    local zmin = unitTarget.pos.z - rz
    local zmax = unitTarget.pos.z + rz
    if xmin < 1 then xmin = 1 end
    if ymin < 1 then ymin = 1 end
    if zmin < 1 then zmin = 1 end
    if xmax > mapx then xmax = mapx-1 end
    if ymax > mapy then ymax = mapy-1 end
    if zmax > mapz then zmax = mapz-1 end

    if (unit.pos.x >= xmin and unit.pos.x <= xmax and unit.pos.y >= ymin and unit.pos.y <= ymax and unit.pos.z >= zmin and unit.pos.z <= zmax) then
     targetList[unumber] = unit
     announcement[unumber] = ''
     selected[unumber] = true
     unumber = unumber + 1
    end
   end
  end
 end
 
 return selected, targetList, announcement
end

function checkTarget(unit,target,unitCaster) -- CHECK 1
 if target == 'invasion' then
  if unit.invasion_id ~= unitCaster.invasion_id then sel = false end
 elseif target == 'civ' then
  if unit.civ_id ~= unitCaster.civ_id then sel = false end
 elseif target == 'population' then
  if unit.population_id ~= unitCaster.population_id then sel = false end
 elseif target == 'race' then
  if unit.race ~= unitCaster.race then sel = false end
 elseif target == 'sex' then
  if unit.sex ~= unitCaster.sex then sel = false end
 elseif target == 'caste' then
  if unit.race ~= unitCaster.race or unit.caste ~= unitCaster.caste then sel = false end
 end
 return sel, ''
end

function checkAttributes(unit,array,mental,unitTarget) -- CHECK 1
 local rtempa,itempa,r,i,required,immune = {},{},1,1,false,false
 local rtext = 'Targeting failed, ' .. tostring(unit.name.first_name) .. "'s attributes are too low."
 local itext = 'Targeting failed, ' .. tostring(unit.name.first_name) .. "'s attributes are too high."
 if type(array) ~= 'table' then array = {array} end
 for _,x in ipairs(array) do
  local utemp = getAttrValue(unit,split(x,s1)[2],mental)
  if split(x,s1)[1] == 'min' then
   if tonumber(split(x,s1)[3]) >= utemp then
    rtempa[r] = true
   else
    rtempa[r] = false
   end
   r = r + 1
  elseif split(x,s1)[1] == 'max' then
   if tonumber(split(x,s1)[3]) <= utemp then
    itempa[r] = true
   else
    itempa[r] = false
   end
   i = i + 1
  elseif split(x,s1)[1] == 'greater' then
   if utemp/getAttrValue(unitTarget,split(x,s1)[2],mental) >= tonumber(split(x,s1)[3]) then
    rtempa[r] = true
   else
    rtempa[r] = false
   end
   r = r + 1
  elseif split(x,';')[1] == 'less' then
   if utemp/getAttrValue(unitTarget,split(x,s1)[2],mental) <= tonumber(split(x,s1)[3]) then
    itempa[i] = true
   else
    itempa[i] = false
   end
   i = i + 1
  end
 end
 for _,x in ipairs(rtempa) do
  if x then required = true end
 end
 for _,x in ipairs(itempa) do
  if x then immune = true end
 end
 if required and not immune then return false,itext end
 if required and immune then return true,'NONE' end
 if not required and immune then return false,rtext end
 if not required and not immune then return false,rtext end
end

function checkTraits(unit,array,unitTarget) -- CHECK 1
 local rtempa,itempa,r,i,required,immune = {},{},1,1,false,false
 local rtext = 'Targeting failed, ' .. tostring(unit.name.first_name) .. "'s traits are too low."
 local itext = 'Targeting failed, ' .. tostring(unit.name.first_name) .. "'s traits are too high."
 if type(array) ~= 'table' then array = {array} end
 for _,x in ipairs(array) do
  local utemp = unit.status.current_soul.traits[split(x,s1)[2]]
  if split(x,s1)[1] == 'min' then
   if tonumber(split(x,s1)[3]) >= utemp then
    rtempa[r] = true
   else
    rtempa[r] = false
   end
   r = r + 1
  elseif split(x,s1)[1] == 'max' then
   if tonumber(split(x,s1)[3]) <= utemp then
    itempa[r] = true
   else
    itempa[r] = false
   end
   i = i + 1
  elseif split(x,s1)[1] == 'greater' then
   if utemp/unitTarget.status.current_soul.traits[split(x,s1)[2]] >= tonumber(split(x,s1)[3]) then
    rtempa[r] = true
   else
    rtempa[r] = false
   end
   r = r + 1
  elseif split(x,s1)[1] == 'less' then
   if utemp/unitTarget.status.current_soul.traits[split(x,s1)[2]] <= tonumber(split(x,s1)[3]) then
    itempa[i] = true
   else
    itempa[i] = false
   end
   i = i + 1
  end
 end
 for _,x in ipairs(rtempa) do
  if x then required = true end
 end
 for _,x in ipairs(itempa) do
  if x then immune = true end
 end
 if required and not immune then return false,itext end
 if required and immune then return true,'NONE' end
 if not required and immune then return false,rtext end
 if not required and not immune then return false,rtext end
end

function checkSkills(unit,array,unitTarget) -- CHECK 1
 local rtempa,itempa,r,i,required,immune = {},{},1,1,false,false
 local rtext = 'Targeting failed, ' .. tostring(unit.name.first_name) .. "'s skills are too low."
 local itext = 'Targeting failed, ' .. tostring(unit.name.first_name) .. "'s skills are too high."
 if type(array) ~= 'table' then array = {array} end
 for _,x in ipairs(array) do
  local utemp = dfhack.units.getEffectiveSkill(unit,df.job_skill[split(x,s1)[2]])
  if split(x,s1)[1] == 'min' then
   if tonumber(split(age,s1)[3]) > utemp then
    rtempa[r] = true
   else
    rtempa[r] = false
   end
   r = r + 1
  elseif split(x,s1)[1] == 'max' then
   if tonumber(split(age,s1)[3]) < utemp then
    itempa[i] = true
   else
    itempa[i] = false
   end
   i = i + 1
  elseif split(x,s1)[1] == 'greater' then
   if utemp/dfhack.units.getEffectiveSkill(unitTarget,df.job_skill[split(x,s1)[2]]) >= tonumber(split(x,s1)[3]) then
    rtempa[r] = true
   else
    rtempa[r] = false
   end
   r = r + 1
  elseif split(x,s1)[1] == 'less' then
   if utemp/dfhack.units.getEffectiveSkill(unitTarget,df.job_skill[split(x,s1)[2]]) <= tonumber(split(x,s1)[3]) then
    itempa[i] = true
   else
    itempa[i] = false
   end
   i = i + 1
  end
 end
 for _,x in ipairs(rtempa) do
  if x then required = true end
 end
 for _,x in ipairs(itempa) do
  if x then immune = true end
 end
 if required and not immune then return false,itext end
 if required and immune then return true,'NONE' end
 if not required and immune then return false,rtext end
 if not required and not immune then return false,rtext end
end

function checkAge(unit,array,unitTarget) --CHECK 1
 local rtempa,itempa,r,i,required,immune = {},{},1,1,false,false
 local rtext = 'Targeting failed, ' .. tostring(unit.name.first_name) .. ' is too young.'
 local itext = 'Targeting failed, ' .. tostring(unit.name.first_name) .. ' is too old.'
 if type(array) ~= 'table' then array = {array} end
 local utemp = dfhack.units.getAge(unit)
 for _,x in ipairs(array) do
  if split(x,s1)[1] == 'min' then
   if tonumber(split(x,s1)[2]) > utemp then
    rtempa[r] = true
   else
    rtempa[r] = false
   end
   r = r + 1
  elseif split(x,s1)[1] == 'max' then
   if tonumber(split(x,s1)[2]) < utemp then
    itempa[i] = true
   else
    itempa[i] = false
   end
   i = i + 1
  elseif split(x,s1)[1] == 'greater' then
   if utemp/dfhack.units.getAge(unitTarget) >= tonumber(split(x,s1)[2]) then
    rtempa[r] = true
   else
    rtempa[r] = false
   end
   r = r + 1
  elseif split(x,s1)[1] == 'less' then
   if utemp/dfhack.units.getAge(unitTarget) <= tonumber(split(x,s1)[2]) then
    itempa[i] = true
   else
    itempa[i] = false
   end
   i = i + 1
  end
 end
 for _,x in ipairs(rtempa) do
  if x then required = true end
 end
 for _,x in ipairs(itempa) do
  if x then immune = true end
 end
 if required and not immune then return false,itext end
 if required and immune then return true,'NONE' end
 if not required and immune then return false,rtext end
 if not required and not immune then return false,rtext end
end

function checkSpeed(unit,array,unitTarget) --CHECK 1
 local rtempa,itempa,r,i,required,immune = {},{},1,1,false,false
 local rtext = 'Targeting failed, ' .. tostring(unit.name.first_name) .. ' is too slow.'
 local itext = 'Targeting failed, ' .. tostring(unit.name.first_name) .. ' is too fast.'
 if type(array) ~= 'table' then array = {array} end
 local utemp = dfhack.units.computeMovementSpeed(unit)
 for _,x in ipairs(array) do
  if split(x,s1)[1] == 'min' then
   if tonumber(split(x,s1)[2]) > utemp then
    rtempa[r] = true
   else
    rtempa[r] = false
   end
   r = r + 1
  elseif split(x,s1)[1] == 'max' then
   if tonumber(split(x,s1)[2]) < utemp then
    itempa[i] = true
   else
    itempa[i] = false
   end
   i = i + 1
  elseif split(x,s1)[1] == 'greater' then
   if utemp/dfhack.units.computeMovementSpeed(unitTarget) >= tonumber(split(x,s1)[2]) then
    rtempa[r] = true
   else
    rtempa[r] = false
   end
   r = r + 1
  elseif split(x,s1)[1] == 'less' then
   if utemp/dfhack.units.computeMovementSpeed(unitTarget) <= tonumber(split(x,s1)[2]) then
    itempa[i] = true
   else
    itempa[i] = false
   end
   i = i + 1
  end
 end
 for _,x in ipairs(rtempa) do
  if x then required = true end
 end
 for _,x in ipairs(itempa) do
  if x then immune = true end
 end
 if required and not immune then return false,itext end
 if required and immune then return true,'NONE' end
 if not required and immune then return false,rtext end
 if not required and not immune then return false,rtext end
end

function checkBody(unit,array)
 local rtempa,itempa,r,i,required,immune = {},{},1,1,false,false
 local rtext = 'Targeting failed, ' .. tostring(unit.name.first_name) .. ' does not have the required body part.'
 local itext = 'Targeting failed, ' .. tostring(unit.name.first_name) .. ' has an immune body part.'
 local tempa,utempa = split(array,','),unit.body.body_plan.body_parts
 for _,x in ipairs(tempa) do
  t = split(x,';')[2]
  b = split(x,';')[3]
  if split(x,';')[1] == 'required' then
   if t == 'token' then
    for j,y in ipairs(utempa) do
     if y.token == b and not unit.body.components.body_part_status[j].missing then 
      rtempa[r] = true
     else
      rtempa[r] = false
     end
     r = r + 1
    end
   elseif t =='category' then
    for j,y in ipairs(utempa) do
     if y.category == b and not unit.body.components.body_part_status[j].missing then 
      rtempa[r] = true
     else
      rtempa[r] = false
     end
     r = r + 1
    end
   elseif t =='flags' then
    for j,y in ipairs(utempa) do
     if y.flags[b] and not unit.body.components.body_part_status[j].missing then 
      rtempa[r] = true
     else
      rtempa[r] = false
     end
     r = r + 1
    end
   end
  elseif split(x,';')[1] == 'immune' then
   if t == 'token' then
    for j,y in ipairs(utempa) do
     if y.token == b and not unit.body.components.body_part_status[j].missing then 
      itempa[i] = true
     else
      itempa[i] = false
     end
     i = i + 1
    end
   elseif t =='category' then
    for j,y in ipairs(utempa) do
     if y.category == b and not unit.body.components.body_part_status[j].missing then 
      itempa[i] = true
     else
      itempa[i] = false
     end
     i = i + 1
    end
   elseif t =='flags' then
    for j,y in ipairs(utempa) do
     if y.flags[b] and not unit.body.components.body_part_status[j].missing then 
      rtempa[r] = true
     else
      rtempa[r] = false
     end
     i = i + 1
    end
   end
  end
 end
 for _,x in ipairs(rtempa) do
  if x then required = true end
 end
 for _,x in ipairs(itempa) do
  if x then immune = true end
 end
 if required and not immune then return true,'NONE' end
 if required and immune then return false,itext end
 if not required and immune then return false,itext end
 if not required and not immune then return false,rtext end
end

function checkEntity(unit,array) -- CHECK 1
 local rtempa,itempa,r,i,required,immune = {},{},1,1,false,false
 local rtext = 'Targeting failed, ' .. tostring(unit.name.first_name) .. ' is not a member of a required entity.'
 local itext = 'Targeting failed, ' .. tostring(unit.name.first_name) .. ' is a member of an immune entity.'
 if unit.civ_id < 0 then return false, 'Targeting failed, ' .. tostring(unit.name.first_name) .. ' is an animal.' end
 if type(array) ~= 'table' then array = {array} end
 local utemp = df.global.world.entities[unit.civ_id].entity_raw.code
 for _,x in ipairs(array) do
  if split(x,s1)[1] == 'required' then
   if split(x,s1)[2] == utemp then
    rtempa[r] = true
   else
    rtempa[r] = false
   end
   r = r + 1
  elseif split(x,s1)[1] == 'immune' then
   if split(x,s1)[2] == utemp then
    itempa[r] = true
   else
    itempa[r] = false
   end
   i = i + 1
  end
 end
 for _,x in ipairs(rtempa) do
  if x then required = true end
 end
 for _,x in ipairs(itempa) do
  if x then immune = true end
 end
 if required and not immune then return true,'NONE' end
 if required and immune then return false,itext end
 if not required and immune then return false,itext end
 if not required and not immune then return false,rtext end
end

function checkProfession(unit,array) -- CHECK 1
 local rtempa,itempa,r,i,required,immune = {},{},1,1,false,false
 local rtext = 'Targeting failed, ' .. tostring(unit.name.first_name) .. ' is not the required profession.'
 local itext = 'Targeting failed, ' .. tostring(unit.name.first_name) .. ' is an immune profession.'
 if type(array) ~= 'table' then array = {array} end
 local utemp = unit.profession
 for _,x in ipairs(array) do
  if split(x,s1)[1] == 'required' then
   if df.profession[split(x,s1)[2]] == utemp then
    rtempa[r] = true
   else
    rtempa[r] = false
   end
   r = r + 1
  elseif split(x,s1)[1] == 'immune' then
   if df.profession[split(x,s1)[2]] == utemp then
    itempa[i] = true
   else
    itempa[i] = false
   end
   i = i + 1
  end
 end
 for _,x in ipairs(rtempa) do
  if x then required = true end
 end
 for _,x in ipairs(itempa) do
  if x then immune = true end
 end
 if required and not immune then return true,'NONE' end
 if required and immune then return false,itext end
 if not required and immune then return false,itext end
 if not required and not immune then return false,rtext end
end

function checkNoble(unit,array) -- CHECK 1
 local rtempa,itempa,r,i,required,immune = {},{},1,1,false,false
 local rtext = 'Targeting failed, ' .. tostring(unit.name.first_name) .. ' does not hold the required position.'
 local itext = 'Targeting failed, ' .. tostring(unit.name.first_name) .. ' is holding an immune position.'
 if type(array) ~= 'table' then array = {array} end
 local utempa = dfhack.units.getNoblePositions(unit)
 for _,x in ipairs(array) do
  for _,y in ipairs(utempa) do
   if split(x,s1)[1] == 'required' then
    if split(x,s1)[2] == y.position.code then
     rtempa[r] = true
    else
     rtempa[r] = false
    end
    r = r + 1
   elseif split(x,s1)[1] == 'immune' then
    if split(x,s1)[2] == y.position.code then
     itempa[i] = true
    else
     itempa[i] = false
    end
    i = i + 1
   end
  end
 end
 for _,x in ipairs(rtempa) do
  if x then required = true end
 end
 for _,x in ipairs(itempa) do
  if x then immune = true end
 end
 if required and not immune then return true,'NONE' end
 if required and immune then return false,itext end
 if not required and immune then return false,itext end
 if not required and not immune then return false,rtext end
end

function checkTypes(unit,class,creature,syndrome,token,immune) -- CHECK 1
 local unitraws = df.creature_raw.find(unit.race)
 local casteraws = unitraws.caste[unit.caste]
 local unitracename = unitraws.creature_id
 local castename = casteraws.caste_id
 local unitclasses = casteraws.creature_class
 local syndromes = df.global.world.raws.syndromes.all
 local actives = unit.syndromes.active
 local flags1 = unitraws.flags
 local flags2 = casteraws.flags
 local tokens = {}
 for k,v in pairs(flags1) do
  tokens[k] = v
 end
 for k,v in pairs(flags2) do
  tokens[k] = v
 end
 local tempa,ttempa,i,t,yes,no = {},{},1,1,false,false
 local yestext = 'Targeting failed, ' .. tostring(unit.name.first_name) .. ' is not an allowed type.'
 local notext = 'Targeting failed, ' .. tostring(unit.name.first_name) .. ' is an immune type.' 

 if class ~= 'NONE' then
  if type(class) ~= 'table' then class = {class} end
  for _,unitclass in ipairs(unitclasses) do
   for _,x in ipairs(class) do
    if x == unitclass.value then
     tempa[i] = true
    else
     tempa[i] = false
    end
    i = i + 1
   end
  end
 end
 if creature ~= 'NONE' then
  if type(creature) ~= 'table' then creature = {creature} end
  for _,x in ipairs(creature) do
   local xsplit = split(x,s1)
   print(xsplit[1],xsplit[2],unitracename,castename)
   if xsplit[1] == unitracename and xsplit[2] == castename then
    tempa[i] = true
   else
    tempa[i] = false
   end
   i = i + 1
  end
 end
 if syndrome ~= 'NONE' then
  if type(syndrome) ~= 'table' then syndrome = {syndrome} end
  for _,x in ipairs(actives) do
   local synclass=syndromes[x.type].syn_class
   for _,y in ipairs(synclass) do
    for _,z in ipairs(syndrome) do
     if z == y.value then
      tempa[i] = true
     else
      tempa[i] = false
     end
     i = i + 1
    end
   end
  end
 end
 if token ~= 'NONE' then
  if type(token) ~= 'table' then token = {token} end
  for _,x in ipairs(token) do
   ttempa[t] = tokens[x]
   t = t + 1       
  end
 end

 for _,x in ipairs(tempa) do
  if immune then
   if x then no = true end
  else
   if x then yes = true end
  end
 end
 for _,x in ipairs(ttempa) do
  if immune then
   if x then no = true end
  else
   if not x then 
    yes = false
    break
   else
    yes = true
   end
  end
 end
 if immune then
  if no then return false,notext end
 else
  if not yes then return false,yestext end
 end
 return true,'NONE'
end

function checkCounters(unit,array) -- CHECK 1
 tempa = split(array,s1)
 keys = tostring(unit.id)
 types = tempa[1]
 ints = tempa[2]
 style = tempa[3]
 n = tonumber(tempa[4])
 v = 0
 skey = ''
 si = 0
 pers,status = dfhack.persistent.get(keys..'_counters_1')
 num = 1
 match = false
 if not pers then
  dfhack.persistent.save({key=keys..'_counters_1',value=types,ints={ints,0,0,0,0,0,1}})
  v = ints
  skey = keys..'_counters_1'
  si=1
 else
  if pers.ints[7] <= 6 then
   local valuea = split(pers.value,'_')
   for i,x in ipairs(valuea) do
    if x == types then 
     pers.ints[i] = pers.ints[i] + ints
     v = pers.ints[i]
     skey = keys..'_counters_1'
     si = i
     match = true
    end
   end
   if not match then
    if pers.ints[7] < 6 then
     pers.value = pers.value .. '_' .. types
     pers.ints[7] = pers.ints[7] + 1
     pers.ints[pers.ints[7]] = ints
     v = ints
     skey = keys..'_counters_1'
     si = pers.ints[7]
     dfhack.persistent.save({key=pers.key,value=pers.value,ints=pers.ints})
    elseif pers.ints[7] == 6 then
     pers.ints[7] = 7
     dfhack.persistent.save({key=keys .. '_counters_2', value=types,ints={ints,0,0,0,0,0,0}})
     v = ints
     skey = keys..'_counters_2'
     si = 1
    end
   end
  else
   num = math.floor(pers.ints[7]/7)+1
   local valuea = split(pers.value,'_')
   for i,x in ipairs(valuea) do
    if x == types then
     pers.ints[i] = pers.ints[i] + ints
     v = pers.ints[i]
     skey = keys..'_counters_1'
     si = i
     match = true
    end
   end
   if not match then
    for j = 2, num, 1 do
     keysa = keys .. '_counters_' .. tostring(j)
     persa,status = dfhack.persistent.get(keysa)
     local valuea = split(persa.value,'_')
     for i,x in ipairs(valuea) do
      if x == types then
       persa.ints[i] = persa.ints[i] + ints
       v = persa.ints[i]
       skey = keysa
       si = i
       dfhack.persistent.save({key=persa.key,value=persa.value,ints=persa.ints})
       match = true
      end
     end
    end
   end
   if not match then
    pers.ints[7] = pers.ints[7] + 1
    if math.floor(pers.ints[7]/7) == pers.ints[7]/7 then
     keysa = keys..'_counters_'..tostring(num+1)
     dfhack.persistent.save({key=keysa, value=types,ints={ints,0,0,0,0,0,0}})
     v = ints
     skey = keysa
     si = 1
    else
     persa.value = persa.value..'_'..types
     persa.ints[pers.ints[7]-(num-1)*7+1] = persa.ints[pers.ints[7]-(num-1)*7+1] + ints
     v = persa.ints[pers.ints[7]-(num-1)*7+1]
     skey = keysa
     si = pers.ints[7]-(num-1)*7+1
     dfhack.persistent.save({key=persa.key,value=persa.value,ints=persa.ints})
    end
   end
  end
  dfhack.persistent.save({key=pers.key,value=pers.value,ints=pers.ints})
 end


 if style == 'minimum' then
  print(v,n,skey,si)
  if tonumber(v) >= n and n >= 0 then
   pers,status=dfhack.persistent.get(skey)
   pers.ints[si] = 0
   dfhack.persistent.save({key=skey,value=pers.value,ints=pers.ints})
   return true,'Counter minimum reached'
  end
 elseif style == 'percent' then
  rando = dfhack.random.new()
  roll = rando:drandom()
  if roll <= v/n and n >= 0 then
   pers,status=dfhack.persistent.get(skey)
   pers.ints[si] = 0
   dfhack.persistent.save({key=skey,value=pers.value,ints=pers.ints})
   return true,'Counter percent triggered'
  end
 end

 print(pers)
 return false, 'Not enough counters on unit'
end

function isSelected(unitSelf,unitCenter,unitTarget,args,count)

 silence = args.silence or 'NONE'
 reflect = args.reflect or 'NONE'
 radius = args.radius or '-1,-1,-1'
 plan = args.plan or 'NONE'
 age = args.age or 'NONE'
 speed = args.speed or 'NONE'
 physical = args.physical or 'NONE'
 mental = args.mental or 'NONE'
 skill = args.skill or 'NONE'
 trait = args.trait or 'NONE'
 noble = args.noble or 'NONE'
 profession = args.profession or 'NONE'
 entity = args.entity or 'NONE'
 iclass = args.iclass or 'NONE'
 icreature = args.icreature or 'NONE'
 isyndrome = args.isyndrome or 'NONE'
 itoken = args.itoken or 'NONE'
 aclass = args.aclass or 'NONE'
 acreature = args.acreature or 'NONE'
 asyndrome = args.asyndrome or 'NONE'
 atoken = args.atoken or 'NONE'
 counters = args.counters or 'NONE'
 
 local output = {
 caster = unitSelf,
 verbose = value['verbose'],
 }

-- Silence Check
 if silence ~= 'NONE' then
  if type(silence) ~= 'table' then silence = {silence} end
  local syndromes = df.global.world.raws.syndromes.all
  local sactives = unitSelf.syndromes.active
  for _,x in ipairs(sactives) do
   local ssynclass=syndromes[x.type].syn_class
   for _,y in ipairs(ssynclass) do
    for _,z in ipairs(silence) do
     if z == y.value then
      output['selected'] = {false}
      output['targets'] = {'NONE'}
      output['announcement'] = {'Casting failed, ' .. tostring(unitSelf.name.first_name) .. ' is prevented from using the interaction.'}
      return output 
     end
    end
   end
  end
 end

-- Distance Check
 local selected,targetList,announcement = checkDistance(unitTarget,radius,plan) 

-- Unit Checks
 for i = 1, #targetList, 1 do
  local unitCheck = targetList[i]

-- Target Check
  selected[i],announcement[i] = checkTarget(unitCheck,args.target,unitSelf)

-- Reflect Check
  if reflect ~= 'NONE' and selected[i] then
   if type(reflect) ~= 'table' then reflect = {reflect} end
   local syndromes = df.global.world.raws.syndromes.all
   local actives = unitCheck.syndromes.active
   for _,x in ipairs(actives) do
    local rsynclass=syndromes[x.type].syn_class
    for _,y in ipairs(rsynclass) do
     for _,z in ipairs(reflect) do
      if z == y.value then 
       targetList[i] = unitSelf
       announcement[i] = tostring(unitCheck.name.first_name) .. ' reflects the interaction back towards ' .. tostring(unitSelf.name.first_name) .. '.'
       unitCheck = unitSelf
      end
     end
    end
   end
  end

-- Age Check
  if age~= 'NONE' and selected[i] then
   selected[i],announcement[i] = checkAge(unitCheck,age,unitSelf)
  end

-- Speed Check
  if speed ~= 'NONE' and selected[i] then
   selected[i],announcement[i] = checkSpeed(unitCheck,speed,unitSelf)
  end

-- Physical Attributes Check
  if physical ~= 'NONE' and selected[i] then
   selected[i],announcement[i] = checkAttributes(unitCheck,physical,false,unitSelf)
  end

-- Mental Attributes Check
  if mental ~= 'NONE' and selected[i] then
   selected[i],announcement[i] = checkAttributes(unitCheck,mental,true,unitSelf)
  end

-- Skill Level Check
  if skill ~= 'NONE' and selected[i] then
   selected[i],announcement[i] = checkSkills(unitCheck,skill,unitSelf)
  end

-- Trait Check
  if trait ~= 'NONE' and selected[i] then
   selected[i],announcement[i] = checkTraits(unitCheck,trait,unitSelf)
  end

-- Noble Check
  if noble ~= 'NONE' and selected[i] then
   selected[i],announcement[i] = checkNoble(unitCheck,noble)
  end

-- Profession Check
  if profession ~= 'NONE' and selected[i] then
   selected[i],announcement[i] = checkProfession(unitCheck,profession)
  end

-- Entity Check
  if entity ~= 'NONE' and selected[i] then
   selected[i],announcement[i] = checkEntity(unitCheck,entity)
  end

-- Immune Check
  if (iclass ~= 'NONE' or icreature ~= 'NONE' or isyndrome ~= 'NONE' or itoken ~= 'NONE') and selected[i] then
   selected[i],announcement[i] = checkTypes(unitCheck,iclass,icreature,isyndrome,itoken,true)
  end

-- Required Check 
  if (aclass ~= 'NONE' or acreature ~= 'NONE' or asyndrome ~= 'NONE' or atoken ~= 'NONE') and selected[i] then
   selected[i],announcement[i] = checkTypes(unitCheck,aclass,acreature,asyndrome,atoken,false)
  end

-- Counters Check
  if counters ~= 'NONE' and selected[i] then
   selected[i],announcement[i] = checkCounters(unitCheck,counters)
  end

 end

 return selected,targetList,unitSelf,value['verbose'],announcement
end

function scriptRun(args)
 maxtargets = tonumber(args.maxtargets) or 0
 delay = tonumber(args.delay) or 0
 
 for count = 0, tonumber(args.chain) or 0, 1 do
  unit1 = df.unit.find(tonumber(args.unitSource))
  if count == 0 then unit2 = unit1 end
  if count == 0 then unit3 = df.unit.find(tonumber(args.unitTarget)) end
  if count > 0 then unit2 = unit3 end
  if count > 0 then unit3 = ctargets[math.random(1,#ctargets)] end
  local selected,targetList,unitSelf,verbose,announcement = isSelected(unit1,unit2,unit3,args,count)

  local targets = {}
  local nn = 1
  if maxtargets == 0 then
   for i,x in ipairs(targetList) do
    if selected[i] then
     targets[nn] = x
     nn = nn + 1
    end
   end
  else
   local temptargets = {}
   for i,x in ipairs(targetList) do
    if selected[i] then
     temptargets[nn] = x
     nn = nn + 1
    end
   end
   if maxtargets > #temptargets then maxtargets = #temptargets end
   temptargets = permute(temptargets)
   for i = 1,maxtargets,1 do
    targets[i] = temptargets[i]    
   end
  end
  ctargets = targets
  if args.center then targets = {unit3} end
  
  for j,y in ipairs(targets) do
   for k,z in ipairs(args.script) do
    if z == '!TARGET' then args.script[k] = y.id end
    if z == '!LOCATION' then args.script[k] = y.pos end
    if z == '!SOURCE' then args.script[k] = unit1.id end
	if z == '!CENTER' then args.script[k] = unit2.id end
    if z == '!VALUE' then args.script[k] = getValue(selected,targetList,unitSelf,y,args.value) end
   end
   if delay == 0 then 
    dfhack.run_script(args.script[1],select(2,table.unpack(args.script)))
   else
    dfhack.timeout(delay,'ticks',callback(args.script))
   end
  end
 end
end

validArgs = validArgs or utils.invert({
 'help',
 'unitTarget',
 'unitSource',
 'script',
 'chain',
 'value',
 'maxtargets',
 'delay',
 'radius',
 'target',
 'aclass',
 'acreature',
 'asyndrome',
 'atoken',
 'iclass',
 'icreature',
 'isyndrome',
 'itoken',
 'physical',
 'mental',
 'skills',
 'traits',
 'age',
 'speed',
 'noble',
 'profession',
 'entity',
 'reflect',
 'silence',
 'counters',
 'plan',
 'self',
 'verbose',
 'los',
 'center',
})
local args = utils.processArgs({...}, validArgs)

scriptRun(args)

