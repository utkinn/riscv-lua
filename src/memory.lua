local mod = {}

mod.Memory = {}

function mod.Memory.new(size)
    local memory = {
        _bytes = {},
        _size = size,
    }

    return setmetatable(memory, { __index = mod.Memory })
end

function mod.Memory:_checkAddress(address)
    if address < 0 or address >= self._size then
        error("Memory address out of bounds: " .. address)
    end
end

function mod.Memory:readByte(address)
    self:_checkAddress(address)
    return self._bytes[address] or 0
end

function mod.Memory:writeByte(address, value)
    self:_checkAddress(address)
    self._bytes[address] = value & 0xFF
end

function mod.Memory:readHalfWord(address)
    local low = self:readByte(address)
    local high = self:readByte(address + 1)
    return (high << 8) | low
end

function mod.Memory:writeHalfWord(address, value)
    self:writeByte(address, value & 0xFF)
    self:writeByte(address + 1, (value >> 8) & 0xFF)
end

function mod.Memory:readWord(address)
    local low = self:readHalfWord(address)
    local high = self:readHalfWord(address + 2)
    return (high << 16) | low
end

function mod.Memory:writeWord(address, value)
    self:writeHalfWord(address, value & 0xFFFF)
    self:writeHalfWord(address + 2, (value >> 16) & 0xFFFF)
end

return mod
