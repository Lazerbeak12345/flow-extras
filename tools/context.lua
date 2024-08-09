local flow_extras, flow, minetest = flow_extras, flow, minetest

local baby = nil
function flow_extras.set_wrapped_context(context, callback)
	assert(callback, "[flow_extras] set_wrapped_context requires two arguments")
	assert(type(context) == "table", "[flow_extras] set_wrapped_context the first argument must be a table")
	assert(type(callback) == "function", "[flow_extras] set_wrapped_context the second argument must be a function")
	local bathwater = false
	if baby then
		minetest.log("warning", "[flow_extras] set_wrapped_context was called within itself (recursive).")
	else
		bathwater = true
		baby = context
	end
	local ret = callback()
	if bathwater then
		baby = nil
	end
	return ret
end
function flow_extras.get_context()
	if flow.get_context then
		local it_worked, ctx = pcall(flow.get_context)
		if it_worked then
			if baby and baby ~= ctx then
				minetest.log("warning", "[flow_extras] you can't use set_wrapped_context to replace or override the context")
			end
			return ctx
		end
	end
	return baby
end
