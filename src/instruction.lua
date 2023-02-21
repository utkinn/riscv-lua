local mod = {}

mod.Instruction = {}

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
            rs1 = (instruction >> 15) & 0x1F,
            imm = instruction >> 20
        }
    end,
    S = function(opcode, instruction)
        local imm1 = instruction >> 7 & 0x1F
        local imm2 = instruction >> 25
        return {
            opcode = opcode,
            imm = imm1 | (imm2 << 5),
            funct3 = instruction >> 12 & 0x7,
            rs1 = (instruction >> 15) & 0x1F,
            rs2 = (instruction >> 20) & 0x1F
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
            rs1 = (instruction >> 15) & 0x1F,
            rs2 = (instruction >> 20) & 0x1F
        }
    end,
    U = function(opcode, instruction)
        return {
            opcode = opcode,
            rd = instruction >> 7 & 0x1F,
            imm = instruction & 0xfffff000
        }
    end,
    J = function (opcode, instruction)
        local imm19_12 = instruction >> 12 & 0xff
        local imm11 = instruction >> 20 & 0x1
        local imm10_1 = instruction >> 21 & 0x3ff
        local imm20 = instruction >> 31
        return {
            opcode = opcode,
            rd = instruction >> 7 & 0x1F,
            imm = imm19_12 << 12 | imm11 << 11 | imm10_1 << 1 | imm20 << 20
        }
    end
}

--- Parse an instruction from a number.
-- @return An Instruction instance, or nil if the instruction is illegal.
function mod.Instruction.new(instruction)
    local opcode = instruction & 0x7F
    local format = INSTRUCTION_FORMATS[opcode]
    local parser = FORMAT_PARSERS[format]
    if parser then
        return parser(opcode, instruction)
    end
end

return mod
