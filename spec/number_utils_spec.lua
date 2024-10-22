local u = require("number_utils")

describe("i32ToI64", function()
    it("converts -1i32 to 0xFFFFFFFFi64", function()
        local minusOneI32 = 0xFFFFFFFF
        assert.are.equal(-1, u.i32ToI64(minusOneI32))
    end)

    it("converts 1i32 to 1i64", function()
        assert.are.equal(1, u.i32ToI64(1))
    end)
end)

describe("i12ToI64", function()
    it("converts -1i12 to 0xFFFFFFFFFFFFF000i64", function()
        local minusOneI12 = 0xFFF
        assert.are.equal(-1, u.i12ToI64(minusOneI12))
    end)

    it("converts 1i12 to 1i64", function()
        assert.are.equal(1, u.i12ToI64(1))
    end)
end)

describe("parseSignedIntFrom12Bits", function()
    it("parses positive numbers", function()
        assert.are.equal(3, u.parseSignedIntFrom12Bits(3))
    end)

    it("parses negative numbers", function()
        assert.are.equal(-1, u.parseSignedIntFrom12Bits(0xFFF))
    end)
end)
