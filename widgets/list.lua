---@module '../../flow/init.lua'
local flow = _G.flow --[[@as flow]]

---@class flow.widgets
local gui = flow.widgets

---@class flow_extras
local flow_extras = flow_extras

---@class ThemableList_fields:flow.widgets.List_fields
--luacheck: push no max comment line length
---@field spacing? number The amount of space between the list tiles. Defaults to `0.25` - the same amount as minetest out of the box.
---@field bgimg? boolean|string|(string[]) If present, applies each image in order, looping from left to right, top to bottom, on each list tile in the main list, followed by the remainder list, in the same pattern. By default, since `list[]` elements are opaque, you will not be able to see these images. Make use of `flow.widgets.Listcolors` to adjust this as needed. If `bgimg` is `false`, then no `bgimg`s are rendered. If it is `nil`, it defaults to `{ "flow_extras_list_bg.png" }`. If it is a string, it is wrapped in a table.
--luacheck: pop
--luacheck: push ignore ThemableList_fields
local ThemableList_fields
--luacheck: pop

---create a list, but themable
---
---you'll need to make sure List tiles are transparent to see anything
---@see flow.widgets.List
---@see flow.widgets.Listcolors
---@param fields ThemableList_fields
---@return FlowTree
local function ThemableList(fields)
	local spacing = fields.spacing or 0.25
	fields.spacing = nil
	local bgimg = fields.bgimg
	fields.bgimg = nil
	if type(bgimg) == "boolean" and not bgimg then
		return gui.List(fields)
	elseif not bgimg then
		bgimg = { "flow_extras_list_bg.png" }
	elseif type(bgimg) == "string" then
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
					gui.Image{ w = 1, h = 1, texture_name = the_image }
			end
		},
		gui.List(fields)
	}
end

---@class flow_extras.List_fields:ThemableList_fields
--luacheck: push no max comment line length
---@field remainder? number If `true`, the remainder will be below the rest of the `list[]`. Otherwise, it is to the right.
---@field remainder_v? boolean (Default `false`) If `true`, the remainder will be below the rest of the `list[]`. Otherwise, it is to the right.
---@field remainder_align? FlowAlign Passed into `align_v` on a `flow.widgets.VBox` if `remainder_v` or `align_h` on a `flow.widgets.HBox` to align the remainder list.
---@field listring? flow.widgets.Listring_fields[] A list of tables each passed to `flow.widgets.Listring`. Prepended with this `list[]`'s location and name, if provided. If not provided, `listring[]`s are not generated.
---@field align_h? FlowAlign If there is a remainder or a listring, this is passed to the the `flow.widgets.VBox` if `remainder_v` or `flow.widgets.Hbox` that wraps the entire element. Otherwise, this element does not exist, and either a `flow.widgets.Stack` or a `flow.widgets.List` is the root.
---@field align_v? FlowAlign If there is a remainder or a listring, this is passed to the the `flow.widgets.VBox` if `remainder_v` or `flow.widgets.Hbox` that wraps the entire element. Otherwise, this element does not exist, and either a `flow.widgets.Stack` or a `flow.widgets.List` is the root.
--luacheck: pop
flow_extras.List_fields = nil

---a themable list with remainder support
---@param fields flow_extras.List_fields
---@return FlowTree
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
	-- Only works when paired with gui.Listcolors{} is set to something (at least somewhat) transparent.
	-- https://github.com/minetest/minetest/blob/master/doc/lua_api.md#listcolorsslot_bg_normalslot_bg_hover
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
		local remainder_list = ThemableList{
			inventory_location = inventory_location,
			list_name = list_name,
			w = remainder_v and remainder or 1,
			h = remainder_v and 1         or remainder or 1,
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
