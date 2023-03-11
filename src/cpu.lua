local Instruction = require("instruction").Instruction

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

--- Executes a program.
-- Program is assumed to be at address 0.
-- @param program a table of 32-bit instructions encoded as numbers
function mod.CPU:execute(program)
    for i = 1, #program do
        local instruction = Instruction.new(program[i])
        instruction:exec(self, {})
        self.registers.pc = self.registers.pc + 4
    end
end

function mod.CPU:tick(memory)
    local instruction = Instruction.new(memory:readWord(self.registers.pc))
    instruction:exec(self, memory)
    self.registers.pc = self.registers.pc + 4
end

function mod.CPU:writeReg(reg, value)
    self.registers[reg] = value & 0xFFFFFFFF
    self.registers[0] = 0
end

return mod
