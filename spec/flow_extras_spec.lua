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
local flow_extras, describe, it, assert, flow, pending = flow_extras, describe, it, assert, flow, pending
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
			gui.Image{ bgimg = "flow_extras_list_bg.png", w = 1, h = 1 },
			gui.List{ inventory_location = "a", list_name = "b", w = 1, h = 1 }
		}, flow_extras.List{ inventory_location = "a", list_name = "b", w = 1, h = 1 })
		-- Should be noted that 0,0 is not a valid size, but this should not care.
	end)
	it("has a default theme background", function ()
		assert.same(gui.Stack{
			align_h = "center",
			align_v = "center",
			gui.Image{ w = 1, h = 1, bgimg = "flow_extras_list_bg.png" },
			gui.List{ inventory_location = "a", list_name = "b", w = 1, h = 1 }
		}, flow_extras.List{ inventory_location = "a", list_name = "b", w = 1, h = 1 })
	end)
	it("accepts a theme background string", function ()
		assert.same(gui.Stack{
			align_h = "center",
			align_v = "center",
			gui.Image{ w = 1, h = 1, bgimg = "c" },
			gui.List{ inventory_location = "a", list_name = "b", w = 1, h = 1 }
		}, flow_extras.List{ inventory_location = "a", list_name = "b", w = 1, h = 1, bgimg = "c" })
	end)
	it("accepts a listof theme backgrounds", function ()
		assert.same(gui.Stack{
			align_h = "center",
			align_v = "center",
			gui.HBox{
				spacing = 0.25,
				gui.Image{ w = 1, h = 1, bgimg = "c" },
				gui.Image{ w = 1, h = 1, bgimg = "d" },
				gui.Image{ w = 1, h = 1, bgimg = "e" },
				gui.Image{ w = 1, h = 1, bgimg = "c" },
				gui.Image{ w = 1, h = 1, bgimg = "d" }
			},
			gui.List{ inventory_location = "a", list_name = "b", w = 5, h = 1 }
		}, flow_extras.List{ inventory_location = "a", list_name = "b", w = 5, h = 1, bgimg = { "c", "d", "e" } })
	end)
	it("works with two demensions", function ()
		assert.same(gui.Stack{
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
					align_v = "d",
					gui.Stack{
						align_h = "center",
						align_v = "center",
						gui.VBox{
							spacing = 0.25,
							gui.Image{ w = 1, h = 1, bgimg = "c" },
							gui.Image{ w = 1, h = 1, bgimg = "c" }
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
					align_h = "d",
					gui.Stack{
						align_h = "center",
						align_v = "center",
						gui.HBox{
							spacing = 0.25,
							gui.Image{ w = 1, h = 1, bgimg = "c" },
							gui.Image{ w = 1, h = 1, bgimg = "c" }
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
					gui.Image{ bgimg = "flow_extras_list_bg.png", w = 1, h = 1 },
					gui.List{ inventory_location = "a", list_name = "b", w = 1, h = 1 }
				},
				gui.HBox{
					align_h = "e",
					gui.Stack{
						align_h = "center",
						align_v = "center",
						gui.Image{ h = 1, w = 1, bgimg = "flow_extras_list_bg.png" },
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
					gui.Image{ h = 1, w = 1, bgimg = "flow_extras_list_bg.png" },
					gui.List{ inventory_location = "a", list_name = "b", w = 1, h = 1 }
				},
				gui.VBox{
					align_v = "e",
					gui.Stack{
						align_h = "center",
						align_v = "center",
						gui.Image{ h = 1, w = 1, bgimg = "flow_extras_list_bg.png" },
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
				gui.Image{ h = 1, w = 1, bgimg = "flow_extras_list_bg.png" },
				gui.List{ inventory_location = "a", list_name = "b", w = 1, h = 1, starting_item_index = 100 }
			},
			gui.Stack{
				align_v = "center",
				align_h = "center",
				gui.Image{ h = 1, w = 1, bgimg = "flow_extras_list_bg.png" },
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
				gui.Image{ w = 1, h = 1, bgimg = "flow_extras_list_bg.png" },
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
					gui.Image{ w = 1, h = 1, bgimg = "c" }
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
						gui.Image{ w = 1, h = 1, bgimg = "flow_extras_list_bg.png" },
						gui.Image{ w = 1, h = 1, bgimg = "flow_extras_list_bg.png" }
					},
					gui.HBox{
						spacing = 1,
						gui.Image{ w = 1, h = 1, bgimg = "flow_extras_list_bg.png" },
						gui.Image{ w = 1, h = 1, bgimg = "flow_extras_list_bg.png" }
					}
				},
				gui.List{ inventory_location = "a", list_name = "b", w = 2, h = 2 }
			},
			gui.Stack{
				align_h = "center",
				align_v = "center",
				gui.VBox{
					spacing = 1,
					gui.Image{ w = 1, h = 1, bgimg = "flow_extras_list_bg.png" },
					gui.Image{ w = 1, h = 1, bgimg = "flow_extras_list_bg.png" }
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
end)
