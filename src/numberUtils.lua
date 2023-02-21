local mod = {}

function mod.i32ToI64(x)
    local sign = x & 0x80000000
    if sign == 0 then
        return x
    else
        return x | 0xFFFFFFFF00000000
    end
end

function mod.i12ToI64(x)
    local sign = x & 0x800
    if sign == 0 then
        return x
    else
        return x | 0xFFFFFFFFFFFFF000
    end
end

return mod
