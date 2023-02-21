local CPU = require("cpu").CPU

describe("CPU", function()
    it("has 31 modifiable registers + 1 program counter", function()
        local cpu = CPU.new()

        for i = 1, 31 do
            assert.are.equal(0, cpu.registers[i],
                "Register " .. i .. " is not 0 but " .. tostring(cpu.registers[i]) .. " instead")
        end
        assert.are.equal(0, cpu.registers.pc)
    end)

    it("executes a simplest program with just one \"ADDI x1, x1, 1\"", function()
        local cpu = CPU.new()
        local addi_x1_x1_1 = "00000000000100001000000010010011"
        local program = { tonumber(addi_x1_x1_1, 2) }

        cpu:execute(program)

        assert.are.equal(1, cpu.registers[1])
        assert.are.equal(4, cpu.registers.pc)
    end)
end)
