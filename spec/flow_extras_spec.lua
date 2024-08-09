local function nilfn() end
local function ident(v)
	return function ()
		return v
	end
end
local minetest = {
	register_on_player_receive_fields = nilfn, register_on_leaveplayer = nilfn,
	register_chatcommand = nilfn
}
minetest.is_singleplayer = ident(true)
minetest.get_translator = ident(ident)
local FORMSPEC_AST_PATH = '../formspec_ast'
_G.FORMSPEC_AST_PATH = FORMSPEC_AST_PATH
function minetest.get_modpath(modname)
	if modname == "flow" then return "../flow" end
	if modname == "formspec_ast" then return FORMSPEC_AST_PATH end
	assert(modname == "flow_extras", "modname must be flow_extras. was " .. modname)
	return "."
end
dofile(FORMSPEC_AST_PATH .. '/init.lua')
_G.minetest = minetest -- Must be defined after formspec_ast runs
dofile"../flow/init.lua"
dofile"init.lua"
local flow_extras, describe, it, assert, flow = flow_extras, describe, it, assert, flow
local gui = flow.widgets
local function debug(...)
	for _, item in ipairs{ ... } do
		print"{"
		for key, value in pairs(item) do
			print("", key, " = ", value)
		end
		print"}"
	end
	return ...
