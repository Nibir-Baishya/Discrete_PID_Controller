module pid_controller (
    input  wire               clk,
    input  wire               reset,
    input  wire signed [15:0] ref_in,
    input  wire signed [15:0] feedback_in,
    output reg  signed [15:0] control_out
);

    // ============================================================
    // Fixed-point format: Q12
    // 1.0 = 4096
    // ============================================================

    // Kp = 2.0
    localparam signed [15:0] KP = 16'sd8192;

    // Ki*Ts = 0.5 * 0.01 = 0.005
    // 0.005 * 2^24 = 83886
    localparam signed [31:0] KI_D = 32'sd83886;

    // Kd/Ts = 0.1 / 0.01 = 10
    // 10 * 2^24 = 167772160
    localparam signed [31:0] KD_D = 32'sd167772160;

    // Output limits: -1 to +1
    localparam signed [15:0] U_MAX = 16'sd4096;
    localparam signed [15:0] U_MIN = -16'sd4096;

    // ============================================================
    // Error
    // ============================================================

    wire signed [15:0] error;

    assign error = ref_in - feedback_in;

    // ============================================================
    // Previous feedback
    // Derivative is calculated from measurement
    // ============================================================

    reg signed [15:0] previous_feedback;

    wire signed [15:0] feedback_difference;

    assign feedback_difference =
            feedback_in - previous_feedback;

    // ============================================================
    // Integral accumulator
    // ============================================================

    reg signed [31:0] integral_accumulator;

    wire signed [47:0] i_product;
    wire signed [31:0] i_increment;
    wire signed [31:0] integral_next;

    assign i_product = error * KI_D;

    assign i_increment = i_product >>> 24;

    assign integral_next =
            integral_accumulator + i_increment;

    // ============================================================
    // Proportional term
    // ============================================================

    wire signed [31:0] p_product;
    wire signed [15:0] p_out;

    assign p_product = KP * error;

    assign p_out = p_product >>> 12;

    // ============================================================
    // Derivative term
    // ============================================================

    wire signed [47:0] d_product;
    wire signed [31:0] d_out;

    assign d_product =
            feedback_difference * KD_D;

    // Negative because derivative is based on feedback
    assign d_out =
            -(d_product >>> 24);

    // ============================================================
    // PID sum
    // ============================================================

    wire signed [32:0] pid_sum;

    assign pid_sum =
          {{17{p_out[15]}}, p_out}
        + {{1{integral_accumulator[31]}},
           integral_accumulator}
        + {{1{d_out[31]}}, d_out};

    // ============================================================
    // Sequential controller
    // ============================================================

    always @(posedge clk) begin

        if (reset) begin

            previous_feedback <= 16'sd0;
            integral_accumulator <= 32'sd0;
            control_out <= 16'sd0;

        end

        else begin

            // ----------------------------------------------------
            // Store feedback for derivative calculation
            // ----------------------------------------------------

            previous_feedback <= feedback_in;

            // ----------------------------------------------------
            // Integral anti-windup
            // ----------------------------------------------------

            if (integral_next > 32'sd4096)

                integral_accumulator <= 32'sd4096;

            else if (integral_next < -32'sd4096)

                integral_accumulator <= -32'sd4096;

            else

                integral_accumulator <= integral_next;

            // ----------------------------------------------------
            // Output saturation
            // ----------------------------------------------------

            if (pid_sum > 33'sd4096)

                control_out <= U_MAX;

            else if (pid_sum < -33'sd4096)

                control_out <= U_MIN;

            else

                control_out <= pid_sum[15:0];

        end

    end

endmodule