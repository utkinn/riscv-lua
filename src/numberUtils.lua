local mod = {}

function mod.i32ToI64(x)
    local sign = x & 0x80000000
    if sign == 0 then
        return x
    else
        return x | 0xFFFFFFFF00000000
    end
end

function mod.i21ToI64(x)
    local sign = x & 0x100000
    if sign == 0 then
        return x
    else
        return x | 0xFFFFFFFFFFE00000
    end
end

function mod.i16ToI64(x)
    local sign = x & 0x8000
    if sign == 0 then
        return x
    else
        return x | 0xFFFFFFFFFFFF0000
    end
end

function mod.i13ToI64(x)
    local sign = x & 0x1000
    if sign == 0 then
        return x
    else
        return x | 0xFFFFFFFFFFFFE000
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

function mod.i8ToI64(x)
    local sign = x & 0x80
    if sign == 0 then
        return x
    else
        return x | 0xFFFFFFFFFFFFFF00
    end
end

return mod
