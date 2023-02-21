local CPU = require("cpu").CPU
local instructions = require("instruction")

local Instruction = instructions.Instruction
local getOpcodeAndFuncsForMnemonic = instructions.getOpcodeAndFuncsForMnemonic

local opcode, funct3, funct7 = getOpcodeAndFuncsForMnemonic("jalr")

describe("jalr", function()
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

    it("adds rs1+imm to PC and stores current PC + 4 to rd", function()
        cpu.registers.pc = 1
        cpu.registers[2] = 0x10
        instructionData.rd = 1
        instructionData.rs1 = 2
        instructionData.imm = 0x10
        local inst = Instruction.new(instructionData)

        inst:exec(cpu)

        assert.are.equal(0x21, cpu.registers.pc)
        assert.are.equal(0x5, cpu.registers[1])
    end)

    it("adds rs1+imm to PC and stores current PC + 4 to rd (negative offset)", function()
        cpu.registers.pc = 0x50
        cpu.registers[2] = 0xFFFFFFF0  -- -0x10i32
        instructionData.rd = 1
        instructionData.rs1 = 2
        instructionData.imm = 0x1FF0  -- -0x10i12
        local inst = Instruction.new(instructionData)

        inst:exec(cpu)

        assert.are.equal(0x30, cpu.registers.pc)
        assert.are.equal(0x54, cpu.registers[1])
    end)

    it("just adds rs1+imm to PC if rd is x0", function()
        cpu.registers.pc = 0
        cpu.registers[2] = 0x10
        instructionData.rd = 0
        instructionData.rs1 = 2
        instructionData.imm = 0x10
        local inst = Instruction.new(instructionData)

        inst:exec(cpu)

        assert.are.equal(0x20, cpu.registers.pc)
        assert.are.equal(0, cpu.registers[0])
    end)
end)
