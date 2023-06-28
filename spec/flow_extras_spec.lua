local function nilfn() end
local function ident(v)
	return function ()
		return v
	end
end
local minetest = {
	register_on_player_receive_fields = nilfn, register_on_leaveplayer = nilfn, get_modpath = nilfn,
	register_chatcommand = nilfn
}
minetest.is_singleplayer = ident(true)
minetest.get_translator = ident(ident)
_G.minetest = minetest
dofile"../flow/init.lua"
dofile"init.lua"
local flow_extras, describe, it, assert, flow = flow_extras, describe, it, assert, flow
local gui = flow.widgets
describe("*basics*", function ()
	it("doesn't error out when loading init.lua", function ()
		assert(true, "by the time it got here it would have failed if it didn't work")
	end)
	it("provides a global variable for it's api to go into", function ()
		assert.are.equal("table", type(flow_extras), "flow_extras is a table")
	end)
end)
describe("List", function ()
	it("is a function on flow_extras", function ()
		assert.are.equal("function", type(flow_extras.List))
	end)
	it("renders a basic list when basic info is given", function ()
		assert.same(gui.HBox{
			gui.Stack{
				align_h = "center",
				align_v = "center",
				gui.VBox{ spacing = 0.25, },
				gui.List{ inventory_location = "a", list_name = "b", w = 0, h = 0 }
			},
			gui.Nil{}
		}, flow_extras.List{ inventory_location = "a", list_name = "b", w = 0, h = 0 })
		-- Should be noted that 0,0 is not a valid size, but this should not care.
	end)
	it("has a default theme background", function ()
		assert.same(gui.HBox{
			gui.Stack{
				align_h = "center",
				align_v = "center",
				gui.VBox{
					spacing = 0.25,
					gui.HBox{
						spacing = 0.25,
						gui.Image{ w = 1, h = 1, bgimg = "flow_extras_list_bg.png" }
					},
				},
				gui.List{ inventory_location = "a", list_name = "b", w = 1, h = 1 }
			},
			gui.Nil{}
		}, flow_extras.List{ inventory_location = "a", list_name = "b", w = 1, h = 1 })
	end)
	it("accepts a theme background string", function ()
		assert.same(gui.HBox{
			gui.Stack{
				align_h = "center",
				align_v = "center",
				gui.VBox{
					spacing = 0.25,
					gui.HBox{
						spacing = 0.25,
						gui.Image{ w = 1, h = 1, bgimg = "c" }
					},
				},
				gui.List{ inventory_location = "a", list_name = "b", w = 1, h = 1 }
			},
			gui.Nil{}
		}, flow_extras.List{ inventory_location = "a", list_name = "b", w = 1, h = 1, bgimg = "c" })
	end)
	it("accepts a listof theme backgrounds", function ()
		assert.same(gui.HBox{
			gui.Stack{
				align_h = "center",
				align_v = "center",
				gui.VBox{
					spacing = 0.25,
					gui.HBox{
						spacing = 0.25,
						gui.Image{ w = 1, h = 1, bgimg = "c" },
						gui.Image{ w = 1, h = 1, bgimg = "d" },
						gui.Image{ w = 1, h = 1, bgimg = "e" },
						gui.Image{ w = 1, h = 1, bgimg = "c" },
						gui.Image{ w = 1, h = 1, bgimg = "d" }
					},
				},
				gui.List{ inventory_location = "a", list_name = "b", w = 5, h = 1 }
			},
			gui.Nil{}
		}, flow_extras.List{ inventory_location = "a", list_name = "b", w = 5, h = 1, bgimg = { "c", "d", "e" } })
	end)
	it("works with two demensions", function ()
		assert.same(gui.HBox{
			gui.Stack{
				align_h = "center",
				align_v = "center",
				gui.VBox{
					spacing = 0.25,
					gui.HBox{
						spacing = 0.25,
						gui.Image{ w = 1, h = 1, bgimg = "c" },
						gui.Image{ w = 1, h = 1, bgimg = "c" },
					},
					gui.HBox{
						spacing = 0.25,
						gui.Image{ w = 1, h = 1, bgimg = "c" },
						gui.Image{ w = 1, h = 1, bgimg = "c" },
					},
					gui.HBox{
						spacing = 0.25,
						gui.Image{ w = 1, h = 1, bgimg = "c" },
						gui.Image{ w = 1, h = 1, bgimg = "c" },
					}
				},
				gui.List{ inventory_location = "a", list_name = "b", w = 2, h = 3 }
			},
			gui.Nil{}
		}, flow_extras.List{ inventory_location = "a", list_name = "b", w = 2, h = 3, bgimg = "c" })
	end)
	it("displays a remainder line", function ()
		assert.same(gui.HBox{
			gui.Stack{
				align_h = "center",
				align_v = "center",
				gui.VBox{
					spacing = 0.25,
					gui.HBox{
						spacing = 0.25,
						gui.Image{ w = 1, h = 1, bgimg = "c" },
						gui.Image{ w = 1, h = 1, bgimg = "c" },
						gui.Image{ w = 1, h = 1, bgimg = "c" }
					},
					gui.HBox{
						spacing = 0.25,
						gui.Image{ w = 1, h = 1, bgimg = "c" },
						gui.Image{ w = 1, h = 1, bgimg = "c" },
						gui.Image{ w = 1, h = 1, bgimg = "c" }
					}
				},
				gui.List{ inventory_location = "a", list_name = "b", w = 3, h = 2 }
			},
			gui.VBox{
				gui.Stack{
					align_h = "center",
					align_v = "center",
					gui.VBox{
						spacing = 0.25,
						gui.HBox{
							spacing = 0.25,
							gui.Image{ w = 1, h = 1, bgimg = "c" }
						},
						gui.HBox{
							spacing = 0.25,
							gui.Image{ w = 1, h = 1, bgimg = "c" }
						}
					},
					gui.List{ inventory_location = "a", list_name = "b", w = 1, h = 2, starting_item_index = 6 }
				}
			},
		}, flow_extras.List{ inventory_location = "a", list_name = "b", w = 3, h = 2, remainder = 2, bgimg = "c" })
	end)
	it("supports vertical remainders", function ()
		assert.same(gui.VBox{
			gui.Stack{
				align_h = "center",
				align_v = "center",
				gui.VBox{
					spacing = 0.25,
					gui.HBox{
						spacing = 0.25,
						gui.Image{ w = 1, h = 1, bgimg = "c" },
						gui.Image{ w = 1, h = 1, bgimg = "c" },
						gui.Image{ w = 1, h = 1, bgimg = "c" }
					},
					gui.HBox{
						spacing = 0.25,
						gui.Image{ w = 1, h = 1, bgimg = "c" },
						gui.Image{ w = 1, h = 1, bgimg = "c" },
						gui.Image{ w = 1, h = 1, bgimg = "c" }
					}
				},
				gui.List{ inventory_location = "a", list_name = "b", w = 3, h = 2 }
			},
			gui.HBox{
				gui.Stack{
					align_h = "center",
					align_v = "center",
					gui.VBox{
						spacing = 0.25,
						gui.HBox{
							spacing = 0.25,
							gui.Image{ w = 1, h = 1, bgimg = "c" },
							gui.Image{ w = 1, h = 1, bgimg = "c" }
						}
					},
					gui.List{ inventory_location = "a", list_name = "b", w = 2, h = 1, starting_item_index = 6 }
				}
			},
		}, flow_extras.List{
			inventory_location = "a",
			list_name = "b",
			w = 3, h = 2,
			bgimg = "c",
			remainder = 2,
			remainder_v = true
		})
	end)
	describe("alignments", function ()
		it("works in vertical mode", function ()
			assert.same(gui.VBox{
				align_h = "c",
				align_v = "d",
				gui.Stack{
					align_h = "center",
					align_v = "center",
					gui.VBox{ spacing = 0.25, },
					gui.List{ inventory_location = "a", list_name = "b", w = 0, h = 0 }
				},
				gui.HBox{
					align_h = "e",
					gui.Stack{
						align_h = "center",
						align_v = "center",
						gui.VBox{
							spacing = 0.25,
							gui.HBox{
								spacing = 0.25,
								gui.Image{ h = 1, w = 1, bgimg = "flow_extras_list_bg.png" }
							}
						},
						gui.List{ inventory_location = "a", list_name = "b", w = 1, h = 1, starting_item_index = 0 }
					}
				}
			}, flow_extras.List{
				inventory_location = "a",
				list_name = "b",
				w = 0, h = 0,
				remainder_v = true,
				align_h = "c",
				align_v = "d",
				remainder_align = "e",
				remainder = 1
			})
		end)
		it("works in horizontal mode", function ()
			assert.same(gui.HBox{
				align_h = "c",
				align_v = "d",
				gui.Stack{
					align_h = "center",
					align_v = "center",
					gui.VBox{ spacing = 0.25, },
					gui.List{ inventory_location = "a", list_name = "b", w = 0, h = 0 }
				},
				gui.VBox{
					align_v = "e",
					gui.Stack{
						align_h = "center",
						align_v = "center",
						gui.VBox{
							spacing = 0.25,
							gui.HBox{
								spacing = 0.25,
								gui.Image{ h = 1, w = 1, bgimg = "flow_extras_list_bg.png" }
							}
						},
						gui.List{ inventory_location = "a", list_name = "b", w = 1, h = 1, starting_item_index = 0 }
					}
				}
			}, flow_extras.List{
				inventory_location = "a",
				list_name = "b",
				w = 0, h = 0,
				remainder_v = false,
				align_h = "c",
				align_v = "d",
				remainder_align = "e",
				remainder = 1
			})
		end)
	end)
	it("supports starting item index", function ()
		assert.same(gui.HBox{
			gui.Stack{
				align_h = "center",
				align_v = "center",
				gui.VBox{
					spacing = 0.25,
					gui.HBox{
						spacing = 0.25,
						gui.Image{ h = 1, w = 1, bgimg = "flow_extras_list_bg.png" }
					}
				},
				gui.List{ inventory_location = "a", list_name = "b", w = 1, h = 1, starting_item_index = 100 }
			},
			gui.VBox{
				gui.Stack{
					align_v = "center",
					align_h = "center",
					gui.VBox{
						spacing = 0.25,
						gui.HBox{
							spacing = 0.25,
							gui.Image{ h = 1, w = 1, bgimg = "flow_extras_list_bg.png" }
						}
					},
					gui.List{ inventory_location = "a", list_name = "b", w = 1, h = 1, starting_item_index = 101 }
				}
			}
		}, flow_extras.List{
			starting_item_index = 100,
			remainder = 1,
			inventory_location = "a",
			list_name = "b",
			w = 1, h = 1
		})
	end)
	it("has listring support", function ()
		assert.same(gui.HBox{
			gui.Stack{
				align_h = "center",
				align_v = "center",
				gui.VBox{ spacing = 0.25 },
				gui.List{ inventory_location = "a", list_name = "b", w = 0, h = 0 }
			},
			gui.Nil{},
			gui.Listring{ inventory_location = "a", list_name = "b" },
			gui.Listring{ inventory_location = "c", list_name = "d" },
			gui.Listring{ inventory_location = "e", list_name = "f" }
		}, flow_extras.List{
			inventory_location = "a",
			list_name = "b",
			w = 0, h = 0,
			listring = { { inventory_location = "c", list_name = "d" }, { inventory_location = "e", list_name = "f" } }
		})
	end)
end)
