local Memory = require("memory").Memory
local CPU = require("cpu").CPU
local instructions = require("instruction")

local Instruction = instructions.Instruction
local getOpcodeAndFuncsForMnemonic = instructions.getOpcodeAndFuncsForMnemonic

local opcode, funct3, funct7 = getOpcodeAndFuncsForMnemonic("sw")

describe("sw", function()
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

    describe("stores a word in rs2 to address rs1+imm", function()
        it("(no offset)", function()
            cpu.registers[1] = 0x12345678
            instructionData.rs2 = 1
            instructionData.rs1 = 0
            instructionData.imm = 0
            local inst = Instruction.new(instructionData)

            inst:exec(cpu, memory)

            assert.are.equal(0x12345678, memory:readWord(0x0))
        end)

        it("(offset = 1)", function()
            cpu.registers[1] = 0x12345678
            instructionData.rs2 = 1
            instructionData.rs1 = 0
            instructionData.imm = 1
            local inst = Instruction.new(instructionData)

            inst:exec(cpu, memory)

            assert.are.equal(0x12345678, memory:readWord(0x1))
        end)

        it("(offset = -1)", function()
            cpu.registers[1] = 0x12345678
            cpu.registers[2] = 0x1
            instructionData.rs2 = 1
            instructionData.rs1 = 2
            instructionData.imm = 0xFFF
            local inst = Instruction.new(instructionData)

            inst:exec(cpu, memory)

            assert.are.equal(0x12345678, memory:readWord(0x0))
        end)
    end)
end)
