local Memory = require("memory").Memory
local CPU = require("cpu").CPU
local instructions = require("instruction")

local Instruction = instructions.Instruction
local getOpcodeAndFuncsForMnemonic = instructions.getOpcodeAndFuncsForMnemonic

local opcode, funct3, funct7 = getOpcodeAndFuncsForMnemonic("lw")

describe("lw", function()
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

    describe("loads a word at address stored in rs1 into rd", function()
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

            assert.are.equal(0x78563412, cpu.registers[1])
        end)

        it("(offset = 1)", function()
            memory:writeByte(0x00, 0x12)
            memory:writeByte(0x01, 0x34)
            memory:writeByte(0x02, 0x56)
            memory:writeByte(0x03, 0x78)
            memory:writeByte(0x04, 0x9A)
            memory:writeByte(0x05, 0xBC)
            memory:writeByte(0x06, 0xDE)
            memory:writeByte(0x07, 0xF0)
            instructionData.rd = 1
            instructionData.rs1 = 0
            instructionData.imm = 1
            local inst = Instruction.new(instructionData)

            inst:exec(cpu, memory)

            assert.are.equal(0x9A785634, cpu.registers[1])
        end)

        it("(offset = -1)", function()
            cpu.registers[1] = 1
            memory:writeByte(0x00, 0x12)
            memory:writeByte(0x01, 0x34)
            memory:writeByte(0x02, 0x56)
            memory:writeByte(0x03, 0x78)
            memory:writeByte(0x04, 0x9A)
            memory:writeByte(0x05, 0xBC)
            memory:writeByte(0x06, 0xDE)
            memory:writeByte(0x07, 0xF0)
            instructionData.rd = 1
            instructionData.rs1 = 1
            instructionData.imm = 0xFFF -- -1i12
            local inst = Instruction.new(instructionData)

            inst:exec(cpu, memory)

            assert.are.equal(0x78563412, cpu.registers[1])
        end)
    end)
end)
