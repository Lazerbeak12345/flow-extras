local flow, flow_extras = flow, flow_extras
local gui = flow.widgets
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
