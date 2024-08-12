local minetest = _G.minetest --[[@as minetest]]

---@module '../../flow/init.lua'
local flow = _G.flow --[[@as flow]]

---@class flow_extras
local flow_extras = flow_extras

---@type table|nil
local baby = nil

---Compatibility layer so if flow.get_context is removed, your mod won't break.
---@see flow.get_context This function replaces this flow feature
---@see flow_extras.get_context How to get the context.
---@generic X:table
---@generic R
---@param context X
---@param callback fun(): R? While code is inside this function, the context is wrapped.
---@return R
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

---get the context if it's possible.
---
---Takes advantage of both flow.get_context and flow_extras.get_context
---@see flow.get_context
---@see flow.set_wrapped_context
---@generic X:table
---@return X|nil
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
