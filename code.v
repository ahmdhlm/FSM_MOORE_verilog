module SequenceRecognizer(
    input wire clk,     // Clock input
    input wire reset,   // Reset signal
    input wire X,       // Input sequence
    output reg Y        // Output
);

// State parameters
localparam S0 = 2'b00;  // Initial state
localparam S1 = 2'b01;
localparam S2 = 2'b10;
localparam S3 = 2'b11;

// State registers
reg [1:0] state_reg, next_state;

// State transition and output logic
always @(posedge clk) begin
    if (reset) begin
        state_reg <= S0;  // Reset to initial state
        Y <= 1'b0;        // Reset output to 0
    end else begin
        state_reg <= next_state;
    end
end

// State transition logic
always @(state_reg or X) begin
    case (state_reg)
        S0: begin
            if (X == 1'b1)
                next_state = S1;
            else
                next_state = S0;
        end
        S1: begin
            if (X == 1'b0)
                next_state = S2;
            else
                next_state = S1;
        end
        S2: begin
            if (X == 1'b1)
                next_state = S3;
            else
                next_state = S2;
        end
        S3: begin
            if (X == 1'b0)
                next_state = S0;
            else
                next_state = S3;
        end
        default: next_state = S0;
    endcase
end

// Output logic
always @(state_reg) begin
    case(state_reg)
        S0, S1, S2: Y = 1'b0;
        S3: Y = 1'b1;
        default: Y = 1'b0;
    endcase
end

endmodule


module SequenceRecognizer_tb();

  reg clk;
  reg reset;
  reg X;
  wire Y;

  // Instantiate the module
  SequenceRecognizer dut(
    .clk(clk),
    .reset(reset),
    .X(X),
    .Y(Y)
  );

  // Clock generation
  always #5 clk = ~clk;

  // Initial values
  initial begin
    clk = 0;
    reset = 1;
    X = 0;
    #10 reset = 0;  // Deassert reset after 10 time units
    #1000 $finish;  // End simulation after 1000 time units
  end

  // Stimulus
  initial begin
    // Test scenario
    #15 X = 1;
    #10 X = 0;
    #10 X = 1;
    #10 X = 0;
    #10 X = 1;
    #10 X = 0;
    #10 X = 1;
    #10 X = 1;
    #10 X = 0;
    #10 X = 1;
    #10 X = 0;
    #10 X = 1;
    #10 X = 1;
    #10 X = 1; // An extra cycle to observe output stability
    
  end

endmodule


