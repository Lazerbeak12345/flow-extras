


-- What's all this stuff behind the ---? That's LuaCATS documentation.
-- It does typechecking as well, so I've documented types for 3rd party untyped utilities - to make sure I'm (at least)
-- documenting what I thinkking the APIs do (and how I'm using them) - that and some apis are building upon things from
-- others.

---@package
---@class minetest.register_chatcommand_params
---@field privs TruthTable
---@field help string
---@field func fun(player:string)

---@package
---@class minetest.Player

---@package
---@class minetest
---@field log fun(type:"warning", message:string)
---@field is_singleplayer fun():boolean
---@field register_chatcommand fun(cmd:string, params:minetest.register_chatcommand_params)
---@field get_player_by_name fun(player:string):minetest.Player
---@module 'minetest' -- ???
local minetest = _G.minetest --[[@as minetest]]

---@package
---@alias FormspecAstTree { type:string, [number]:FormspecAstTree, [string]:any }

---@package
---@class formspec_ast
---@field walk fun(flow_tree:FormspecAstTree, truth_table:TruthTable): Iterator<FormspecAstTree>
---@module '../../formspec_ast/init.lua'
--luacheck: push ignore formspec_ast
--local formspec_ast = _G.formspec_ast --[[@as formspec_ast]]
--luacheck: pop

---@package
---@alias FlowTree FormspecAstTree

---@package
---@alias FlowAlign "auto"|"start"|"end"|"centre"|"fill"|"center"

---@package
---@class flow.widget_fields
---@field expand? boolean
---@field [number] FlowTree

---@package
---@class flow.widgets.Listring_fields:flow.widget_fields
---@field inventory_location string See minetest's `list[]` documentation for more information.
---@field list_name string See minetest's documentation for `list[]` for more information.

---@package
---@alias flow.widgets.Listring fun(fields: flow.widgets.Listring_fields): FlowTree

---@package
---@class flow.widgets.List_fields:flow.widgets.Listring_fields
---@field w number Width of list in tiles. See minetest's documentation for `list[]` for more information.
---@field h number Height of list in tiles. See minetest's documentation for `list[]` for more information.
--luacheck: push no max comment line length
---@field starting_item_index? number (Default `0`) Zero-based offset index for this list. [See minetest's documentation for `list[]`][list] for more information.
--luacheck: pop

---@package
---@alias flow.widgets.List fun(fields: flow.widgets.List_fields): FlowTree

---@package
---@class flow.widgets.VBox_fields:flow.widget_fields
---@field spacing? number
---@field align_v? string

---@package
---@alias flow.widgets.VBox fun(fields: flow.widgets.VBox_fields): FlowTree

---@package
---@class flow.widgets.HBox_fields:flow.widget_fields
---@field spacing? number
---@field align_h? string

---@package
---@alias flow.widgets.HBox fun(fields: flow.widgets.HBox_fields): FlowTree

---@package
---@class flow.widgets.Stack_fields:flow.widget_fields

---@package
---@alias flow.widgets.Stack fun(fields: flow.widgets.Stack_fields): FlowTree

---@package
---@class flow.widgets.Spacer_fields:flow.widget_fields
---@field w number
---@field h number
---@field expand boolean

---@package
---@alias flow.widgets.Spacer fun(fields: flow.widgets.Spacer_fields): FlowTree

---@package
---@class flow.widgets.Image_fields:flow.widget_fields
---@field w number
---@field h number
---@field texture_name string

---@package
---@alias flow.widgets.Image fun(fields: flow.widgets.Image_fields): FlowTree

---@package
---@class flow.widgets.Label_fields:flow.widget_fields
---@field label string

---@package
---@alias flow.widgets.Label fun(fields: flow.widgets.Label_fields): FlowTree

---@package
---@class flow.widgets.Button_fields:flow.widgets.Label_fields

---@package
---@alias flow.widgets.Button fun(fields: flow.widgets.Button_fields): FlowTree

---@package
---@alias flow.widgets.Nil fun(fields: flow.widget_fields): FlowTree

---@package
---@alias flow.widgets.Box flow.widgets.Nil

---@package
---@class flow.widgets
---@field flow.widget_fields flow.widget_fields
---@field List_fields flow.widgets.List_fields
---@field List flow.widgets.List
---@field Listring_fields flow.widgets.Listring_fields
---@field Listring flow.widgets.Listring
---@field VBox_fields flow.widgets.VBox_fields
---@field VBox flow.widgets.VBox
---@field HBox_fields flow.widgets.HBox_fields
---@field HBox flow.widgets.HBox
---@field Stack_fields flow.widgets.Stack_fields
---@field Stack flow.widgets.Stack
---@field Spacer_fields flow.widgets.Spacer_fields
---@field Spacer flow.widgets.Spacer
---@field Image_fields flow.widgets.Image_fields
---@field Image flow.widgets.Image
---@field Label_fields flow.widgets.Label_fields
---@field Label flow.widgets.Label
---@field Button_fields flow.widgets.Button_fields
---@field Button flow.widgets.Button
---@field Nil flow.widgets.Nil
---@field Box flow.widgets.Box

---@package
---@class flow.Flow
---@field show fun(self: flow.Flow, p:minetest.Player)

---@package
---@generic X:table
---@class flow
---@field get_context nil|fun(): `X`
---@field widgets flow.widgets
---@field make_gui fun():flow.Flow
---@module '../../flow/init.lua'
--luacheck: push ignore flow
--local flow = _G.flow --[[@as flow]]
--luacheck: pop

---A collection of unofficial widgets for flow
---@see flow
---@class flow_extras
local flow_extras = {}
_G.flow_extras = flow_extras

local modpath = minetest.get_modpath"flow_extras"

---@module "./tools/search.lua"
dofile(modpath .. "/tools/search.lua")

---@module "./tools/context.lua"
dofile(modpath .. "/tools/context.lua")

---@module "./tools/tables.lua"
dofile(modpath .. "/tools/tables.lua")

---@module "./widgets/grid.lua"
dofile(modpath .. "/widgets/grid.lua")

---@module "./widgets/list.lua"
dofile(modpath .. "/widgets/list.lua")

---@module "./demo/init.lua"
--dofile(modpath .. "/demo/init.lua")
