local flow, flow_extras = flow, flow_extras
local gui = flow.widgets
local function ThemableList(fields)
	local spacing = fields.spacing or 0.25
	fields.spacing = nil
	local bgimg = fields.bgimg
	fields.bgimg = nil
	if type(bgimg) == "boolean" and not bgimg then
		return gui.List(fields)
	elseif not bgimg then
		bgimg = { "flow_extras_list_bg.png" }
	elseif type(bgimg) ~= "table" then
		bgimg = { bgimg }
	end
	local bgimg_idx = 1 + (fields.starting_item_index or 0)
	return gui.Stack{
		align_h = "center",
		align_v = "center",
		flow_extras.Grid{
			w = fields.w, h = fields.h,
			VBox = function (sub_fields)
				sub_fields.spacing = spacing
				return gui.VBox(sub_fields)
			end,
			HBox = function (sub_fields)
				sub_fields.spacing = spacing
				return gui.HBox(sub_fields)
			end,
			children_by_index = function (_)
				if bgimg_idx > #bgimg then
					bgimg_idx = 1
				end
				local the_image = bgimg[bgimg_idx]
				assert(type(the_image) ~= "nil", "must not be a nil image " .. bgimg_idx)
				bgimg_idx = bgimg_idx + 1
				return (type(the_image) == "boolean" and not the_image) and
					gui.Spacer{ w = 1, h = 1, expand = false } or
					gui.Image{ w = 1, h = 1, bgimg = the_image }
			end
		},
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

	local wrapper = {
		type = remainder_v and "vbox" or "hbox",
		align_h = align_h,
		align_v = align_v,
		main_list
	}
	if has_remainder then
		-- TODO: use a single grid element
		local remainder_list = ThemableList{
			inventory_location = inventory_location,
			list_name = list_name,
			w = remainder_v and remainder or 1,
			h = remainder_v and 1         or remainder,
			starting_item_index = (w * h) + (starting_item_index or 0),
			bgimg = bgimg,
			spacing = spacing
		}
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
