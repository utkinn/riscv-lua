local CPU = require("cpu").CPU
local instructions = require("instruction")

local Instruction = instructions.Instruction
local getOpcodeAndFuncsForMnemonic = instructions.getOpcodeAndFuncsForMnemonic

local opcode, funct3, funct7 = getOpcodeAndFuncsForMnemonic("srai")

describe("srai", function()
    local cpu
    local instructionData

    before_each(function()
        cpu = CPU.new()
        instructionData = {
            opcode = opcode,
            funct3 = funct3,
            funct7 = funct7,
        }
    end)

    it("like srli, but keeps MSB", function()
        cpu.registers[1] = tonumber("10000000000000000000000000000001", 2)
        instructionData.rd = 1
        instructionData.rs1 = 1
        instructionData.imm = 1
        local inst = Instruction.new(instructionData)

        inst:exec(cpu)

        assert.are.equal(tonumber("11000000000000000000000000000000", 2), cpu.registers[1])
    end)

    it("no-op if rd is x0", function()
        cpu.registers[1] = 1
        instructionData.rd = 0
        instructionData.rs1 = 1
        instructionData.imm = 1
        local inst = Instruction.new(instructionData)

        inst:exec(cpu)

        assert.are.equal(0, cpu.registers[0])
    end)
end)
