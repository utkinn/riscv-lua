local CPU = require("cpu").CPU
local instructions = require("instruction")

local Instruction = instructions.Instruction
local getOpcodeAndFuncsForMnemonic = instructions.getOpcodeAndFuncsForMnemonic

local opcode, funct3, funct7 = getOpcodeAndFuncsForMnemonic("jal")

describe("jal", function()
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

    it("adds imm to PC and stores current PC + 4 to rd", function()
        cpu.registers.pc = 1
        instructionData.rd = 1
        instructionData.imm = 0x10
        local inst = Instruction.new(instructionData)

        inst:exec(cpu)

        assert.are.equal(0x11, cpu.registers.pc)
        assert.are.equal(0x5, cpu.registers[1])
    end)

    it("adds imm to PC and stores current PC + 4 to rd (negative offset)", function()
        cpu.registers.pc = 0x50
        instructionData.rd = 1
        instructionData.imm = 0x3FFFF0  -- -0x10
        local inst = Instruction.new(instructionData)

        inst:exec(cpu)

        assert.are.equal(0x40, cpu.registers.pc)
        assert.are.equal(0x54, cpu.registers[1])
    end)

    it("just adds imm to PC if rd is x0", function()
        cpu.registers.pc = 1
        instructionData.rd = 0
        instructionData.imm = 0x10
        local inst = Instruction.new(instructionData)

        inst:exec(cpu)

        assert.are.equal(0x11, cpu.registers.pc)
        assert.are.equal(0, cpu.registers[0])
    end)
end)