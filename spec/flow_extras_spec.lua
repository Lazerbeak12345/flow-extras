dofile"init.lua"
local describe, it = describe, it
it("doesn't error out when loading init.lua", function ()
	assert(true, "by the time it got here it would have failed if it didn't work")
end)
