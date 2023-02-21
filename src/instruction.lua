local numberUtils = require("numberUtils")

local mod = {}

mod.Instruction = {}

local Opcode = {
    ARITHMETIC_WITH_REGISTERS = 0x33,
    ARITHMETIC_WITH_IMMEDIATES = 0x13,
    LOAD = 0x3,
    STORE = 0x23,
    BRANCH = 0x63,
    JAL = 0x6F,
    JALR = 0x2F,
    LUI = 0x37,
    AUIPC = 0x17,
    CONTROL_TRANSFER = 0x73
}

-- This table is to indexed like this:
-- INSTRUCTIONS[opcode][funct3][funct7]
local INSTRUCTIONS = {
    [Opcode.ARITHMETIC_WITH_REGISTERS] = {
        [0x0] = {
            [0x0] = {
                name = "add",
                exec = function(inst, cpu)
                    cpu:writeReg(inst.rd, (cpu.registers[inst.rs1] + cpu.registers[inst.rs2]) & 0xFFFFFFFF)
                end
            },
            [0x20] = {
                name = "sub",
                exec = function(inst, cpu)
                    cpu:writeReg(inst.rd, (cpu.registers[inst.rs1] - cpu.registers[inst.rs2]) & 0xFFFFFFFF)
                end
            }
        },
        [0x4] = {
            [0x0] = {
                name = "xor",
                exec = function(inst, cpu)
                    cpu:writeReg(inst.rd, (cpu.registers[inst.rs1] ~ cpu.registers[inst.rs2]) & 0xFFFFFFFF)
                end
            }
        },
        [0x6] = {
            [0x0] = {
                name = "or",
                exec = function(inst, cpu)
                    cpu:writeReg(inst.rd, (cpu.registers[inst.rs1] | cpu.registers[inst.rs2]) & 0xFFFFFFFF)
                end
            }
        },
        [0x7] = {
            [0x0] = {
                name = "and",
                exec = function(inst, cpu)
                    cpu:writeReg(inst.rd, (cpu.registers[inst.rs1] & cpu.registers[inst.rs2]) & 0xFFFFFFFF)
                end
            }
        },
        [0x1] = {
            [0x0] = {
                name = "sll",
                exec = function(inst, cpu)
                    cpu:writeReg(inst.rd, (cpu.registers[inst.rs1] << cpu.registers[inst.rs2]) & 0xFFFFFFFF)
                end
            }
        },
        [0x5] = {
            [0x0] = {
                name = "srl",
                exec = function(inst, cpu)
                    cpu:writeReg(inst.rd, (cpu.registers[inst.rs1] >> cpu.registers[inst.rs2]) & 0xFFFFFFFF)
                end
            },
            [0x20] = {
                name = "sra",
                exec = function(inst, cpu)
                    local msb = cpu.registers[inst.rs1] & 0x80000000
                    cpu:writeReg(inst.rd, ((cpu.registers[inst.rs1] >> cpu.registers[inst.rs2]) | msb) & 0xFFFFFFFF)
                end
            },
        },
        [0x2] = {
            [0x0] = {
                name = "slt",
                exec = function(inst, cpu)
                    cpu:writeReg(inst.rd, (numberUtils.i32ToI64(cpu.registers[inst.rs1]) < numberUtils.i32ToI64(cpu.registers[inst.rs2])) and 1 or 0)
                end
            }
        },
        [0x3] = {
            [0x0] = {
                name = "sltu",
                exec = function(inst, cpu)
                    cpu:writeReg(inst.rd, (cpu.registers[inst.rs1] < cpu.registers[inst.rs2]) and 1 or 0)
                end
            }
        },
    },

    [Opcode.ARITHMETIC_WITH_IMMEDIATES] = {
        [0x0] = {
            [0x0] = {
                name = "addi",
                exec = function(inst, cpu)
                    cpu:writeReg(inst.rd, (cpu.registers[inst.rs1] + inst.imm) & 0xFFFFFFFF)
                end
            }
        },
        [0x4] = {
            [0x0] = {
                name = "xori",
                exec = function(inst, cpu)
                    cpu:writeReg(inst.rd, (cpu.registers[inst.rs1] ~ inst.imm) & 0xFFFFFFFF)
                end
            }
        },
        [0x6] = {
            [0x0] = {
                name = "ori",
                exec = function(inst, cpu)
                    cpu:writeReg(inst.rd, (cpu.registers[inst.rs1] | inst.imm) & 0xFFFFFFFF)
                end
            }
        },
        [0x7] = {
            [0x0] = {
                name = "andi",
                exec = function(inst, cpu)
                    cpu:writeReg(inst.rd, (cpu.registers[inst.rs1] & inst.imm) & 0xFFFFFFFF)
                end
            }
        },
        [0x1] = {
            [0x0] = {
                name = "slli",
                exec = function(inst, cpu)
                    cpu:writeReg(inst.rd, (cpu.registers[inst.rs1] << inst.imm) & 0xFFFFFFFF)
                end
            }
        },
        [0x5] = {
            [0x0] = {
                name = "srli",
                exec = function(inst, cpu)
                    cpu:writeReg(inst.rd, (cpu.registers[inst.rs1] >> inst.imm) & 0xFFFFFFFF)
                end
            },
            [0x400] = {
                name = "srai",
                exec = function(inst, cpu)
                    local msb = cpu.registers[inst.rs1] & 0x80000000
                    cpu:writeReg(inst.rd, ((cpu.registers[inst.rs1] >> inst.imm) | msb) & 0xFFFFFFFF)
                end
            },
        },
        [0x2] = {
            [0x0] = {
                name = "slti",
                exec = function(inst, cpu)
                    cpu:writeReg(inst.rd, (numberUtils.i12ToI64(cpu.registers[inst.rs1]) < numberUtils.i12ToI64(inst.imm)) and 1 or 0)
                end
            }
        },
        [0x3] = {
            [0x0] = {
                name = "sltiu",
                exec = function(inst, cpu)
                    cpu:writeReg(inst.rd, (cpu.registers[inst.rs1] < inst.imm) and 1 or 0)
                end
            }
        },
    },

    [Opcode.LOAD] = {
        [0x0] = {
            [0x0] = {
                name = "lb",
                exec = function(inst, cpu, memory)
                    local addr = cpu.registers[inst.rs1] + numberUtils.i12ToI64(inst.imm)
                    cpu:writeReg(inst.rd, numberUtils.i8ToI64(memory:readByte(addr)))
                end
            }
        },
        [0x1] = {
            [0x0] = {
                name = "lh",
                exec = function(inst, cpu, memory)
                    local addr = cpu.registers[inst.rs1] + numberUtils.i12ToI64(inst.imm)
                    cpu:writeReg(inst.rd, numberUtils.i16ToI64(memory:readHalfWord(addr)))
                end
            }
        },
        [0x2] = {
            [0x0] = {
                name = "lw",
                exec = function(inst, cpu, memory)
                    local addr = cpu.registers[inst.rs1] + numberUtils.i12ToI64(inst.imm)
                    cpu:writeReg(inst.rd, memory:readWord(addr))
                end
            }
        },
        [0x4] = {
            [0x0] = {
                name = "lbu",
                exec = function(inst, cpu, memory)
                    local addr = cpu.registers[inst.rs1] + numberUtils.i12ToI64(inst.imm)
                    cpu:writeReg(inst.rd, memory:readByte(addr))
                end
            }
        },
        [0x5] = {
            [0x0] = {
                name = "lhu",
                exec = function(inst, cpu, memory)
                    local addr = cpu.registers[inst.rs1] + numberUtils.i12ToI64(inst.imm)
                    cpu:writeReg(inst.rd, memory:readHalfWord(addr))
                end
            }
        },
    },

    [Opcode.STORE] = {
        [0x0] = {
            [0x0] = {
                name = "sb",
                exec = function(inst, cpu, memory)
                    local addr = cpu.registers[inst.rs1] + numberUtils.i12ToI64(inst.imm)
                    memory:writeByte(addr, cpu.registers[inst.rs2] & 0xFF)
                end
            }
        },
        [0x1] = {
            [0x0] = {
                name = "sh",
                exec = function(inst, cpu, memory)
                    local addr = cpu.registers[inst.rs1] + numberUtils.i12ToI64(inst.imm)
                    memory:writeHalfWord(addr, cpu.registers[inst.rs2] & 0xFFFF)
                end
            }
        },
        [0x2] = {
            [0x0] = {
                name = "sw",
                exec = function(inst, cpu, memory)
                    local addr = cpu.registers[inst.rs1] + numberUtils.i12ToI64(inst.imm)
                    memory:writeWord(addr, cpu.registers[inst.rs2])
                end
            }
        },
    }
}

