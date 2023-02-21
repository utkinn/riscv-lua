local u = require("numberUtils")

describe("i32ToI64", function()
    it("converts -1i32 to 0xFFFFFFFFi64", function()
        local minusOneI32 = 0xFFFFFFFF
        assert.are.equal( -1, u.i32ToI64(minusOneI32))
    end)

    it("converts 1i32 to 1i64", function()
        assert.are.equal(1, u.i32ToI64(1))
    end)
end)
