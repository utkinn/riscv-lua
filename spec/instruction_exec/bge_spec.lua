local CPU = require("cpu").CPU
local instructions = require("instruction")

local Instruction = instructions.Instruction
local getOpcodeAndFuncsForMnemonic = instructions.getOpcodeAndFuncsForMnemonic

local opcode, funct3, funct7 = getOpcodeAndFuncsForMnemonic("bge")

describe("bge", function()
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

    it("adds imm to PC if rs1 >= rs2 (both positive)", function()
        cpu.registers.pc = 1
        cpu.registers[1] = 0x1234
        cpu.registers[2] = 0x1234
        instructionData.rs1 = 1
        instructionData.rs2 = 2
        instructionData.imm = 0x10
        local inst = Instruction.new(instructionData)

        inst:exec(cpu)

        assert.are.equal(0x11, cpu.registers.pc)
    end)
    
    it("adds imm to PC if rs1 >= rs2 (rs1 < 0, rs2 > 0)", function()
        cpu.registers.pc = 1
        cpu.registers[1] = 1
        cpu.registers[2] = 0xFFFFFFFF
        instructionData.rs1 = 1
        instructionData.rs2 = 2
        instructionData.imm = 0x10
        local inst = Instruction.new(instructionData)

        inst:exec(cpu)

        assert.are.equal(0x11, cpu.registers.pc)
    end)

    it("adds imm to PC if rs1 >= rs2 (both negative)", function()
        cpu.registers.pc = 1
        cpu.registers[1] = 0xFFFFFFFF
        cpu.registers[2] = 0xFFFFFFFC
        instructionData.rs1 = 1
        instructionData.rs2 = 2
        instructionData.imm = 0x10
        local inst = Instruction.new(instructionData)

        inst:exec(cpu)

        assert.are.equal(0x11, cpu.registers.pc)
    end)

    it("adds imm to PC if rs1 >= rs2 (negative offset)", function()
        cpu.registers.pc = 0x10
        cpu.registers[1] = 0x1234
        cpu.registers[2] = 0x1234
        instructionData.rs1 = 1
        instructionData.rs2 = 2
        instructionData.imm = 0x3FFF
        local inst = Instruction.new(instructionData)

        inst:exec(cpu)

        assert.are.equal(0xF, cpu.registers.pc)
    end)

    it("does not add imm to PC if rs1 < rs2", function()
        cpu.registers.pc = 1
        cpu.registers[1] = 0x1233
        cpu.registers[2] = 0x1234
        instructionData.rs1 = 1
        instructionData.rs2 = 2
        instructionData.imm = 0x10
        local inst = Instruction.new(instructionData)

        inst:exec(cpu)

        assert.are.equal(1, cpu.registers.pc)
    end)
end)
