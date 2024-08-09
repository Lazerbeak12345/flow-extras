local flow_extras = flow_extras

function flow_extras.For(iterator, invariant, control)
	return function (callback)
		local accumulator = {}
		while true do
			local iteration_result = { iterator(invariant, control) }
			control = iteration_result[1]
			if not control then
				break
			end
			accumulator[#accumulator+1] = callback(table.unpack(iteration_result))
		end
		return accumulator
	end
end

flow_extras.table_join = {}

function flow_extras.table_join.unpack_ignore(a, b)
	for key, value in pairs(b) do
		if type(key) == "number" then
			a[#a+1] = value
		elseif not a[key] then
			a[key] = value
		end
	end
end

function flow_extras.table_join.unpack_replace(a, b)
	for key, value in pairs(b) do
		if type(key) == "number" then
			a[#a+1] = value
		else
			a[key] = value
		end
	end
end

function flow_extras.table_join.unpack(a, b)
	for _, value in ipairs(b) do
		a[#a+1] = value
	end
end

function flow_extras.table_join.ignore(a, b)
	for key, value in pairs(b) do
		if not a[key] then
			a[key] = value
		end
	end
end

function flow_extras.table_join.replace(a, b)
	for key, value in pairs(b) do
		a[key] = value
	end
end
