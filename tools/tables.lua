---@class flow_extras
local flow_extras = flow_extras

---Given for-style iterator args, retun a function expecting a callback called with the same params as a for loop.
---
---```lua
---gui.HBox{
---	table.unpack(
---		flow_extras.For(ipairs{ "a", "b", "c" })(function (index, letter)
---			return gui.Label{ label = letter }
---		end)
---	)
---}
---```
---
---```lua
---local a = flow_extras.For(pairs{ k="v"})(function (key, value)
---	return key..value
---end)
---assert.equals("kv", a)
---```
---
---@generic I, C, V, R
--luacheck: push no max comment line length
---@param iterator fun(invariant: I, control: C): C, ...:V Such an iterator can be `next`. ipairs and pairs both return `next` along with the other values you need.
--luacheck: pop
---@param invariant? I
---@param control? C
---@return fun(callback:fun(control:C, ...:V):R): R[] # The final function builds a list and returns it
---@nodiscard
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

---@class flow_extras.table_join
flow_extras.table_join = {}

---merge two tables in a similar way to unpacking a table into a table
---@see table.unpack
---@param a table modified with the features in b
---@param b table
function flow_extras.table_join.unpack(a, b)
	for _, value in ipairs(b) do
		a[#a+1] = value
	end
end

---merge values into first table, ignoring duplicates
---@param a table modified with the features in b
---@param b table
function flow_extras.table_join.ignore(a, b)
	for key, value in pairs(b) do
		if not a[key] then
			a[key] = value
		end
	end
end

---merge values into first table, replacing duplicates
---@param a table modified with the features in b
---@param b table
function flow_extras.table_join.replace(a, b)
	for key, value in pairs(b) do
		a[key] = value
	end
end

---merge two tables, numeric indexes are merged like table.unpack, others are merged like flow_extras.table_join.ignore
---@see table.unpack
---@see flow_extras.table_join.ignore
---@param a table modified with the features in b
---@param b table
function flow_extras.table_join.unpack_ignore(a, b)
	for key, value in pairs(b) do
		if type(key) == "number" then
			a[#a+1] = value
		elseif not a[key] then
			a[key] = value
		end
	end
end

---merge two tables, numeric indexes are merged like table.unpack, others are merged like flow_extras.table_join.replace
---@see table.unpack
---@see flow_extras.table_join.replace
---@param a table modified with the features in b
---@param b table
function flow_extras.table_join.unpack_replace(a, b)
	for key, value in pairs(b) do
		if type(key) == "number" then
			a[#a+1] = value
		else
			a[key] = value
		end
	end
end
