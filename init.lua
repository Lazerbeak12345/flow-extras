local flow = flow
local gui = flow.widgets
local flow_extras = {}
_G.flow_extras = flow_extras

local spacing = 0.25 -- TODO
local function ThemableList(fields)
	if type(fields.bgimg) == "boolean" and not fields.bgimg then
		return gui.List(fields)
	end
	local col = gui.VBox{ spacing = spacing }
	local bgimg = fields.bgimg or { "flow_extras_list_bg.png" } -- TODO change filename
	if type(bgimg) ~= "table" then
		bgimg = { bgimg }
	end
	local bgimg_idx = 1 + (fields.starting_item_index or 0)
	for _=1, fields.h do
		local row = gui.HBox{ spacing = spacing }
		for _=1, fields.w do
			if bgimg_idx > #bgimg then
				bgimg_idx = 1
			end
			local the_image = bgimg[bgimg_idx]
			assert(the_image, "must not be a nil image " .. bgimg_idx)
			row[#row+1] = gui.Image{ w = 1, h = 1, bgimg = the_image }
			bgimg_idx = bgimg_idx + 1
		end
		col[#col+1] = row
	end
	fields.bgimg = nil
	return gui.Stack{
		align_h = "center",
		align_v = "center",
		col,
		gui.List(fields)
	}
end

function flow_extras.List(fields)
	local inventory_location = fields.inventory_location
	local list_name = fields.list_name
	local w = fields.w
	local h = fields.h
	local starting_item_index = fields.starting_item_index
	local remainder = fields.remainder
	local remainder_v = fields.remainder_v
	local remainder_align = fields.remainder_align
	local listring = fields.listring or {}
	local bgimg = fields.bgimg
	local align_h = fields.align_h
	local align_v = fields.align_v
	local wrapper = {
		type = remainder_v and "vbox" or "hbox",
		align_h = align_h,
		align_v = align_v,
		ThemableList{
			inventory_location = inventory_location,
			list_name = list_name,
			w = w, h = h,
			starting_item_index = starting_item_index,
			bgimg = bgimg
		},
		(remainder and remainder > 0) and (
			remainder_v and gui.HBox{
				align_h = remainder_align,
				ThemableList{
					inventory_location = inventory_location,
					list_name = list_name,
					w = remainder, h = 1,
					starting_item_index = (w * h) + (starting_item_index or 0),
					bgimg = bgimg
				}
			} or gui.VBox{
				align_v = remainder_align,
				ThemableList{
					inventory_location = inventory_location,
					list_name = list_name,
					w = 1, h = remainder,
					starting_item_index = (w * h) + (starting_item_index or 0),
					bgimg = bgimg
				}
			}
		) or gui.Nil{}
	}
	if #listring > 0 then
		wrapper[#wrapper+1] = gui.Listring{
			inventory_location = inventory_location,
			list_name = list_name
		}
	end
	for _, item in ipairs(listring) do
		wrapper[#wrapper+1] = gui.Listring(item)
	end
	return wrapper
end
