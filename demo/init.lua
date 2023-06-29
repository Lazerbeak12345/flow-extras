local flow, minetest = flow, minetest
local example_form = flow.make_gui(function (player, ctx)
	return flow_extras.List{
		inventory_location = "current_player",
		list_name = "main",
		w = 5,
		h = 4,
		remainder = 4,
		remainder_v = true,
		remainder_align = "start"
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
