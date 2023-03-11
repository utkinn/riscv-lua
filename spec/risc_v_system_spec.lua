local System = require("risc_v_system").System

describe("System", function()
    it("can be created with specified RAM size", function()
        local sys = System.new {
            memorySize = 100
        }

        assert.are.equal(100, sys.memory:size())
    end)
end)
