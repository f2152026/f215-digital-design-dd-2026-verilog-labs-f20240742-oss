

module tb;

  reg  [1:0] t_a, t_b;
  wire       t_gt, t_lt, t_eq;


  reg        exp_gt, exp_lt, exp_eq;

  integer    i, j;
  integer    errors;
  integer    tests;


  comp2 DUT (
    .A  (t_a),
    .B  (t_b),
    .GT (t_gt),
    .LT (t_lt),
    .EQ (t_eq)
  );

  // Waveform dump configuration
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  initial begin
    errors = 0;
    tests  = 0;

    for (i = 0; i < 4; i = i + 1) begin
      for (j = 0; j < 4; j = j + 1) begin
        t_a = i;
        t_b = j;

        // Expected values from the plain integer values of i and j
        exp_gt = (i >  j);
        exp_lt = (i <  j);
        exp_eq = (i == j);

        #5; 

        tests = tests + 1;

        if (t_gt !== exp_gt || t_lt !== exp_lt || t_eq !== exp_eq) begin
          errors = errors + 1;
          $display("%0t ERROR: A=%b B=%b | got GT=%b LT=%b EQ=%b | expected GT=%b LT=%b EQ=%b",
                   $time, t_a, t_b, t_gt, t_lt, t_eq, exp_gt, exp_lt, exp_eq);
        end
      end
    end

    if (errors == 0)
      $display("PASS: all %0d test vectors matched.", tests);
    else
      $display("FAIL: %0d of %0d test vectors had errors.", errors, tests);

    $finish;
  end

endmodule