end
assert(debug) -- Hack to make it so I don't have to ignore that this function is usually unused.
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
		assert.same(gui.Stack{
			align_h = "center",
			align_v = "center",
			gui.Image{ texture_name = "flow_extras_list_bg.png", w = 1, h = 1 },
			gui.List{ inventory_location = "a", list_name = "b", w = 1, h = 1 }
		}, flow_extras.List{ inventory_location = "a", list_name = "b", w = 1, h = 1 })
		-- Should be noted that 0,0 is not a valid size, but this should not care.
	end)
	describe("theme background", function ()
		it("has a default", function ()
			assert.same(gui.Stack{
				align_h = "center",
				align_v = "center",
				gui.Image{ w = 1, h = 1, texture_name = "flow_extras_list_bg.png" },
				gui.List{ inventory_location = "a", list_name = "b", w = 1, h = 1 }
			}, flow_extras.List{ inventory_location = "a", list_name = "b", w = 1, h = 1 })
		end)
		it("can be overriden with a string", function ()
			assert.same(gui.Stack{
				align_h = "center",
				align_v = "center",
				gui.Image{ w = 1, h = 1, texture_name = "c" },
				gui.List{ inventory_location = "a", list_name = "b", w = 1, h = 1 }
			}, flow_extras.List{ inventory_location = "a", list_name = "b", w = 1, h = 1, bgimg = "c" })
		end)
		describe("list overriding", function ()
			it("works with default starting_item_index", function ()
				assert.same(gui.Stack{
					align_h = "center",
					align_v = "center",
					gui.HBox{
						spacing = 0.25,
						gui.Image{ w = 1, h = 1, texture_name = "c" },
						gui.Image{ w = 1, h = 1, texture_name = "d" },
						gui.Image{ w = 1, h = 1, texture_name = "e" },
						gui.Image{ w = 1, h = 1, texture_name = "c" },
						gui.Image{ w = 1, h = 1, texture_name = "d" }
					},
					gui.List{ inventory_location = "a", list_name = "b", w = 5, h = 1 }
				}, flow_extras.List{ inventory_location = "a", list_name = "b", w = 5, h = 1, bgimg = { "c", "d", "e" } })
			end)
			it("works with specific starting_item_index", function ()
				assert.same(gui.Stack{
					align_h = "center",
					align_v = "center",
					gui.HBox{
						spacing = 0.25,
						gui.Image{ w = 1, h = 1, texture_name = "e" },
						gui.Image{ w = 1, h = 1, texture_name = "c" },
						gui.Image{ w = 1, h = 1, texture_name = "d" },
						gui.Image{ w = 1, h = 1, texture_name = "e" },
						gui.Image{ w = 1, h = 1, texture_name = "c" },
					},
					gui.List{ inventory_location = "a", list_name = "b", w = 5, h = 1, starting_item_index = 2 }
				}, flow_extras.List{
					inventory_location = "a",
					list_name = "b",
					w = 5,
					h = 1,
					bgimg = { "c", "d", "e" },
					starting_item_index = 2
				})
			end)
			it("asserts an error when list length is zero, according to # operator", function ()
				assert.has_error(function ()
					return  flow_extras.List{ inventory_location = "a", list_name = "b", w = 5, h = 1, bgimg = { } }
				end, "must not be a nil image 1")
				assert.has_error(function ()
					return  flow_extras.List{ inventory_location = "a", list_name = "b", w = 5, h = 1, bgimg = { [2]="c" } }
				end, "must not be a nil image 1")
			end)
		end)
	end)
	it("works with two demensions", function ()
		assert.same(gui.Stack{
			align_h = "center",
			align_v = "center",
			gui.VBox{
				spacing = 0.25,
				gui.HBox{
					spacing = 0.25,
					gui.Image{ w = 1, h = 1, texture_name = "c" },
					gui.Image{ w = 1, h = 1, texture_name = "c" },
				},
				gui.HBox{
					spacing = 0.25,
					gui.Image{ w = 1, h = 1, texture_name = "c" },
					gui.Image{ w = 1, h = 1, texture_name = "c" },
				},
				gui.HBox{
					spacing = 0.25,
					gui.Image{ w = 1, h = 1, texture_name = "c" },
					gui.Image{ w = 1, h = 1, texture_name = "c" },
				}
			},
			gui.List{ inventory_location = "a", list_name = "b", w = 2, h = 3 }
		}, flow_extras.List{ inventory_location = "a", list_name = "b", w = 2, h = 3, bgimg = "c" })
	end)
	describe("remainders", function ()
		it("can be rendered horizontally", function ()
			assert.same(gui.HBox{
				gui.Stack{
					align_h = "center",
					align_v = "center",
					gui.VBox{
						spacing = 0.25,
						gui.HBox{
							spacing = 0.25,
							gui.Image{ w = 1, h = 1, texture_name = "c" },
							gui.Image{ w = 1, h = 1, texture_name = "c" },
							gui.Image{ w = 1, h = 1, texture_name = "c" }
						},
						gui.HBox{
							spacing = 0.25,
							gui.Image{ w = 1, h = 1, texture_name = "c" },
							gui.Image{ w = 1, h = 1, texture_name = "c" },
							gui.Image{ w = 1, h = 1, texture_name = "c" }
						}
					},
					gui.List{ inventory_location = "a", list_name = "b", w = 3, h = 2 }
				},
				gui.VBox{
					align_v = "d",
					gui.Stack{
						align_h = "center",
						align_v = "center",
						gui.VBox{
							spacing = 0.25,
							gui.Image{ w = 1, h = 1, texture_name = "c" },
							gui.Image{ w = 1, h = 1, texture_name = "c" }
						},
						gui.List{ inventory_location = "a", list_name = "b", w = 1, h = 2, starting_item_index = 6 }
					}
				},
			}, flow_extras.List{
				inventory_location = "a",
				list_name = "b",
				w = 3,
				h = 2,
				remainder = 2,
				bgimg = "c",
				remainder_align = "d" -- included so we can see if the alignment box is a vbox or an hbox
			})
		end)
		it("can be rendered vertically", function ()
			assert.same(gui.VBox{
				gui.Stack{
					align_h = "center",
					align_v = "center",
					gui.VBox{
						spacing = 0.25,
						gui.HBox{
							spacing = 0.25,
							gui.Image{ w = 1, h = 1, texture_name = "c" },
							gui.Image{ w = 1, h = 1, texture_name = "c" },
							gui.Image{ w = 1, h = 1, texture_name = "c" }
						},
						gui.HBox{
							spacing = 0.25,
							gui.Image{ w = 1, h = 1, texture_name = "c" },
							gui.Image{ w = 1, h = 1, texture_name = "c" },
							gui.Image{ w = 1, h = 1, texture_name = "c" }
						}
					},
					gui.List{ inventory_location = "a", list_name = "b", w = 3, h = 2 }
				},
				gui.HBox{
					align_h = "d",
					gui.Stack{
						align_h = "center",
						align_v = "center",
						gui.HBox{
							spacing = 0.25,
							gui.Image{ w = 1, h = 1, texture_name = "c" },
							gui.Image{ w = 1, h = 1, texture_name = "c" }
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
				remainder_v = true,
				remainder_align = "d" -- included so we can see if the alignment box is a vbox or an hbox
			})
		end)
	end)
	describe("alignments", function ()
		it("works in vertical mode", function ()
			assert.same(gui.VBox{
				align_h = "c",
				align_v = "d",
				gui.Stack{
					align_h = "center",
					align_v = "center",
					gui.Image{ texture_name = "flow_extras_list_bg.png", w = 1, h = 1 },
					gui.List{ inventory_location = "a", list_name = "b", w = 1, h = 1 }
				},
				gui.HBox{
					align_h = "e",
					gui.Stack{
						align_h = "center",
						align_v = "center",
						gui.Image{ h = 1, w = 1, texture_name = "flow_extras_list_bg.png" },
						gui.List{ inventory_location = "a", list_name = "b", w = 1, h = 1, starting_item_index = 1 }
					}
				}
			}, flow_extras.List{
				inventory_location = "a",
				list_name = "b",
				w = 1, h = 1,
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
					gui.Image{ h = 1, w = 1, texture_name = "flow_extras_list_bg.png" },
					gui.List{ inventory_location = "a", list_name = "b", w = 1, h = 1 }
				},
				gui.VBox{
					align_v = "e",
					gui.Stack{
						align_h = "center",
						align_v = "center",
						gui.Image{ h = 1, w = 1, texture_name = "flow_extras_list_bg.png" },
						gui.List{ inventory_location = "a", list_name = "b", w = 1, h = 1, starting_item_index = 1 }
					}
				}
			}, flow_extras.List{
				inventory_location = "a",
				list_name = "b",
				w = 1, h = 1,
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
				gui.Image{ h = 1, w = 1, texture_name = "flow_extras_list_bg.png" },
				gui.List{ inventory_location = "a", list_name = "b", w = 1, h = 1, starting_item_index = 100 }
			},
			gui.Stack{
				align_v = "center",
				align_h = "center",
				gui.Image{ h = 1, w = 1, texture_name = "flow_extras_list_bg.png" },
				gui.List{ inventory_location = "a", list_name = "b", w = 1, h = 1, starting_item_index = 101 }
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
		assert.are.same(gui.HBox{
			gui.Stack{
				align_h = "center",
				align_v = "center",
				gui.Image{ w = 1, h = 1, texture_name = "flow_extras_list_bg.png" },
				gui.List{ inventory_location = "a", list_name = "b", w = 1, h = 1 }
			},
			gui.Listring{ inventory_location = "a", list_name = "b" },
			gui.Listring{ inventory_location = "c", list_name = "d" },
			gui.Listring{ inventory_location = "e", list_name = "f" }
		}, flow_extras.List{
			inventory_location = "a",
			list_name = "b",
			w = 1, h = 1,
			listring = { { inventory_location = "c", list_name = "d" }, { inventory_location = "e", list_name = "f" } }
		})
	end)
	describe("disabling bgimg", function ()
		it("can be done completely", function ()
			assert.same(
				gui.List{ inventory_location = "a", list_name = "b", w = 1, h = 1 },
				flow_extras.List{ inventory_location = "a", list_name = "b", w = 1, h = 1, bgimg = false }
			)
		end)
		it("can be done per image", function ()
			assert.same(gui.Stack{
				align_h = "center",
				align_v = "center",
				gui.VBox{
					spacing = 0.25,
					gui.Spacer{ w = 1, h = 1, expand = false },
					gui.Image{ w = 1, h = 1, texture_name = "c" }
				},
				gui.List{ inventory_location = "a", list_name = "b", w = 1, h = 2 },
			}, flow_extras.List{ inventory_location = "a", list_name = "b", w = 1, h = 2, bgimg = { false, "c" } })
		end)
	end)
	it("supports spacing variables", function ()
		-- NOTE: we didn't change the Style attribute of the list, because that's global. We assume you do that elsewhere
		assert.same(gui.HBox{
			gui.Stack{
				align_h = "center",
				align_v = "center",
				gui.VBox{
					spacing = 1,
					gui.HBox{
						spacing = 1,
						gui.Image{ w = 1, h = 1, texture_name = "flow_extras_list_bg.png" },
						gui.Image{ w = 1, h = 1, texture_name = "flow_extras_list_bg.png" }
					},
					gui.HBox{
						spacing = 1,
						gui.Image{ w = 1, h = 1, texture_name = "flow_extras_list_bg.png" },
						gui.Image{ w = 1, h = 1, texture_name = "flow_extras_list_bg.png" }
					}
				},
				gui.List{ inventory_location = "a", list_name = "b", w = 2, h = 2 }
			},
			gui.Stack{
				align_h = "center",
				align_v = "center",
				gui.VBox{
					spacing = 1,
					gui.Image{ w = 1, h = 1, texture_name = "flow_extras_list_bg.png" },
					gui.Image{ w = 1, h = 1, texture_name = "flow_extras_list_bg.png" }
				},
				gui.List{ inventory_location = "a", list_name = "b", w = 1, h = 2, starting_item_index = 4 }
			}
		}, flow_extras.List{ inventory_location = "a", list_name = "b", w = 2, h = 2, remainder = 2, spacing = 1 })
	end)
end)
describe("Grid", function ()
	it("is a function on flow_extras", function ()
		assert.are.equal("function", type(flow_extras.Grid))
	end)
	describe("returns gui.Nil{} when zero", function ()
		it("h", function ()
			assert.are.same(gui.Nil{}, flow_extras.Grid{ w = 1, h = 0, gui.Nil{} })
		end)
		it("w", function ()
			assert.are.same(gui.Nil{}, flow_extras.Grid{ w = 0, h = 1, gui.Nil{} })
		end)
	end)
	it("does not wrap single items", function ()
		assert.are.same(gui.Label{
			label = "a"
		}, flow_extras.Grid{
			w = 1, h = 1,
			gui.Label{ label = "a" }
		})
	end)
	describe("error cases", function ()
		it("requires a height", function ()
			assert.has.errors(function ()
				flow_extras.Grid{ w = 0 }
			end)
		end)
		it("requires a width", function ()
			assert.has.errors(function ()
				flow_extras.Grid{ h = 0 }
			end)
		end)
		it("requires a width and a height", function ()
			assert.has.errors(function ()
				flow_extras.Grid{}
			end)
		end)
	end)
	describe("render directions", function ()
		it("can render vertical", function ()
			assert.are.same(gui.VBox{
				gui.Label{ label = "a" },
				gui.Label{ label = "b" },
				gui.Label{ label = "c" }
			}, flow_extras.Grid{
				w = 1, h = 3,
				gui.Label{ label = "a" },
				gui.Label{ label = "b" },
				gui.Label{ label = "c" }
			})
		end)
		it("can render horizontal", function ()
			assert.are.same(gui.HBox{
				gui.Label{ label = "a" },
				gui.Label{ label = "b" },
				gui.Label{ label = "c" }
			}, flow_extras.Grid{
				w = 3, h = 1,
				gui.Label{ label = "a" },
				gui.Label{ label = "b" },
				gui.Label{ label = "c" }
			})
		end)
		it("can render vertical and horizontal", function ()
			assert.are.same(gui.VBox{
				gui.HBox{
					gui.Label{ label = "a" },
					gui.Label{ label = "b" },
				},
				gui.HBox{
					gui.Label{ label = "c" },
					gui.Label{ label = "d" }
				}
			}, flow_extras.Grid{
				w = 2, h = 2,
				gui.Label{ label = "a" },
				gui.Label{ label = "b" },
				gui.Label{ label = "c" },
				gui.Label{ label = "d" }
			})
		end)
	end)
	describe("callback children", function ()
		it("accepts a callback to get children by index", function ()
			assert.are.same(gui.VBox{
				gui.Label{ label = "asdf 1" },
				gui.Label{ label = "asdf 2" },
				gui.Label{ label = "asdf 3" }
			}, flow_extras.Grid{
				w = 1, h = 3,
				children_by_index = function (index)
					return gui.Label{ label = "asdf " .. index }
				end
			})
		end)
		it("protects against nil items index", function ()
			assert.has.errors(function ()
				flow_extras.Grid{
					w = 1, h = 1,
					children_by_index = nilfn
				}
			end)
		end)
		it("accepts a callback to get children by coords", function ()
			assert.are.same(gui.VBox{
				gui.HBox{
					gui.Label{ label = "blah 1,1" },
					gui.Label{ label = "blah 2,1" }
				},
				gui.HBox{
					gui.Label{ label = "blah 1,2" },
					gui.Label{ label = "blah 2,2" }
				}
			}, flow_extras.Grid{
				w = 2, h = 2,
				children_by_coords = function (x, y)
					return gui.Label{ label = "blah " .. x .. "," .. y }
				end
			})
		end)
		it("protects against nil items coords", function ()
			assert.has.errors(function ()
				flow_extras.Grid{
					w = 1, h = 1,
					children_by_coords = nilfn
				}
			end)
		end)
	end)
	describe("wrapper settings", function ()
		it("can be adjusted on col", function ()
			assert.are.same(gui.VBox{
				a = 1,
				gui.Label{ label = "a" },
				gui.Label{ label = "b" }
			}, flow_extras.Grid{
				w = 1, h = 2,
				VBox = function (children)
					children.a = 1
					return gui.VBox(children)
				end,
				gui.Label{ label = "a" },
				gui.Label{ label = "b" }
			})
		end)
		it("can be adjusted on row", function ()
			assert.are.same(gui.HBox{
				a = 1,
				gui.Label{ label = "a" },
				gui.Label{ label = "b" }
			}, flow_extras.Grid{
				w = 2, h = 1,
				HBox = function (children)
					children.a = 1
					return gui.HBox(children)
				end,
				gui.Label{ label = "a" },
				gui.Label{ label = "b" }
			})
		end)
		it("can be adjusted on both", function ()
			assert.are.same(gui.VBox{
				a = 1,
				gui.HBox{
					b = 4,
					gui.Label{ label = "a" },
					gui.Label{ label = "b" }
				},
				gui.HBox{
					b = 4,
					gui.Label{ label = "c" },
					gui.Label{ label = "d" }
				}
			}, flow_extras.Grid{
				w = 2, h = 2,
				VBox = function (children)
					children.a = 1
					return gui.VBox(children)
				end,
				HBox = function (children)
					children.b = 4
					return gui.HBox(children)
				end,
				gui.Label{ label = "a" },
				gui.Label{ label = "b" },
				gui.Label{ label = "c" },
				gui.Label{ label = "d" }
			})
		end)
	end)
	describe("trimming", function ()
		describe("height", function ()
			it("on normal case", function ()
				assert.are.same(gui.VBox{
					gui.Label{ label = "a" },
					gui.Label{ label = "b" },
					gui.Label{ label = "c" }
				}, flow_extras.Grid{
					w = 1, h = 3,
					gui.Label{ label = "a" },
					gui.Label{ label = "b" },
					gui.Label{ label = "c" },
					gui.Label{ label = "d" }
				})
			end)
			it("1 by 1", function ()
				assert.are.same(gui.Label{
					label = "a"
				}, flow_extras.Grid{
					w = 1, h = 1,
					gui.Label{ label = "a" },
					gui.Label{ label = "b" },
					gui.Label{ label = "c" },
					gui.Label{ label = "d" }
				})
			end)
		end)
		it("width on normal case", function ()
			assert.are.same(gui.HBox{
				gui.Label{ label = "a" },
				gui.Label{ label = "b" },
				gui.Label{ label = "c" }
			}, flow_extras.Grid{
				w = 3, h = 1,
				gui.Label{ label = "a" },
				gui.Label{ label = "b" },
				gui.Label{ label = "c" },
				gui.Label{ label = "d" }
			})
		end)
	end)
end)
describe("tools", function ()
	describe("flow_container_elms set", function ()
		it("is a table on flow_extras", function ()
			assert.equal("table", type(flow_extras.flow_container_elms))
		end)
		it("contains only true values and string keys", function ()
			for key, value in pairs(flow_extras.flow_container_elms) do
				assert.equal("string", type(key), "key must be a string")
				assert.equal(true, value, "all values must be exactly true")
			end
		end)
		-- I'm unsure how to test this. If I hardcode it, then the test is pointless, but directly referencing isn't possible.
		-- TODO: Perhaps contrasting the behavior of .walk with the two sets would work? This would still require hardcoding
		-- for the demo - even if I had property testing.
		--pending"is a superset of the formspec_ast container list"
	end)
	describe("walk", function ()
		it("is a function on flow_extras", function ()
			assert.equal("function", type(flow_extras.walk))
		end)
		it("iterates over every flow container", function ()
			-- use flow_container_elms to make a tree to iterate over
			local collection = {}
			local the_tree = gui.HBox{ }
			local function make_fake_tree(tree_type)
				collection[tree_type] = {
					type = tree_type,
					gui.Label{ label = "hi!" }
				}
				the_tree[#the_tree+1] = collection[tree_type]
			end
			-- This one's fake
			make_fake_tree"fake"
			for name, _ in pairs(flow_extras.flow_container_elms) do
				make_fake_tree(name)
			end
			-- Run the iteration, marking as we go
			for elm in flow_extras.walk(the_tree) do
				elm.marked = true
			end
			-- Assert that the marks are present.
			local modified_collection = {}
			local function make_fake_tree_after(tree_type, is_marked)
				modified_collection[tree_type] = {
					type = tree_type,
					gui.Label{ label = "hi!", marked = is_marked },
					marked = true
				}
			end
			make_fake_tree_after"fake" -- Fakes aren't marked
			-- make_fake_tree_after("container", true)
			make_fake_tree_after("hbox", true)
			make_fake_tree_after("stack", true)
			make_fake_tree_after("vbox", true)
			-- make_fake_tree_after("scroll_container", true)
			assert.same(collection, modified_collection)
			assert.Nil(the_tree.marked, "Just like in formspec_ast.walk, the tree itself is not iterated.")
		end)
	end)
	describe("search", function ()
		it("is a function on flow_extras", function ()
			assert.equal("function", type(flow_extras.search))
		end)
		it("walks over everything matching the given name", function ()
			local tree = {
				gui.Box{ color = "green" },
				gui.Label{ label = "the text" }
			}
			for node in flow_extras.search{
				tree = tree,
				values = { label = true }
			} do
				node.visited = true
			end
			assert.same({
				gui.Box{ color = "green" },
				gui.Label{ label = "the text", visited = true }
			}, tree)
		end)
		it("errors out if tree is not provided", function ()
			assert.has_error(function ()
				flow_extras.search{
					value = "hi"
				}
			end, "tree must be provided")
		end)
		it("errors out if both values and value are not provided", function ()
			assert.has_error(function ()
				flow_extras.search{
					tree = { gui.Label{ label = "label " } },
				}
			end, "either values or value arg must be provided")
		end)
		it("walks over everything matching the given names", function ()
			local tree = gui.HBox{
				gui.Nil{},
				gui.Box{ color = "green" },
				gui.Label{ label = "the text" }
			}
			for node in flow_extras.search{
				tree = tree,
				values = { hbox = true, label = true, box = true }
			} do
				node.visited = true
			end
			assert.same(gui.HBox{
				gui.Nil{},
				gui.Box{ color = "green", visited = true },
				gui.Label{ label = "the text", visited = true }
			}, tree)
		end)
		it("can search via differnt property instead of type", function ()
			local tree = {
				gui.Nil{},
				gui.Box{ color = "green" },
				gui.Label{ label = "the text" }
			}
			for node in flow_extras.search{
				tree = tree,
				key = "color",
				value = "green"
			} do
				node.visited = true
			end
			assert.same({
				gui.Nil{},
				gui.Box{ color = "green", visited = true },
				gui.Label{ label = "the text" }
			}, tree)
		end)
		it("can walk over the first instance of everything", function ()
			local tree = {
				gui.Asdf{},
				gui.Box{ color = "green" },
				gui.Label{ label = "the text" },
				gui.Label{ label = "the text" },
				gui.Label{ label = "the text" }
			}
			for node in flow_extras.search{
				tree = tree,
				values = { label = true, asdf = true },
				first_of_each = true
			} do
				node.visited = true
			end
			assert.same({
				gui.Asdf{ visited = true },
				gui.Box{ color = "green" },
				gui.Label{ label = "the text", visited = true },
				gui.Label{ label = "the text" },
				gui.Label{ label = "the text" }
			}, tree)
		end)
		it("can be broken out of", function ()
			local tree = {
				gui.Box{ color = "green" },
				gui.Label{ label = "the text" },
				gui.Label{ label = "the text" },
				gui.Label{ label = "the text" }
			}
			local count = 1
			for node in flow_extras.search{
				tree = tree,
				values = { label = true, box = true }
			} do
				node.visited = true
				if count == 2 then break end
				count = count + 1
			end
			assert.same({
				gui.Box{ color = "green", visited = true },
				gui.Label{ label = "the text", visited = true },
				gui.Label{ label = "the text" },
				gui.Label{ label = "the text" }
			}, tree)
		end)
		it("can include the root in the check", function ()
			local tree = gui.HBox{
				gui.Nil{},
				gui.Box{ color = "green" },
				gui.Label{ label = "the text" }
			}
			for node in flow_extras.search{
				tree = tree,
				check_root = true,
				values = { hbox = true, label = true, box = true }
			} do
				node.visited = true
			end
			assert.same(gui.HBox{
				visited = true,
				gui.Nil{},
				gui.Box{ color = "green", visited = true },
				gui.Label{ label = "the text", visited = true }
			}, tree)
		end)
	end)
	describe("contains", function ()
		it("is a function on flow_extras", function ()
			assert.equal("function", type(flow_extras.contains))
		end)
		it("errors if tree is not provided", function ()
			assert.has_error(function ()
				flow_extras.contains{
					value = "hi"
				}
			end)
		end)
		it("errors out if both values and value are not provided", function ()
			assert.has_error(function ()
				flow_extras.contains{
					tree = { gui.Label{ label = "label " } },
				}
			end, "either values or value arg must be provided")
		end)
		it("returns true if there was anything matching the given names", function ()
			assert.True(flow_extras.contains{
				tree = gui.HBox{
					gui.Nil{},
					gui.Box{ color = "green" },
					gui.Label{ label = "the text" }
				},
				values = { hbox = true, label = true, box = true }
			})
		end)
		it("returns false if there nothing matched the given names", function ()
			assert.False(flow_extras.contains{
				tree = gui.HBox{
					gui.Nil{},
					gui.Box{ color = "green" },
					gui.Label{ label = "the text" }
				},
				values = { vbox = true, asdf = true, fdsa = true }
			})
		end)
		it("can search via differnt property other than type", function ()
			assert.True(flow_extras.contains{
				tree = {
					gui.Nil{},
					gui.Box{ color = "green" },
					gui.Label{ label = "the text" }
				},
				key = "color",
				value = "green"
			})
		end)
		it("can include root in the check", function ()
			assert.True(flow_extras.contains{
				tree = gui.HBox{
					gui.Nil{},
					gui.Box{ color = "green" },
					gui.Label{ label = "the text" }
				},
				check_root = true,
				values = { hbox = true }
			})
		end)
	end)
	describe("get and set wrapped context", function ()
		it("is a pair of functions on flow_extras", function ()
			assert.equal("function", type(flow_extras.set_wrapped_context))
			assert.equal("function", type(flow_extras.get_context))
		end)
		local function _requires_flow_get_context(context, callback)
			-- flow.get_context is experimental. we can't rely on it since it's undocumented.
			assert.is.same(
				"function",
				type(flow.get_context),
				"flow-extras is outdated. get_context was removed TODO: see what it was replaced with"
			)
			local old_flow_get_context = flow.get_context
			flow.get_context = nil
			assert(not flow.get_context, "flow-extras is outdated, get_context works differently now")
			flow.get_context = function ()
				return context
			end
			callback()
			flow.get_context = old_flow_get_context
		end
		local function _requires_flow_get_context_is_gone(callback)
			local old_flow_get_context = flow.get_context
			if old_flow_get_context then
				flow.get_context = nil
				assert(not flow.get_context, "flow-extras is outdated, get_context works differently now")
			end
			callback()
			flow.get_context = old_flow_get_context
		end
		describe("set_wrapped_context", function ()
			it("returns what flow provides and ignores a set (yes flow, yes wrap, but they differ)", function ()
				local f_ctx = {}
				local w_ctx = {}
				spy.on(minetest, "log")
				_requires_flow_get_context(f_ctx, function ()
					local before_ctx = flow_extras.get_context()
					assert.same(f_ctx, before_ctx)
					assert.equal(f_ctx, before_ctx)
					flow_extras.set_wrapped_context(w_ctx, function ()
						local actual_ctx = flow_extras.get_context()
						assert.same(f_ctx, actual_ctx)
						assert.equal(f_ctx, actual_ctx)
						assert.same(w_ctx, actual_ctx)
						assert.are_not.equal(w_ctx, actual_ctx)
					end)
					local after_ctx = flow_extras.get_context()
					assert.same(f_ctx, after_ctx)
					assert.equal(f_ctx, after_ctx)
				end)
				assert.spy(minetest.log).was_called_with(
					"warning",
					"[flow_extras] you can't use set_wrapped_context to replace or override the context"
				)
			end)
			it("logs a warning if called within itself", function ()
				spy.on(minetest, "log")
				flow_extras.set_wrapped_context({}, function ()
					return flow_extras.set_wrapped_context({}, function ()
						return gui.Label{ label = "hi" }
					end)
				end)
				assert
					.spy(minetest.log)
					.was_called_with("warning", "[flow_extras] set_wrapped_context was called within itself (recursive).")
			end)
			it("returns the callback return", function ()
				assert.same(flow_extras.set_wrapped_context({}, function ()
					return gui.Label{ label = "hi" }
				end), gui.Label{ label = "hi" })
			end)
			describe("arguments", function ()
				it("both are required", function ()
					assert.has.errors(function ()
						flow_extras.set_wrapped_context()
					end, "[flow_extras] set_wrapped_context requires two arguments", "neither")
					assert.has.errors(function ()
						flow_extras.set_wrapped_context({})
					end, "[flow_extras] set_wrapped_context requires two arguments", "jst one")
				end)
				it("first must be table", function ()
					assert.has.errors(function ()
						flow_extras.set_wrapped_context(function () end, function () end)
					end, "[flow_extras] set_wrapped_context the first argument must be a table")
				end)
				it("second must be function", function ()
					assert.has.errors(function ()
						flow_extras.set_wrapped_context({}, true)
					end, "[flow_extras] set_wrapped_context the second argument must be a function")
				end)
			end)
		end)
		describe("get_context", function ()
			--[[
			-- [ ] [ ] Has Flow get context
			-- [ ] [ ] Does not have flow get context
			--  \   \___ Wrapped
			--   \______ Not wrapped
			--]]
			--_#
			--__
			it("yes flow yes wrap (and they are the same)", function ()
				local a = {}
				_requires_flow_get_context(a, function ()
					flow_extras.set_wrapped_context(a, function ()
						assert.equal(a, flow_extras.get_context())
					end)
				end)
			end)
			-- __
			-- _#
			it("yes wrap no flow works", function ()
				local a = {}
				_requires_flow_get_context_is_gone(function ()
					flow_extras.set_wrapped_context(a, function ()
						assert.equal(a, flow_extras.get_context())
					end)
				end)
			end)
			-- #_
			-- __
			it("yes flow no wrap works", function ()
				local a = {}
				_requires_flow_get_context(a, function ()
					assert.equal(a, flow_extras.get_context())
				end)
			end)
			-- __
			-- #_
			it("no flow no wrap returns nil", function ()
				assert.same(nil, flow_extras.get_context())
			end)
		end)
	end)
	describe("For", function ()
		it("is a function on flow_extras", function ()
			assert.equal("function", type(flow_extras.For))
		end)
		it("uses magical horrible values-related implicit lua features to unwrap things into a parent", function ()
			local things = { "a", "b", "c", also = "this" }
			local result = gui.VBox{
				gui.Nil{},
				table.unpack(
					flow_extras.For(ipairs(things))(function (_index, value)
						return gui.Button{ label = value }
					end)
				)
			}
			assert.same(gui.VBox{
				gui.Nil{},
				gui.Button{ label = "a" },
				gui.Button{ label = "b" },
				gui.Button{ label = "c" },
			}, result)
		end)
		it("duplicate as above but pairs", function ()
			local things = { "a", "b", "c", also = "this" }
			local result = gui.VBox{
				gui.Nil{},
				table.unpack(
					flow_extras.For(pairs(things))(function (_key, value)
						return gui.Button{ label = value }
					end)
				)
			}
			assert.same(gui.VBox{
				gui.Nil{},
				gui.Button{ label = "a" },
				gui.Button{ label = "b" },
				gui.Button{ label = "c" },
				gui.Button{ label = "this" }
			}, result)
		end)
		it("duplicate as above but next", function ()
			local things = { "a", "b", "c", also = "this" }
			local result = gui.VBox{
				gui.Nil{},
				table.unpack(
					flow_extras.For(next, things)(function (_key, value)
						return gui.Button{ label = value }
					end)
				)
			}
			assert.same(gui.VBox{
				gui.Nil{},
				gui.Button{ label = "a" },
				gui.Button{ label = "b" },
				gui.Button{ label = "c" },
				gui.Button{ label = "this" }
			}, result)
		end)
	end)
	describe("table_join", function ()
		it("is a table containing various named algorithms", function ()
			assert.equal("table", type(flow_extras.table_join))
			for _, value in pairs(flow_extras.table_join) do
				assert.equal("function", type(value))
			end
		end)
		local a, b
		before_each(function ()
			a = {
				unique = "to a",
				shared = "in a",
				"indexed in a"
			}
			b = {
				unique_to = "b",
				shared = "in b too",
				"indexed in b"
			}
		end)
		describe("unpack", function ()
			it("mimics the behavior of unpack", function ()
				assert.Nil(flow_extras.table_join.unpack(a, b), "return")
				assert.same({
					unique = "to a",
					shared = "in a",
					"indexed in a",
					table.unpack{ -- test against the real thing!
						unique_to = "b",
						shared = "in b too",
						"indexed in b"
					}
				}, a, "a")
				assert.same({
					unique_to = "b",
					shared = "in b too",
					"indexed in b"
				}, b, "b")
			end)
		end)
		describe("ignore", function ()
			it("copies all values over, unless they already exist", function ()
				assert.Nil(flow_extras.table_join.ignore(a, b), "return")
				assert.same({
					unique = "to a",
					unique_to = "b",
					shared = "in a",
					"indexed in a"
				}, a, "a")
				assert.same({
					unique_to = "b",
					shared = "in b too",
					"indexed in b"
				}, b, "b")
			end)
		end)
		describe("replace", function ()
			it("copies all values over, replacing ones that already exist", function ()
				assert.Nil(flow_extras.table_join.replace(a, b), "return")
				assert.same({
					unique = "to a",
					unique_to = "b",
					shared = "in b too",
					"indexed in b"
				}, a, "a")
				assert.same({
					unique_to = "b",
					shared = "in b too",
					"indexed in b"
				}, b, "b")
			end)
		end)
		describe("unpack_ignore", function ()
			it("appends indexes from b to a", function ()
				assert.Nil(flow_extras.table_join.unpack_ignore(a, b), "return")
				assert.same({
					unique = "to a",
					unique_to = "b",
					shared = "in a",
					"indexed in a",
					"indexed in b"
				}, a, "a")
				assert.same({
					unique_to = "b",
					shared = "in b too",
					"indexed in b"
				}, b, "b")
			end)
		end)
		describe("unpack_replace", function ()
			it("appends indexes from b to a", function ()
				assert.Nil(flow_extras.table_join.unpack_replace(a, b), "return")
				assert.same({
					unique = "to a",
					unique_to = "b",
					shared = "in b too",
					"indexed in a",
					"indexed in b"
				}, a, "a")
				assert.same({
					unique_to = "b",
					shared = "in b too",
					"indexed in b"
				}, b, "b")
			end)
		end)
	end)
end)
pending"fake"
--[[
describe("fake", function ()
	it("is a table on flow_extras", function ()
		assert.are.equal("table", type(flow_extras.fake))
	end)
	describe("Tabheader", function ()
		-- A fake tabheader[] element using buttons.
		-- It's more important that it works than if it looks good so transparency
		-- and borders might not be considered or supported.
		it("is a function inside the fake table on flow_extras", function ()
			assert.are.equal("function", type(flow_extras.fake.Tabheader))
		end)
		it("has a pointer to it on flow_extras that could also point to the real api for forward compatibility", function ()
			assert(flow_extras.Tabheader == flow_extras.fake.Tabheader or flow_extras.Tabheader == flow.widgets.Tabheader)
		end)
		-- * `H`: height of the tabheader. Width is automatically determined with this syntax.
		it("h", function ()
			assert.same(flow_extras.fake.Tabheader{
				h = 2,
				captions = { "a", "b", "c" },
				current_tab = 2,
				name = "testname"
			}, gui.HBox{
				name = "testname",
				gui.Button{ label = "a", name = "testname_1", h = 2 - 0.3 },
				gui.Button{ label = "b", name = "testname_2", h = 2 },
				gui.Button{ label = "c", name = "testname_3", h = 2 - 0.3 }
			})
		end)
		-- * `W` and `H`: width and height of the tabheader
		it("w + h", function ()
			assert.same(flow_extras.fake.Tabheader{
				h = 2,
				w = 1, -- make it so small that it will only show the first.
				captions = { "HJOFSIDF", "*", "oo", "0" },
				current_tab = 3,
				name = "nameeee"
			}, gui.HBox{
				-- The buttons that can't be rendered must be sliced into their
				-- own "page" of the tabheader, navvable via a pair of left and
				-- right buttons, right aligned in the HBox. To do this would
				-- require getting context, and behaving much like the
				-- flow.ScrollContainer thing
				name = "nameeee",
				max_w = 1,
				gui.Button{ label = "HJOFSIDF", name = "nameeee_1", h = 1 - 0.3 },
				--gui.Button{ label = "*",        name = "nameeee_2", h = 1 - 0.3 },
				--gui.Button{ label = "oo",       name = "nameeee_3", h = 1 },
				--gui.Button{ label = "0",        name = "nameeee_4", h = 1 - 0.3 }
				gui.Button{ label = "<", name = "nameeee_left", h = 1, align_h = "end" },
				gui.Button{ label = ">", name = "nameeee_right", h = 1, align_h = "end" }
			})
		end)
		pending"has ctx info that is updated on button click"
		pending"transparent" -- * `transparent` (optional): show transparent
		pending"draw_border" -- * `draw_border` (optional): draw border
		pending"left and right arrows for overflow (even though I could do better)"
	end)
end)]]
