# Fixed-Point Digital PID Controller Using Verilog

## Project Overview

This project implements a **discrete-time PID controller using fixed-point arithmetic in Verilog HDL**.

The project focuses on converting a conventional PID control algorithm into a hardware-oriented RTL implementation. The controller calculates the proportional, integral, and derivative terms using fixed-point arithmetic and includes output saturation and integral anti-windup.

The design is verified through RTL simulation, and its response is compared with a floating-point MATLAB implementation to evaluate the accuracy of the fixed-point implementation.

## What Was Done

* Designed a discrete PID controller in Verilog HDL.
* Implemented **fixed-point arithmetic** for hardware-friendly computation.
* Implemented proportional, integral, and derivative terms.
* Added a clocked integral accumulator.
* Added output saturation limits.
* Implemented integral anti-windup.
* Created a Verilog testbench for functional verification.
* Simulated the RTL design and analyzed the resulting waveforms.
* Developed a floating-point PID reference model in MATLAB.
* Compared the fixed-point implementation with the floating-point reference response.

## Environment Used

### Hardware Description Language

* **Verilog HDL**

### Simulation & RTL Design

* **Xilinx Vivado**
* RTL Functional Simulation
* Waveform analysis

### Reference Model & Analysis

* **MATLAB**

## Project Structure

```text
Discrete-PID-Controller/
│
├── README.md
│
├── RTL/
│   └── pid_controller.v
│
├── Testbench/
│   └── tb_pid_controller.v
│
├── MATLAB/
│   └── pid_floating_point.m
│
└── Results/
    ├── pid_simulation_waveform.png
    └── fixed_vs_floating.png
```

## Future Improvements

* Implement a fully parameterized PID controller.
* Optimize fixed-point word length and precision.
* Perform FPGA synthesis and analyze resource utilization.
* Perform timing analysis and optimization.
* Implement an AXI interface for configurable PID parameters.
* Interface the controller with ADC/DAC or PWM hardware.
* Implement real-time FPGA-based motor or power-control applications.
* Develop automated MATLAB-to-Verilog verification.
* Explore pipelined architecture for higher operating frequencies.

## Conclusion

This project demonstrates the implementation of a **fixed-point discrete PID controller in Verilog HDL**, starting from a floating-point reference model and progressing to RTL design and simulation.

The project provides practical experience in **digital control systems, fixed-point arithmetic, Verilog RTL design, simulation, and hardware-oriented algorithm implementation**. The comparison with the MATLAB reference model provides a basis for evaluating the accuracy of the hardware implementation.

