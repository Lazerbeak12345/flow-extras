--luacheck: std luacheckrc
---@package
---@class globals:any
globals = {
    'formspec_ast',
    'flow',
    'flow_extras'
}

--read_globals = {
--    string = {fields = {'split', 'trim'}},
--    table = {fields = {'copy', 'indexof'}}
--}

-- This error is thrown for methods that don't use the implicit "self"
-- parameter.
--ignore = {"212/self", "432/player", "43/ctx", "212/player", "212/ctx", "212/value"}

---@package
---@class std:any
std = 'lua52+minetest'
