local CPU = require("cpu").CPU
local instructions = require("instruction")

local Instruction = instructions.Instruction
local getOpcodeAndFunc3ForMnemonic = instructions.getOpcodeAndFunc3ForMnemonic

describe("Instruction", function()
    describe(":exec(cpu, memory)", function()
        describe("Arithmetic with registers", function()
            describe("add", function()
                it("regular", function()
                    local cpu = CPU.new()
                    cpu.registers[1] = 1
                    cpu.registers[2] = 2
                    local opcode, funct3 = getOpcodeAndFunc3ForMnemonic("add")
                    local inst = Instruction.new {
                        opcode = opcode,
                        funct3 = funct3,
                        rd = 1,
                        rs1 = 1,
                        rs2 = 2,
                        funct7 = 0
                    }
                    inst:exec(cpu, nil)

                    assert.are.equal(3, cpu.registers[1])
                end)

                it("with x0", function()
                    local cpu = CPU.new()
                    cpu.registers[1] = 0
                    cpu.registers[2] = 1
                    local opcode, funct3 = getOpcodeAndFunc3ForMnemonic("add")
                    local inst = Instruction.new {
                        opcode = opcode,
                        funct3 = funct3,
                        rd = 1,
                        rs1 = 2,
                        rs2 = 0,
                        funct7 = 0
                    }
                    inst:exec(cpu, nil)

                    assert.are.equal(1, cpu.registers[1])
                end)

                it("no-op if rd is x0", function()
                    local cpu = CPU.new()
                    cpu.registers[1] = 1
                    local opcode, funct3 = getOpcodeAndFunc3ForMnemonic("add")
                    local inst = Instruction.new {
                        opcode = opcode,
                        funct3 = funct3,
                        rd = 0,
                        rs1 = 1,
                        rs2 = 1,
                        funct7 = 0
                    }
                    inst:exec(cpu, nil)

                    assert.are.equal(0, cpu.registers[0])
                end)

                it("with overflow", function()
                    local cpu = CPU.new()
                    cpu.registers[1] = 0xFFFFFFFF
                    cpu.registers[2] = 1
                    local opcode, funct3 = getOpcodeAndFunc3ForMnemonic("add")
                    local inst = Instruction.new {
                        opcode = opcode,
                        funct3 = funct3,
                        rd = 1,
                        rs1 = 1,
                        rs2 = 2,
                        funct7 = 0
                    }
                    inst:exec(cpu, nil)

                    assert.are.equal(0, cpu.registers[1])
                end)
            end)
        end)
    end)
end)