--- Returns the opcode, funct3, and funct7 for a given mnemonic.
function mod.getOpcodeAndFuncsForMnemonic(mnemonic)
    for opcode, funct3s in pairs(INSTRUCTIONS) do
        for funct3, funct7s in pairs(funct3s) do
            for funct7, instruction in pairs(funct7s) do
                if instruction.name == mnemonic then
                    return opcode, funct3, funct7
                end
            end
        end
    end
end

local INSTRUCTION_FORMATS = {
    [0x13] = "I",
    [0x23] = "S",
    [0x33] = "R",
    [0x63] = "B",
    [0x37] = "U",
    [0x6F] = "J"
}

local FORMAT_PARSERS = {
    R = function(opcode, instruction)
        return {
            opcode = opcode,
            rd = instruction >> 7 & 0x1F,
            funct3 = instruction >> 12 & 0x7,
            rs1 = (instruction >> 15) & 0x1F,
            rs2 = (instruction >> 20) & 0x1F,
            funct7 = instruction >> 25
        }
    end,
    I = function(opcode, instruction)
        return {
            opcode = opcode,
            rd = instruction >> 7 & 0x1F,
            funct3 = instruction >> 12 & 0x7,
            funct7 = 0,
            rs1 = (instruction >> 15) & 0x1F,
            imm = instruction >> 20,
        }
    end,
    S = function(opcode, instruction)
        local imm1 = instruction >> 7 & 0x1F
        local imm2 = instruction >> 25
        return {
            opcode = opcode,
            imm = imm1 | (imm2 << 5),
            funct3 = instruction >> 12 & 0x7,
            funct7 = 0,
            rs1 = (instruction >> 15) & 0x1F,
            rs2 = (instruction >> 20) & 0x1F,
        }
    end,
    B = function(opcode, instruction)
        local immBit11 = instruction >> 7 & 0x1
        local immBit4_1 = instruction >> 8 & 0xF
        local immBit10_5 = instruction >> 25 & 0x1f
        local immBit12 = instruction >> 31
        return {
            opcode = opcode,
            imm = immBit4_1 << 1 | immBit10_5 << 5 | immBit11 << 11 | immBit12 << 12,
            funct3 = instruction >> 12 & 0x7,
            funct7 = 0,
            rs1 = (instruction >> 15) & 0x1F,
            rs2 = (instruction >> 20) & 0x1F,
        }
    end,
    U = function(opcode, instruction)
        return {
            opcode = opcode,
            rd = instruction >> 7 & 0x1F,
            imm = instruction & 0xfffff000,
            funct3 = 0,
            funct7 = 0,
        }
    end,
    J = function(opcode, instruction)
        local imm19_12 = instruction >> 12 & 0xff
        local imm11 = instruction >> 20 & 0x1
        local imm10_1 = instruction >> 21 & 0x3ff
        local imm20 = instruction >> 31
        return {
            opcode = opcode,
            rd = instruction >> 7 & 0x1F,
            imm = imm19_12 << 12 | imm11 << 11 | imm10_1 << 1 | imm20 << 20,
            funct3 = 0,
            funct7 = 0,
        }
    end
}

--- Parse an instruction from a number.
-- @return An Instruction instance, or nil if the instruction is illegal.
function mod.Instruction.new(instruction)
    if type(instruction) == "number" then
        local opcode = instruction & 0x7F
        local format = INSTRUCTION_FORMATS[opcode]
        local parser = FORMAT_PARSERS[format]
        if parser then
            return setmetatable(parser(opcode, instruction), { __index = mod.Instruction })
        end
    elseif type(instruction) == "table" then
        return setmetatable(instruction, { __index = mod.Instruction })
    end
end

function mod.Instruction:exec(cpu, memory)
    local instruction = INSTRUCTIONS[self.opcode][self.funct3][self.funct7]
    if instruction then
        instruction.exec(self, cpu, memory)
    end
end

return mod
