local flow_extras, formspec_ast = flow_extras, formspec_ast
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
