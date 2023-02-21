local Memory = require("memory").Memory
local CPU = require("cpu").CPU
local instructions = require("instruction")

local Instruction = instructions.Instruction
local getOpcodeAndFuncsForMnemonic = instructions.getOpcodeAndFuncsForMnemonic

local opcode, funct3, funct7 = getOpcodeAndFuncsForMnemonic("lhu")

describe("lhu", function()
    local memory
    local cpu
    local instructionData

    before_each(function()
        memory = Memory.new(0x100)
        cpu = CPU.new()
        instructionData = {
            opcode = opcode,
            funct3 = funct3,
            funct7 = funct7,
        }
    end)

    describe("loads a halfword at address stored in rs1 into rd", function()
        it("(no offset)", function()
            memory:writeByte(0x00, 0x12)
            memory:writeByte(0x01, 0x34)
            memory:writeByte(0x02, 0x56)
            memory:writeByte(0x03, 0x78)
            instructionData.rd = 1
            instructionData.rs1 = 0
            instructionData.imm = 0
            local inst = Instruction.new(instructionData)

            inst:exec(cpu, memory)

            assert.are.equal(0x3412, cpu.registers[1])
        end)

        it("(no offset, zero-extends negative)", function()
            memory:writeByte(0x00, 0xFF)
            memory:writeByte(0x01, 0xFF)
            instructionData.rd = 1
            instructionData.rs1 = 0
            instructionData.imm = 0
            local inst = Instruction.new(instructionData)

            inst:exec(cpu, memory)

            assert.are.equal(0xFFFF, cpu.registers[1])
        end)

        it("(offset = 1)", function()
            memory:writeByte(0x00, 0x12)
            memory:writeByte(0x01, 0x34)
            memory:writeByte(0x02, 0x56)
            memory:writeByte(0x03, 0x78)
            instructionData.rd = 1
            instructionData.rs1 = 0
            instructionData.imm = 1
            local inst = Instruction.new(instructionData)

            inst:exec(cpu, memory)

            assert.are.equal(0x5634, cpu.registers[1])
        end)

        it("(offset = -1)", function()
            cpu.registers[1] = 2
            memory:writeByte(0x00, 0x12)
            memory:writeByte(0x01, 0x34)
            memory:writeByte(0x02, 0x56)
            memory:writeByte(0x03, 0x78)
            instructionData.rd = 1
            instructionData.rs1 = 1
            instructionData.imm = 0xFFF -- -1i12
            local inst = Instruction.new(instructionData)

            inst:exec(cpu, memory)

            assert.are.equal(0x5634, cpu.registers[1])
        end)
    end)
end)
