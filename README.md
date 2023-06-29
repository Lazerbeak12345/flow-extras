# Flow Extras

[![ContentDB](https://content.minetest.net/packages/lazerbeak12345/flow_extras/shields/downloads/)](https://content.minetest.net/packages/lazerbeak12345/flow_extras/)

An experimental collection of extra widgets for [flow].

> Not officially associated with flow

[flow]: https://github.com/luk3yx/minetest-flow
## Rules

I've seen a lot of libraries like Qt and GTK accumulate hundreds of widgets over the years. I'd like to slow that process down here.

> The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL
> NOT", "SHOULD", "SHOULD NOT", "RECOMMENDED",  "MAY", and
> "OPTIONAL" in this document are to be interpreted as described in
> [RFC 2119](https://datatracker.ietf.org/doc/html/rfc2119).

1. Widgets MUST NOT require any specific game or mod, except for `flow`.
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

## Legal

### Code

See `./LICENSE`

### Media

#### Images

- `flow_extras_list_bg.png`: renamed from `gui_hb_bg.png`, a texture by BlockMen (CC BY-SA 3.0)
