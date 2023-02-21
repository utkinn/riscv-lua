local CPU = require("cpu").CPU
local instructions = require("instruction")

local Instruction = instructions.Instruction
local getOpcodeAndFuncsForMnemonic = instructions.getOpcodeAndFuncsForMnemonic

local opcode, funct3, funct7 = getOpcodeAndFuncsForMnemonic("or")

describe("or", function()
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

    it("regular", function()
        cpu.registers[1] = tonumber("101", 2)
        cpu.registers[2] = tonumber("110", 2)
        instructionData.rd = 1
        instructionData.rs1 = 1
        instructionData.rs2 = 2
        local inst = Instruction.new(instructionData)

        inst:exec(cpu)

        assert.are.equal(tonumber("111", 2), cpu.registers[1])
    end)

    it("with x0", function()
        cpu.registers[1] = tonumber("101", 2)
        instructionData.rd = 1
        instructionData.rs1 = 1
        instructionData.rs2 = 0
        local inst = Instruction.new(instructionData)

        inst:exec(cpu)

        assert.are.equal(tonumber("101", 2), cpu.registers[1])
    end)

    it("no-op if rd is x0", function()
        cpu.registers[1] = 2
        cpu.registers[2] = 3
        instructionData.rd = 0
        instructionData.rs1 = 1
        instructionData.rs2 = 2
        local inst = Instruction.new(instructionData)

        inst:exec(cpu)

        assert.are.equal(0, cpu.registers[0])
    end)
end)
