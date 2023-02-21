local mod = {}

mod.CPU = {}

function mod.CPU.new()
    local cpu = {
        registers = {
            pc = 0
        }
    }

    cpu.registers[0] = 0
    for i = 1, 31 do
        cpu.registers[i] = 0
    end

    return setmetatable(cpu, { __index = mod.CPU })
end

local OPCODES = {
    ADDI = 0x13
}

--- Executes a program.
-- Program is assumed to be at address 0.
-- @param program a table of 32-bit instructions encoded as numbers
function mod.CPU:execute(program)
    local pc = self.registers.pc
    local instruction = program[pc + 1]
    local opcode = instruction & 0x7F
    local rd = (instruction >> 20) & 0x1F
    local rs1 = (instruction >> 15) & 0x1F
    local rs2 = (instruction >> 7) & 0x1F
    local funct3 = (instruction >> 12) & 0x7
    local funct7 = (instruction >> 25) & 0x7F
    local imm = instruction >> 20

    if opcode == OPCODES.ADDI then
        if funct3 == 0 then
            self.registers[rd] = self.registers[rs1] + imm
        end
    end

    self.registers.pc = pc + 4
end

return mod
