// and_beh_intra.v
// 2-input AND gate, BEHAVIORAL style, INTRA-assignment delay:
// evaluate a & b right away, then wait 5 units before assigning that value.

module and_beh_intra (
  input      a,
  input      b,
  output reg y
);


  always @(a or b) begin
    y = #5 a & b;
  end

endmodule