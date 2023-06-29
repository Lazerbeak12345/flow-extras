local flow = flow
local gui = flow.widgets
local flow_extras = {}
_G.flow_extras = flow_extras

local function ThemableList(fields)
	local spacing = fields.spacing or 0.25
	fields.spacing = nil
	if type(fields.bgimg) == "boolean" and not fields.bgimg then
		fields.bgimg = nil
		return gui.List(fields)
	end
	local col = gui.VBox{ spacing = spacing }
	local bgimg = fields.bgimg or { "flow_extras_list_bg.png" } -- TODO change filename
	if type(bgimg) ~= "table" then
		bgimg = { bgimg }
	end
	local bgimg_idx = 1 + (fields.starting_item_index or 0)
	local w = fields.w
	local h = fields.h
	for _=1, h do
		local row = gui.HBox{ spacing = spacing }
		for _=1, w do
			if bgimg_idx > #bgimg then
				bgimg_idx = 1
			end
			local the_image = bgimg[bgimg_idx]
			assert(type(the_image) ~= "nil", "must not be a nil image " .. bgimg_idx)
			local item = (type(the_image) == "boolean" and not the_image) and
				gui.Spacer{ w = 1, h = 1, expand = false } or
				gui.Image{ w = 1, h = 1, bgimg = the_image }
			bgimg_idx = bgimg_idx + 1
			if w == 1 then
				row = item
			else
				row[#row+1] = item
			end
		end
		if h == 1 then
			col = row
		else
			col[#col+1] = row
		end
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
	local spacing = fields.spacing

	local main_list = ThemableList{
		inventory_location = inventory_location,
		list_name = list_name,
		w = w, h = h,
		starting_item_index = starting_item_index,
		bgimg = bgimg,
		spacing = spacing
	}

	local has_remainder = remainder and remainder > 0
	local has_listring = #listring > 1

	if (not has_remainder) and (not has_listring) then
		return main_list
	end

	local remainder_list
	if has_remainder then
		remainder_list = (
			remainder_v and ThemableList{
				inventory_location = inventory_location,
				list_name = list_name,
				w = remainder, h = 1,
				starting_item_index = (w * h) + (starting_item_index or 0),
				bgimg = bgimg,
				spacing = spacing
			} or ThemableList{
				inventory_location = inventory_location,
				list_name = list_name,
				w = 1, h = remainder,
				starting_item_index = (w * h) + (starting_item_index or 0),
				bgimg = bgimg,
				spacing = spacing
			}
		)
	end

	local wrapper = {
		type = remainder_v and "vbox" or "hbox",
		align_h = align_h,
		align_v = align_v,
		main_list
	}
	if has_remainder then
		wrapper[#wrapper+1] = (
			(not remainder_align) and remainder_list or
			remainder_v and gui.HBox{
				align_h = remainder_align,
				remainder_list
			} or gui.VBox{
				align_v = remainder_align,
				remainder_list
			}
		)
	end
	if has_listring then
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
