// alu.v
// 1-bit-opcode ALU: op=0 -> add, op=1 -> sub. 4-bit operands.
// Subtraction is implemented the way real hardware does it: negate b (one's
// complement, then +1 for two's complement) and add.
//
// Bugs found with the self-checking testbench and fixed here:
//   1. Sensitivity list was (a, b) -- missing op, so the output did not
//      update when only op changed. Now @(*), which covers a, b and op.
//   2. The subtract path used non-blocking (<=) assignments to chain
//      b_inv -> b_twos -> result, so each step read the OLD value of the
//      previous one. Now blocking (=), so the steps execute in order.

module alu (
  input      [3:0] a,
  input      [3:0] b,
  input            op,      // 0 = add, 1 = sub
  output reg [3:0] result
);

  reg [3:0] b_inv;
  reg [3:0] b_twos;

  always @(*) begin
    case (op)
      1'b0: begin
        result = a + b;                 // add
      end
      1'b1: begin
        b_inv  = ~b;                    // sub, via two's complement
        b_twos = b_inv + 1;
        result = a + b_twos;
      end
    endcase
  end

endmodule