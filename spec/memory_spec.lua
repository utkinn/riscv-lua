local Memory = require("memory").Memory

describe("Memory", function ()
    local memory

    before_each(function ()
        memory = Memory.new(0x100)
    end)

    it("should read and write bytes", function ()
        memory:writeByte(0x00, 0x12)
        memory:writeByte(0x01, 0x34)
        memory:writeByte(0x02, 0x56)
        memory:writeByte(0x03, 0x1278)

        assert.are.equal(0x12, memory:readByte(0x00))
        assert.are.equal(0x34, memory:readByte(0x01))
        assert.are.equal(0x56, memory:readByte(0x02))
        assert.are.equal(0x78, memory:readByte(0x03))
    end)

    it("should read and write halfwords", function ()
        memory:writeHalfWord(0x00, 0x1234)
        memory:writeHalfWord(0x02, 0x125678)

        assert.are.equal(0x1234, memory:readHalfWord(0x00))
        assert.are.equal(0x5678, memory:readHalfWord(0x02))
    end)

    it("should read and write words", function ()
        memory:writeWord(0x00, 0x112345678)

        assert.are.equal(0x12345678, memory:readWord(0x00))
    end)

    it("has 0 at addresses not written before", function ()
        assert.are.equal(0, memory:readByte(0x00))
    end)

    it("has size getter", function ()
        assert.are.equal(0x100, memory:size())
    end)
end)