---@module '../../flow/init.lua'
local flow = _G.flow --[[@as flow]]

---@class flow_extras
local flow_extras = flow_extras

local gui = flow.widgets

---@class flow_extras.Grid_fields
---@field w number number of things wide
---@field h number number of things high
--luacheck: push no max comment line length
---@field VBox? flow.widgets.VBox If needed, an outer box that ensures multiple vertical things
---@field HBox? flow.widgets.HBox If needed, a middle box that ensures multiple horizontal things
--luacheck: pop
---@field children_by_index? fun(index:number): FlowTree
---@field [number] FlowTree
---@field children_by_coords? fun(x:number, y:number): FlowTree uses children_by_index if not present
flow_extras.Grid_fields = nil

---lay out elements in a grid like pattern
---@param fields flow_extras.Grid_fields
---@return FlowTree
function flow_extras.Grid(fields)
	local w = assert(fields.w, "requires a width")
	local h = assert(fields.h, "requires a height")
	if w == 0 or h == 0 then return gui.Nil{} end
	local vbox = fields.VBox or gui.VBox
	local hbox = fields.HBox or gui.HBox
	local get_child_by_index = fields.children_by_index or function (index)
		return fields[index]
	end
	local get_child_by_coords = fields.children_by_coords or function (x, y)
		return get_child_by_index(x+(y-1)*w)
	end
	local col = {}
	for hi=1, h do
		local row = {}
		for wi=1, w do
			local item = get_child_by_coords(wi, hi)
			assert(item, "item must not be nil")
			row[wi] = item
		end
		col[hi] = w == 1 and row[1] or hbox(row)
	end
	return h == 1 and col[1] or vbox(col)
end
