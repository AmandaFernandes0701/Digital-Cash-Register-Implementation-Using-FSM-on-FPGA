# Digital Cash Register Implementation

## Table of Contents
- [Overview](#overview)
- [Project Architecture](#project-architecture)
  - [Modules and Functionality](#modules-and-functionality)
- [Finite State Machine (FSM)](#finite-state-machine-fsm)
  - [State Descriptions](#state-descriptions)
- [Technologies Used](#technologies-used)
- [Development Process](#development-process)
  - [Ideation and Planning](#ideation-and-planning)
  - [Simulation and Validation](#simulation-and-validation)
  - [Hardware Implementation](#hardware-implementation)
- [Key Design Decisions](#key-design-decisions)
- [Possible Improvements](#possible-improvements)
- [Results and Reflections](#results-and-reflections)
- [How to Run](#how-to-run)
- [Acknowledgments](#acknowledgments)
- [References](#references)

---

## Overview
This project implements a modular digital cash register system using finite state machines (FSM) on an FPGA. The system performs addition and subtraction operations, displays results on 7-segment displays, and records transactions in `.txt` files during functional simulations. User inputs include:  
- **Value**: Provided via 4 binary switches.  
- **Operator**: Selected using a separate switch.  
- **Confirmation Buttons**: Two buttons confirm the entry of the value and the operator, respectively.  

---

## Project Architecture

### Modules and Functionality
1. **Control Module**:
   - Implements FSM to coordinate system states and operations.
2. **Datapath Module**:
   - Converts binary input from switches into decimal values.
   - Executes arithmetic operations based on the selected operator.
3. **Display Module**:
   - Outputs the computed result on 7-segment displays.

### Input Handling
- **4 Switches**: Represent a binary number for the value input.
- **1 Switch**: Used to select the operation (addition or subtraction).
- **2 Buttons**:
  - **Value Confirmation Button**: Confirms the entry of the numeric value.
  - **Operator Confirmation Button**: Confirms the operator selection.

---

## Finite State Machine (FSM)

### State Descriptions
The FSM operates in five states, coordinating the flow of inputs, operations, and outputs:

1. **Idle State**:
   - **Function**: Waits for the value confirmation button to be pressed.
   - **Transition Condition**: Advances to the **Read Value** state when the button is pressed.

2. **Read Value State**:
   - **Function**: Reads the binary value from the switches and stores it in a register.
   - **Transition Condition**: Moves to the **Read Operator** state when the operator confirmation button is pressed.

3. **Read Operator State**:
   - **Function**: Reads the operator (addition/subtraction) from the switch and stores it.
   - **Transition Condition**: Advances to the **Compute** state after confirming the operator.

4. **Compute State**:
   - **Function**: Performs the selected arithmetic operation using the inputs.
   - **Transition Condition**: Proceeds to the **Display** state once computation is complete.

5. **Display State**:
   - **Function**: Converts and displays the result on 7-segment displays.
   - **Transition Condition**: Returns to the **Idle** state after a set time or upon pressing reset.

---

## Technologies Used
1. **VHDL**:
   - Used to design FSMs and hardware components.
2. **ModelSim**:
   - Simulates the FSM and validates functionality using waveform analysis.
3. **FPGA Kit**:
   - **Board**: DE10-Lite.
   - **Pin Configuration**:
     - Inputs: 4 switches for the numeric value, 1 switch for the operator, 2 buttons for confirmation.
     - Outputs: 7-segment displays and status LEDs.
   - **Debounce-Free Input**: Configured with Schmitt Trigger for clean button presses.

---

## Development Process

### Ideation and Planning
- **Goals**: Create a functional and modular system to perform simple arithmetic operations.
- **Time Management**: Divided the timeline into design, simulation, integration, and testing phases, with weekly milestones.

### Simulation and Validation
- **ModelSim Simulations**:
  - Verified state transitions and operations using waveform outputs.
  - Tested with various input combinations to ensure reliability.
- **Debugging**:
  - Addressed issues such as incorrect state transitions during simulation before moving to hardware implementation.

### Hardware Implementation
- **Input and Output Configuration**:
  - Binary switches for numeric value and operator selection.
  - Buttons for confirming value and operator inputs.
- **System Testing**:
  - Successfully implemented on the DE10-Lite board with outputs displayed on 7-segment displays.

---

## Key Design Decisions
1. **Modular Architecture**:
   - Separate modules for control, data processing, and display enhanced maintainability.
2. **Simplified FSM**:
   - Five states ensured clear logic and manageable transitions.
3. **Simulation-First Approach**:
   - Thorough validation in ModelSim minimized errors during hardware testing.

---

## Possible Improvements
1. **Expanded Operations**:
   - Include additional arithmetic operations like multiplication and division.
2. **Dynamic Input Interface**:
   - Replace binary switches with a keypad for more intuitive data entry.
3. **Enhanced Feedback**:
   - Use an LCD for richer output, such as displaying operation details.
4. **Scalability**:
   - Modularize further to simplify future feature additions.

---

## Results and Reflections
- **Simulation Outcomes**:
  - Validated FSM states and arithmetic accuracy through waveform analysis.
  - Recorded transactions successfully in `.txt` files.
- **Hardware Validation**:
  - Reliable performance with real-time operation on DE10-Lite.
  - Clear outputs on 7-segment displays.

---

## How to Run
1. **Simulations**:
   - Open VHDL files in ModelSim and simulate with different inputs to observe waveforms.
2. **Hardware Setup**:
   - Deploy the design onto the DE10-Lite FPGA board.
   - Connect switches, buttons, and 7-segment displays.

---

## Acknowledgments
- **Team Members**: Amanda Fernandes Alves, Thiago Gomes Rezende.
- **Professor**: Jhonattan Córdoba Ramírez.
- **Institution**: Universidade Federal de Minas Gerais.

---

## References
- Perry, D. L. (2002). *VHDL: Programming by Example*.
- Bhasker, J. (1999). *A VHDL Primer*.
- IEEE. (2008). *VHDL Language Reference Manual*.
