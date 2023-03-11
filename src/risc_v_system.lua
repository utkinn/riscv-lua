local CPU = require("cpu").CPU
local Memory = require("memory").Memory

local mod = {}

mod.System = {}

function mod.System.new(spec)
    local self = {
        memory = Memory.new(spec.memorySize),
        cpu = CPU.new()
    }

    return setmetatable(self, { __index = mod.System })
end

function mod.System:load(address, data)
    self.memory:write(address, data)
end

function mod.System:runTicks(ticks)
    for i = 1, ticks do
        self.cpu:tick(self.memory)
    end
end

return mod
