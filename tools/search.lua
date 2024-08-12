---@class flow_extras
local flow_extras = _G.flow_extras

---@package
---@alias TruthTable table<any, boolean>

---@module '../../formspec_ast/init.lua'
local formspec_ast = _G.formspec_ast --[[@as formspec_ast]]

--- Truth table of flow element types (in their lowercase format) that are considered to be walkable.
---@see flow_extras.walk
---@type TruthTable
flow_extras.flow_container_elms = {
	-- TODO: are these needed?
	-- I'm pretty sure they don't work in flow.
	-- container = true,
	-- scroll_container = true,
	hbox = true,
	vbox = true,
	stack = true,
}

--- Returns an iterator, wrapping around formspec_ast.walk, using the known flow container elements instead of
--- formspec_ast's container elements.
---@see formspec_ast.walk
---@param tree FlowTree
---@return Iterator<FlowTree>
function flow_extras.walk(tree)
	return formspec_ast.walk(tree, flow_extras.flow_container_elms)
end


---Arguments given to flow_extras.search and others
---@see flow_extras.search
---@class flow_extras.search_Args
---@field tree FlowTree Tree to search within
---@field key? string Key to search for, defaulting to `"type"`
---@field value? any Value to look for on that key. Uses equals
--luacheck: push no max comment line length
---@field values? any[] If flow_extras.search.Args.value not provided, any value in this is looked for instead. Uses equals
--luacheck: pop
---@field first_of_each? boolean Given multiple values, each value will only be found one time.
---@field check_root? boolean Should we check the root?
flow_extras.search_Args = nil

---Return an iterator to search for matches to a pattern, given a tree.
---@param args flow_extras.search_Args
---@return Iterator<FlowTree>
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

---Search for at least one match to a pattern, given a tree.
---
---Always stops searching after the first match.
---@param args flow_extras.search_Args
---@return boolean # Was anything found?
function flow_extras.contains(args)
	return flow_extras.search(args)() and true or false
end
