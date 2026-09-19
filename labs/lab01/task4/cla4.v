// cla4.v
// Gate-level 4-bit carry-lookahead adder, matching the lecture circuit.
// Every gate needs an explicit delay (constant is fine here, e.g. #(2)) --
// this is the default from Task 2 onward, not a special step.
//
// TODO -- Step 1: generate/propagate signals (one xor + one and per bit)
//   p[i] = a[i] ^ b[i]
//   g[i] = a[i] & b[i]
//
// TODO -- Step 2: direct (non-recursive) carry equations. Verilog's and/or
// primitives accept more than 2 inputs directly, e.g.:
//   and #(2) (t2, p1, p0, g0);
// so you do not need to manually chain 2-input gates.
//   c1 = g0 + p0.cin
//   c2 = g1 + p1.g0 + p1.p0.cin
//   c3 = g2 + p2.g1 + p2.p1.g0 + p2.p1.p0.cin
//   c4 = g3 + p3.g2 + p3.p2.g1 + p3.p2.p1.g0 + p3.p2.p1.p0.cin
//
// TODO -- Step 3: sum bits
//   sum[i] = p[i] ^ c[i]     (c0 = cin)

module cla4(
  input  [3:0] a,
  input  [3:0] b,
  input        cin,
  output [3:0] sum,
  output       cout
);

  wire p0, p1, p2, p3;
  wire g0, g1, g2, g3;
  wire c1, c2, c3;
  
  wire w_c1_1;
  wire w_c2_1, w_c2_2;
  wire w_c3_1, w_c3_2, w_c3_3;
  wire w_c4_1, w_c4_2, w_c4_3, w_c4_4;


  // TODO: your gate-level P/G, carry, and sum logic goes here.
  xor #(2) x0 (p0, a[0], b[0]);
  and #(2) a0 (g0, a[0], b[0]);

  xor #(2) x1 (p1, a[1], b[1]);
  and #(2) a1 (g1, a[1], b[1]);

  xor #(2) x2 (p2, a[2], b[2]);
  and #(2) a2 (g2, a[2], b[2]);

  xor #(2) x3 (p3, a[3], b[3]);
  and #(2) a3 (g3, a[3], b[3]);
  // (cout should be connected to c4.) Remember the delay on every gate.
 
 and #(2) a_c1_1 (w_c1_1, p0, cin);
  or  #(2) o_c1   (c1, g0, w_c1_1);

  // c2 = g1 + p1*g0 + p1*p0*cin
  and #(2) a_c2_1 (w_c2_1, p1, g0);
  and #(2) a_c2_2 (w_c2_2, p1, p0, cin);
  or  #(2) o_c2   (c2, g1, w_c2_1, w_c2_2);

  // c3 = g2 + p2*g1 + p2*p1*g0 + p2*p1*p0*cin
  and #(2) a_c3_1 (w_c3_1, p2, g1);
  and #(2) a_c3_2 (w_c3_2, p2, p1, g0);
  and #(2) a_c3_3 (w_c3_3, p2, p1, p0, cin);
  or  #(2) o_c3   (c3, g2, w_c3_1, w_c3_2, w_c3_3);

  // cout (c4) = g3 + p3*g2 + p3*p2*g1 + p3*p2*p1*g0 + p3*p2*p1*p0*cin
  and #(2) a_c4_1 (w_c4_1, p3, g2);
  and #(2) a_c4_2 (w_c4_2, p3, p2, g1);
  and #(2) a_c4_3 (w_c4_3, p3, p2, p1, g0);
  and #(2) a_c4_4 (w_c4_4, p3, p2, p1, p0, cin);
  or  #(2) o_c4   (cout, g3, w_c4_1, w_c4_2, w_c4_3, w_c4_4);

  // Step 3: Sum logic
  xor #(2) s0 (sum[0], p0, cin);
  xor #(2) s1 (sum[1], p1, c1);
  xor #(2) s2 (sum[2], p2, c2);
  xor #(2) s3 (sum[3], p3, c3);
  
endmodule
