// and_beh_before.v
// 2-input AND gate, BEHAVIORAL style, delay placed BEFORE the assignment:
// wait 5 units first, then evaluate a & b and assign.

module and_beh_before (
  input      a,
  input      b,
  output reg y
);


  always @(a or b) begin
    #5 y = a & b;
  end

endmodule