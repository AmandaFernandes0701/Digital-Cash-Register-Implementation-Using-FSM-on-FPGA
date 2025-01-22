# Digital Cash Register Implementation

## Table of Contents
- [Overview](#overview)
- [Architecture and Design](#architecture-and-design)
- [Technologies and Tools](#technologies-and-tools)
- [Development Process](#development-process)
- [Key Decisions and Challenges](#key-decisions-and-challenges)
- [Future Improvements](#future-improvements)

---

## Overview
This project implements a digital cash register system on an FPGA using finite state machines (FSM). It performs addition and subtraction operations, displays results on 7-segment displays, and records transactions in `.txt` files during simulations.  

### Key Features:
- **User Inputs**:  
  - 4 binary switches for numeric value.  
  - 1 binary switch for operator selection (addition/subtraction).  
  - 2 confirmation buttons: one for the value and one for the operator.  
- **Outputs**:  
  - 7-segment displays to show the computed results.  
- **Simulation and Deployment**:  
  - Simulations validated via ModelSim.  
  - Implemented on a DE10-Lite FPGA board.  

---

## Architecture and Design
The system is divided into three main modules:  

### 1. **Control Module (FSM)**:
- Coordinates the system’s operation across four states:
  1. **Read Value**: Captures input from the switches upon pressing the value confirmation button.
  2. **Read Operator**: Captures the selected operation upon pressing the operator confirmation button.
  3. **Compute**: Executes the operation (addition/subtraction).
  4. **Display**: Outputs the result to the 7-segment displays.  

- **Design Choice**:  
  A simple FSM with four states ensures clear transitions, ease of debugging, and efficient operation.

### 2. **Datapath Module**:
- **Functions**:
  - Converts binary input from switches into decimal format.
  - Executes arithmetic operations.
  - Prepares the result for display.  
- **Components**:
  - **Registers**: Temporarily store user inputs and selected operations.
  - **Arithmetic Unit**: Performs addition and subtraction.
  - **BCD to 7-Segment Converter**: Formats the computed result for output.

### 3. **Display Module**:
- Outputs the computed results on two 7-segment displays representing the units and tens digits.

---

## Technologies and Tools
1. **VHDL**:  
   - Used to design the FSM, datapath, and display logic.  
2. **ModelSim**:  
   - Simulates and validates FSM transitions and system functionality.  
3. **DE10-Lite FPGA Board**:  
   - **Inputs**: 4 binary switches for numeric values, 1 binary switch for the operator, and 2 buttons for confirmation.  
   - **Outputs**: 7-segment displays for results.  
   - Configured with Schmitt Trigger to ensure clean and debounce-free button inputs.

---

## Development Process
1. **Planning and Ideation**:
   - **Objective**: Build a reliable, modular system within the project timeline.  
   - Focused on simplifying FSM states and ensuring modularity for easier debugging.  

2. **Simulation and Validation**:
   - Conducted thorough simulations in ModelSim to verify FSM state transitions and arithmetic logic.  
   - Recorded transactions in `.txt` files for simulation analysis.  

3. **Hardware Implementation**:
   - Deployed the system on the DE10-Lite FPGA board.  
   - Configured switches and buttons for user input and tested real-time functionality on the 7-segment displays.

---

## Key Decisions and Challenges
### Design Simplicity:
- **FSM with Four States**:  
  A simplified FSM ensures clarity, efficient debugging, and faster implementation. It focuses on core functionalities: capturing inputs, executing operations, and displaying results.  

### Input Design:
- **Switches for Value and Operator**:  
  Switches were chosen for their simplicity and reliability in providing binary inputs.  
- **Two Confirmation Buttons**:  
  Separate buttons for value and operator inputs ensure clear and deliberate state transitions, reducing the risk of errors.  

### Time Constraints:
- Prioritized delivering a functional system with essential features rather than overcomplicating the design with additional operations or states.  

---

## Future Improvements
1. **Expanded Arithmetic Operations**:
   - Add support for multiplication, division, or other advanced operations.
2. **Dynamic Input Methods**:
   - Replace binary switches with a keypad for intuitive user interaction.
3. **Scalability**:
   - Further modularize the design to simplify future feature additions and maintenance.
4. **Enhanced Display**:
   - Upgrade to an LCD to provide richer output, such as showing both operands and the operation.

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
