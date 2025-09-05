-- Originally used for Rei
-- Nowadays trimmed, just used as a lib for other things i was too lazy to move out
PTASaka.FH                      = {}

PTASaka.FH.merge                = function(arr1, arr2)
	local res = {}
	for k, v in pairs(arr1) do
		table.insert(res, v)
	end
	for k, v in pairs(arr2) do
		table.insert(res, v)
	end
	return res
end

PTASaka.FH.filter               = function(arr, f)
	local res = {}
	for i, v in pairs(arr) do
		if (f(v)) then
			table.insert(res, v)
		end
	end
	return res
end

PTASaka.FH.indexOf              = function(arr, f)
	for key, value in pairs(arr) do
		if f(value) then return key end
	end
	return -1
end

PTASaka.FH.take                 = function(arr, n)
	local res = {}
	for i = 1, n, 1 do
		if not arr[i] then return res end
		table.insert(res, arr[i])
	end
	return res
end

PTASaka.FH.map_f                = function(arr, f)
	local res = {}
	for k, v in pairs(arr) do
		table.insert(res, f(v))
	end
	return res
end
