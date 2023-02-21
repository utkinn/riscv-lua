local CPU = require("cpu").CPU
local instructions = require("instruction")

local Instruction = instructions.Instruction
local getOpcodeAndFuncsForMnemonic = instructions.getOpcodeAndFuncsForMnemonic

local opcode, funct3, funct7 = getOpcodeAndFuncsForMnemonic("lui")

describe("lui", function()
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

    it("stores imm << 12 to rd", function()
        instructionData.rd = 1
        instructionData.imm = 1
        local inst = Instruction.new(instructionData)

        inst:exec(cpu)

        assert.are.equal(0x1000, cpu.registers[1])
    end)
end)
