local flow, minetest, flow_extras = flow, minetest, flow_extras
local gui = flow.widgets
local example_form = flow.make_gui(function ()
	return gui.HBox{
		gui.VBox{
			gui.Label{ label = "List demo" },
			flow_extras.List{
				inventory_location = "current_player",
				list_name = "main",
				w = 5,
				h = 4,
				remainder = 4,
				remainder_v = true,
				remainder_align = "start"
			},
		},
		gui.VBox{
			gui.Label{ label = "Grid demo" },
			flow_extras.Grid{
				w = 2, h = 2,
				VBox = function (children)
					children.align_v = "center"
					children.expand = true
					return gui.VBox(children)
				end,
				HBox = function (children)
					children.align_h = "center"
					return gui.HBox(children)
				end,
				gui.Button{ label = "top left" },
				gui.Button{ label = "top right" },
				gui.Button{ label = "bottom left" },
				gui.Button{ label = "bottom right" }
			}
		}
	}
end)
assert(minetest.is_singleplayer())
minetest.register_chatcommand("flow-extras-example", {
	privs = { server = true },
	help = "Shows an example flow-extras formspec",
	func = function (name)
		example_form:show(minetest.get_player_by_name(name))
	end
})
