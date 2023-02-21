local Instruction = require("instruction").Instruction

describe("Instruction", function()
    describe("has a constructor that parses an instruction from a number", function()
        it("I-type ( addi x1, x1, 1 )", function()
            local bits = "00000000000100001000000010010011"
            local inst = Instruction.new(tonumber(bits, 2))

            assert.are.equal(0x13, inst.opcode)
            assert.are.equal(1, inst.rd)
            assert.are.equal(0, inst.funct3)
            assert.are.equal(1, inst.rs1)
            assert.are.equal(1, inst.imm)
        end)

        it("R-type ( add x1, x1, x1 )", function()
            local bits = "00000000000100001000000010110011"
            local inst = Instruction.new(tonumber(bits, 2))

            assert.are.equal(0x33, inst.opcode)
            assert.are.equal(1, inst.rd)
            assert.are.equal(0, inst.funct3)
            assert.are.equal(1, inst.rs1)
            assert.are.equal(1, inst.rs2)
            assert.are.equal(0, inst.funct7)
        end)

        it("S-type ( sb x1, 33(x3) )", function()
            local bits = "00000010000100011000000010100011"
            local inst = Instruction.new(tonumber(bits, 2))

            assert.are.equal(0x23, inst.opcode)
            assert.are.equal(33, inst.imm)
            assert.are.equal(0, inst.funct3)
            assert.are.equal(3, inst.rs1)
            assert.are.equal(1, inst.rs2)
        end)

        it("B-type ( beq x1, x2, 2058 )", function()
            local bits = "00000000001000001000010111100011"
            local inst = Instruction.new(tonumber(bits, 2))

            assert.are.equal(0x63, inst.opcode)
            assert.are.equal(2058, inst.imm)
            assert.are.equal(0, inst.funct3)
            assert.are.equal(1, inst.rs1)
            assert.are.equal(2, inst.rs2)
        end)

        it("U-type ( lui x1, 4096 )", function()
            local bits = "00000000000000000001000010110111"
            local inst = Instruction.new(tonumber(bits, 2))

            assert.are.equal(0x37, inst.opcode)
            assert.are.equal(1, inst.rd)
            assert.are.equal(4096, inst.imm)
        end)

        it("J-type ( jal x1, 2050 )", function()
            local bits = "00000000001100000000000011101111"
            local inst = Instruction.new(tonumber(bits, 2))

            assert.are.equal(0x6F, inst.opcode)
            assert.are.equal(1, inst.rd)
            assert.are.equal(2050, inst.imm)
        end)
    end)
end)
