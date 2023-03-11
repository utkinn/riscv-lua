local System = require("risc_v_system").System

describe("System", function()
    it("can be created with specified RAM size", function()
        local sys = System.new {
            memorySize = 100
        }

        assert.are.equal(100, sys.memory:size())
    end)

    it("can load data into memory", function()
        local sys = System.new {
            memorySize = 100
        }

        sys:load(0, "hello")
        assert.are.equal("hello", sys.memory:read(0, 5))
    end)

    it("can run a simple program", function()
        local sys = System.new {
            memorySize = 100
        }

        -- addi x1, x0, 10
        -- addi x1, x1, -5
        sys:load(0, string.char(0x93, 0x00, 0xa0, 0x00, 0x93, 0x80, 0xb0, 0xff))

        sys:runTicks(1)
        assert.are.equal(10, sys.cpu.registers[1])
        sys:runTicks(1)
        assert.are.equal(5, sys.cpu.registers[1])
    end)
end)
