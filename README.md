# Flow Extras

[![ContentDB](https://content.minetest.net/packages/lazerbeak12345/flow_extras/shields/downloads/)](https://content.minetest.net/packages/lazerbeak12345/flow_extras/)
[![Minetest Forums](https://img.shields.io/badge/Minetest_Forums-Flow_Extras-%234faf00?logo=minetest&labelColor=%23161616)](https://forum.minetest.net/viewtopic.php?t=29766)
[![busted](https://github.com/Lazerbeak12345/flow-extras/actions/workflows/busted.yml/badge.svg)](https://github.com/Lazerbeak12345/flow-extras/actions/workflows/busted.yml)
[![luacheck](https://github.com/Lazerbeak12345/flow-extras/actions/workflows/luacheck.yml/badge.svg)](https://github.com/Lazerbeak12345/flow-extras/actions/workflows/luacheck.yml)
[![Coverage Status](https://coveralls.io/repos/github/Lazerbeak12345/flow-extras/badge.svg?branch=master)](https://coveralls.io/github/Lazerbeak12345/flow-extras?branch=master)
[![versioned: semantically](https://img.shields.io/badge/versioned-semantically-orange)](https://semver.org)
![image badge containing latest version number](https://img.shields.io/github/v/tag/Lazerbeak12345/flow-extras?filter=*.*.*&label=latest%20version)

An experimental collection of extra widgets for [flow].

> Not officially associated with flow

[flow]: https://github.com/luk3yx/minetest-flow

## Docs

### Widgets

#### Grid

> TODO:

#### List

```lua
flow_extras.List{
	inventory_location = inventory_location,
	list_name = list_name,
	w = w,
	h = h,
	starting_item_index = starting_item_index,
	remainder = remainder ,
	remainder_v = remainder_v ,
	remainder_align = remainder_align,
	listring = listring,
	bgimg = bgimg,
	align_h = align_h,
	align_v = align_v,
	spacing = spacing
}
```

> TODO: link these

| Parameter | Type | Description |
| :-------- | :--- | :---------- |
| `inventory_location` | `string` | **Required**. [See minetest's documentation for `list[]`][list] for more information. |
| `list_name` | `string` | **Required**. [See minetest's documentation for `list[]`][list] for more information. |
| `w` | `number` | **Required**. Width of list in tiles. [See minetest's documentation for `list[]`][list] for more information. |
| `h` | `number` | **Required**. Height of list in tiles. [See minetest's documentation for `list[]`][list] for more information. |
| `starting_item_index` | `number` | **Optional**. (Default `0`) Zero-based offset index for this list. [See minetest's documentation for `list[]`][list] for more information. |
| `remainder` | `number` | **Optional**. (Default `0`) If you'd like a row of list tiles that is less than one demention of the rest of the list, set this to a number > 0. |
| `remainder_v` | `boolean` | **Optional**. (Default `false`) If `true`, the remainder will be below the rest of the [`list[]`][list]. Otherwise, it is to the right. |
| `remainder_align` | `string` | **Optional**. Passed into `align_v` on a [`flow.widgets.VBox`][gui.VBox] if `remainder_v` or `align_h` on a [`flow.widgets.HBox`][gui.HBox] to align the remainder list. |
| `listring` | `table` | **Optional**. A list of tables each passed to `flow.widgets.Listring`. Prepended with this `list[]`'s location and name, if provided. If not provided, [`listring[]`][listring]s are not generated. |
| `bgimg` | `boolean` or `string` or `table` of `string`s | **Optional**. If present, applies each image in order, looping from left to right, top to bottom, on each list tile in the main list, followed by the remainder list, in the same pattern. By default, since `list[]` elements are opaque, you will not be able to see these images. Make use of [`flow.widgets.Listcolors`][listcolors] to adjust this as needed. If `bgimg` is `false`, then no `bgimg`s are rendered. If it is `nil`, it defaults to `{ "flow_extras_list_bg.png" }`. If it is a string, it is wrapped in a table. |
| `align_h` | `string` | **Optional**. If there is a remainder or a listring, this is passed to the the [`flow.widgets.VBox`][gui.VBox] if `remainder_v` or [`flow.widgets.Hbox`][gui.HBox] that wraps the entire element. Otherwise, this element does not exist, and either a [`flow.widgets.Stack`][gui.Stack] or a [`flow.widgets.List`][List] is the root. |
| `align_v` | `string` | **Optional**. If there is a remainder or a listring, this is passed to the the [`flow.widgets.VBox`][gui.VBox] if `remainder_v` or [`flow.widgets.Hbox`][gui.HBox] that wraps the entire element. Otherwise, this element does not exist, and either a [`flow.widgets.Stack`][gui.Stack] or a [`flow.widgets.List`][List] is the root. |
| `spacing` | `number` | **Optional**. The amount of space between the list tiles. Defaults to `0.25` - the same amount as minetest out of the box. |

[list]: https://github.com/minetest/minetest/blob/master/doc/lua_api.md#listinventory-locationlist-namexywhstarting-item-index
[listring]: https://github.com/minetest/minetest/blob/master/doc/lua_api.md#listringinventory-locationlist-name
[gui.List]: https://gitlab.com/luk3yx/minetest-flow/-/blob/main/elements.md?ref_type=heads#guilist
[gui.HBox]: https://gitlab.com/luk3yx/minetest-flow#guihbox
[gui.VBox]: https://gitlab.com/luk3yx/minetest-flow#guivbox
[gui.Stack]: https://gitlab.com/luk3yx/minetest-flow#guistack
[listcolors]: https://github.com/minetest/minetest/blob/master/doc/lua_api.md#listcolorsslot_bg_normalslot_bg_hover

### Tools

> TODO:

### Textures

- `flow_extras_list_bg.png` is the default background for all list slots rendered by `flow_extras.List`
- `flow_extras_list_inactive.png` is availiable for use in situations (like craft recepies) where you need a deactivated "List".

## Rules

I've seen a lot of libraries like Qt and GTK accumulate hundreds of widgets over the years. I'd like to slow that process down here.

> The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL
> NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED",  "MAY", and
> "OPTIONAL" in this document are to be interpreted as described in
> [RFC 2119](https://datatracker.ietf.org/doc/html/rfc2119).

1. Widgets MUST NOT require any specific game or mod, except for `flow` or `formspec_ast`.
2. Widgets SHOULD NOT be a part of Flow. If a widget is added to Flow after it has been included in Flow-Extras, this widget SHOULD be deprecated.
3. Widgets MUST fulfill an existing need, shown by at least two projects.
4. Widgets MUST be themable wherever reasonably possible using conventional methods.
5. Widgets SHOULD encourage the buisness logic to be seperate, and the form generation logic to be inline.
6. Widgets SHOULD maximise reuse through generalization.
7. Widgets MAY allow for children widgets using the standard convention set in Flow
8. Widgets MAY use widgets not yet supported by flow, provided that
   1. it MUST use a "fake" form of the widget by default. However it MAY provide a way to use the unsupported widget
   2. MUST document use of unsupported widgets
9. Widgets MAY use widgets not supported by older versions of the Minetest Client, provided this MUST be documented, and that the widget is supported by FS51 or simmilar libraries. If the widget is not supported by such a library, then the widget MUST follow reccomendations in rule 8.1

## TODO

- [ ] `Navabble`
    - [ ] Accepts a table of callbacks, each returning window contents
    - [ ] requires a name
- [ ] `FakeTabbar`
    - [ ] A fake tabbar with identical API
- [ ] `Pagnator`
    - [ ] A pagnator widget for use with `Navabble`
    - [ ] Custom message text supported (with translation as well, ofc)
- [ ] Reactive Boxes
    - [ ] reacts to width of client, if availiable.
    - [ ] behave like breakpoints from the CSS library Bootstrap
- [ ] Each type of for loop as a map-like function
- [ ] `{Widget,table}[][] -> WidgetArgs[]`
- [ ] Integrate with `flow_inspector`

## Legal

### Code

See `./LICENSE`

### Media

#### Images

- `flow_extras_list_bg.png`: renamed from `gui_hb_bg.png`, a texture by BlockMen (CC BY-SA 3.0)
