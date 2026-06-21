local minetest = _G.minetest --[[@as minetest]]

---@module '../../flow/init.lua'
local flow = _G.flow --[[@as flow]]

---@class flow_extras
local flow_extras = flow_extras

---@type table|nil
local baby_c = nil
---@type userdata|nil
local baby_p = nil

---Compatibility layer so if flow.get_context is removed, your mod won't break.
---@see flow.get_context This function replaces this flow feature
---@see flow_extras.get_context How to get the context.
---@generic X:table
---@generic R
---@param context X
---@param callback fun(): R? While code is inside this function, the context is wrapped.
---@return R
function flow_extras.set_wrapped_context(context, player_or_callback, callback)
	assert(player_or_callback, "[flow_extras] set_wrapped_context requires two or three arguments")
	assert(type(context) == "table", "[flow_extras] set_wrapped_context the first argument must be a table")
	local player = nil
	if callback ~= nil then
		-- three args
		player = player_or_callback
		-- we don't check if it's a userdata type because we only need to know it
		-- must be a player object, and I don't see why disallowing virtual players
		-- would be a bad thing.
		assert(
			player.is_player
			and player:is_player(),
			"[flow_extras] set_wrapped_context with three arguments, the second argument must be a player")
		assert(
			type(callback) == "function",
			"[flow_extras] set_wrapped_context with three arguments, the third argument must be a function")
	else
		-- two args
		callback = player_or_callback
		assert(type(callback) == "function", "[flow_extras] set_wrapped_context the second argument must be a function")
	end
	local bathwater = false
	if baby_c then
		minetest.log("warning", "[flow_extras] set_wrapped_context was called within itself (recursive).")
	else
		bathwater = true
		baby_c = context
		baby_p = player
	end
	local ret = callback()
	if bathwater then
		baby_c = nil
		baby_p = nil
	end
	return ret
end

---get the context if it's possible.
---
---Takes advantage of both flow.get_context and flow_extras.get_context
---@see flow.get_context
---@see flow.set_wrapped_context
---@generic X:table
---@generic Y:userdata
---@return X|nil Y|nil
function flow_extras.get_context()
	if flow.get_context then
		local it_worked, ctx, player = pcall(flow.get_context)
		if it_worked then
			if baby_c and baby_c ~= ctx then
				minetest.log("warning", "[flow_extras] you can't use set_wrapped_context to replace or override the context")
			end
			return ctx, player
		end
	end
	return baby_c, baby_p
end
