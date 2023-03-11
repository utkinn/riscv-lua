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

return mod
