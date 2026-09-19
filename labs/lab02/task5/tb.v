// tb.v
// Self-checking, exhaustive testbench for the 4-bit add/sub ALU.
// Tries every (a, b, op) combination: 16 x 16 x 2 = 512 vectors.
// For each (a, b) pair, op is switched 0 -> 1 while a and b are held, so
// changes on op alone are exercised too.

module tb;

  reg  [3:0] t_a, t_b;
  reg        t_op;
  wire [3:0] t_result;

  reg  [3:0] expected;

  integer i, j;
  integer errors;
  integer tests;

  alu DUT (
    .a      (t_a),
    .b      (t_b),
    .op     (t_op),
    .result (t_result)
  );

  // Waveform dump configuration
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  // Compare DUT output with the expected 4-bit result for the current inputs
  task check;
    begin
      expected = t_op ? (t_a - t_b) : (t_a + t_b);   // 4-bit wraparound
      tests = tests + 1;
      // !== also catches X/Z on the output
      if (t_result !== expected) begin
        errors = errors + 1;
        if (errors <= 10)
          $display("%0t ERROR: a=%0d b=%0d op=%b (%s) | got %0d, expected %0d",
                   $time, t_a, t_b, t_op, t_op ? "sub" : "add", t_result, expected);
      end
    end
  endtask

  initial begin
    errors = 0;
    tests  = 0;

    for (i = 0; i < 16; i = i + 1) begin
      for (j = 0; j < 16; j = j + 1) begin
        t_a = i;
        t_b = j;

        t_op = 0;          // add
        #5 check;

        t_op = 1;          // sub: only op changes, a and b held
        #5 check;
      end
    end

    if (errors == 0)
      $display("PASS: all %0d test vectors matched.", tests);
    else
      $display("FAIL: %0d of %0d test vectors had errors (first 10 shown above).", errors, tests);

    $finish;
  end

endmodule