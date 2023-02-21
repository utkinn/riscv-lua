local CPU = require("cpu").CPU
local instructions = require("instruction")

local Instruction = instructions.Instruction
local getOpcodeAndFuncsForMnemonic = instructions.getOpcodeAndFuncsForMnemonic

local opcode, funct3, funct7 = getOpcodeAndFuncsForMnemonic("auipc")

describe("auipc", function()
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

    it("stores PC + (imm << 12) to rd", function()
        cpu.registers.pc = 0x100
        instructionData.rd = 1
        instructionData.imm = 1
        local inst = Instruction.new(instructionData)

        inst:exec(cpu)

        assert.are.equal(0x1100, cpu.registers[1])
    end)
end)
