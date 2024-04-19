authorizedFactions = {
    [1] = true,
    [3] = true
}

restrictedWeapons = {}
for i = 0, 15 do
	restrictedWeapons[i] = true
end

function explode(div,str)
  if (div=='') then return false end
  local pos,arr = 0,{}
  for st,sp in function() return string.find(str,div,pos,true) end do
	table.insert(arr,string.sub(str,pos,st-1))
	pos = sp + 1
  end
  table.insert(arr,string.sub(str,pos))
  return arr
end