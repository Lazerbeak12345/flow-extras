local flow_extras, formspec_ast, flow, minetest = flow_extras, formspec_ast, flow, minetest
flow_extras.flow_container_elms = {
	-- TODO: are these needed?
	-- I'm pretty sure they don't work in flow.
	-- container = true,
	-- scroll_container = true,
	hbox = true,
	vbox = true,
	stack = true,
}
function flow_extras.walk(tree)
	return formspec_ast.walk(tree, flow_extras.flow_container_elms)
end
function flow_extras.search(args)
	local tree = assert(args.tree, "tree must be provided")
	local key = args.key or "type"
	local value = args.value
	local values = args.values
	local first_of_each = args.first_of_each
	local check_root = args.check_root
	if check_root then
		tree = { tree } -- walk _never_ checks the root - so wrap it in a new root.
	end
	if not values then
		values = {}
		assert(value ~= nil, "either values or value arg must be provided")
		values[value] = true
	end
	local walk = flow_extras.walk(tree)
	return function()
		for node in walk do
			local actual_value = node[key]
			if values[actual_value] then
				if first_of_each then
					values[actual_value] = false
				end
				return node
			end
		end
	end
end
function flow_extras.contains(args)
	return flow_extras.search(args)() and true or false
end
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
