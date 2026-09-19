// tb.v
// Testbench for the lookup table (ROM) lut.v

module tb;

  // Must match the parameters used for the DUT below.
  localparam WIDTH = 8;
  localparam DEPTH = 4;

  // Input is driven from procedural code -> reg; output comes from DUT -> wire.
  reg  [$clog2(DEPTH)-1:0] t_sel;
  wire [WIDTH-1:0]         t_dout;

  // The instance is named DUT so that $dumpvars(0, DUT) below resolves to it.
  lut #(
    .WIDTH (WIDTH),
    .DEPTH (DEPTH)
  ) DUT (
    .sel  (t_sel),
    .dout (t_dout)
  );

  // Waveform dump configuration (DO NOT CHANGE)
  string vcd_file;
  initial begin
    if ($value$plusargs("vcd=%s", vcd_file)) begin
      $dumpfile(vcd_file);
      $dumpvars(0, DUT);
    end
  end

  initial begin
    // Read every location in order: expect 0, 1, 4, 9
    t_sel = 0;
    #5 t_sel = 1;
    #5 t_sel = 2;
    #5 t_sel = 3;

    // Then jump around out of order to show the read is combinational
    #5 t_sel = 2;
    #5 t_sel = 0;
    #5 t_sel = 3;
    #5 t_sel = 1;


    #5 $finish;
  end

  initial
    $monitor($time, " sel=%d | dout=%d", t_sel, t_dout);

endmodule