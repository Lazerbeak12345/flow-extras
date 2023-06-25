dofile"init.lua"
local flow_extras, describe, it, assert = flow_extras, describe, it, assert
describe("*basics*", function ()
	it("doesn't error out when loading init.lua", function ()
		assert(true, "by the time it got here it would have failed if it didn't work")
	end)
	it("provides a global variable for it's api to go into", function ()
		assert.are.equal("table", type(flow_extras), "flow_extras")
	end)
end)
