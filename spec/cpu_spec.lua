local CPU = require("cpu").CPU
local Memory = require("memory").Memory

describe("CPU", function()
    it("has 31 modifiable registers + 1 program counter", function()
        local cpu = CPU.new()

        for i = 1, 31 do
            assert.are.equal(0, cpu.registers[i],
                "Register " .. i .. " is not 0 but " .. tostring(cpu.registers[i]) .. " instead")
        end
        assert.are.equal(0, cpu.registers.pc)
    end)

    describe(":writeReg(n, val)", function()
        it("writes to register n", function()
            local cpu = CPU.new()
            cpu:writeReg(1, 1)

            assert.are.equal(1, cpu.registers[1])
        end)

        it("trims val to 32 bits", function()
            local cpu = CPU.new()
            cpu:writeReg(1, 0xFFFFFFFF + 1)

            assert.are.equal(0, cpu.registers[1])
        end)

        it("discards writes to 0", function()
            local cpu = CPU.new()
            cpu:writeReg(0, 1)

            assert.are.equal(0, cpu.registers[0])
        end)
    end)

    it("has a :tick() method which accepts a Memory instance and executes a single instruction at PC", function()
        local cpu = CPU.new()
        local memory = Memory.new(100)
        memory:writeWord(0, 0xa00093)

        cpu:tick(memory)

        assert.are.equal(10, cpu.registers[1])
        assert.are.equal(4, cpu.registers.pc)
    end)
end)
