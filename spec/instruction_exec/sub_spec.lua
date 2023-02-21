local CPU = require("cpu").CPU
local instructions = require("instruction")

local Instruction = instructions.Instruction
local getOpcodeAndFuncsForMnemonic = instructions.getOpcodeAndFuncsForMnemonic

local opcode, funct3, funct7 = getOpcodeAndFuncsForMnemonic("sub")

describe("sub", function()
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
        cpu.registers[1] = 3
        cpu.registers[2] = 2
        instructionData.rd = 1
        instructionData.rs1 = 1
        instructionData.rs2 = 2
        local inst = Instruction.new(instructionData)

        inst:exec(cpu)

        assert.are.equal(1, cpu.registers[1])
    end)

    it("with x0", function()
        cpu.registers[1] = 0
        cpu.registers[2] = 1
        instructionData.rd = 1
        instructionData.rs1 = 2
        instructionData.rs2 = 0
        local inst = Instruction.new(instructionData)

        inst:exec(cpu)

        assert.are.equal(1, cpu.registers[1])
    end)

    it("no-op if rd is x0", function()
        cpu.registers[1] = 1
        instructionData.rd = 0
        instructionData.rs1 = 1
        instructionData.rs2 = 1
        local inst = Instruction.new(instructionData)

        inst:exec(cpu)

        assert.are.equal(0, cpu.registers[0])
    end)

    it("with underflow", function()
        cpu.registers[1] = 0
        cpu.registers[2] = 1
        instructionData.rd = 1
        instructionData.rs1 = 1
        instructionData.rs2 = 2
        local inst = Instruction.new(instructionData)

        inst:exec(cpu)

        assert.are.equal(0xFFFFFFFF, cpu.registers[1])
    end)

    it("negative result", function()
        cpu.registers[1] = 0
        cpu.registers[2] = 1
        cpu.registers[3] = 2
        instructionData.rd = 1
        instructionData.rs1 = 2
        instructionData.rs2 = 3
        local inst = Instruction.new(instructionData)

        inst:exec(cpu)

        assert.are.equal(0xFFFFFFFF, cpu.registers[1])
    end)
end)