
  <h1 align = "center">🚀 AMBA AHB-to-APB Bridge Design</h1>


<p align="center">
  <img src="https://img.shields.io/badge/Language-Verilog-blue?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Protocol-AMBA-orange?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Bus%20Bridge-AHB2APB-green?style=for-the-badge" />
</p>


---

## 📖 Project Overview  

This project implements an **AHB-to-APB Bridge** in **Verilog HDL**, which connects the **high-performance AHB bus** with the **low-power APB bus** inside a System-on-Chip (SoC).  

- The AHB bus is typically used by **CPUs, DMA, and memory** for fast transactions.  
- The APB bus is used by **peripherals like UART, GPIO, Timers** that don’t need high bandwidth.  
- The **bridge** acts as a translator, handling protocol differences and synchronizing transfers across clock domains.  

It ensures **seamless data transfer** between high-speed and low-speed components, enabling efficient SoC design.  

---

## 🧩 What is AMBA?  
 The Advanced Microcontroller Bus Architecture (AMBA) specification defines an 
on-chip communications standard for designing high-performance embedded 
microcontrollers. 

Three distinct buses are defined within the AMBA specification: 
- the Advanced High-performance Bus (AHB)
- the Advanced System Bus (ASB)
- the Advanced Peripheral Bus (APB).

---

## A typical AMBA-based microcontroller
 An AMBA-based microcontroller typically consists of a high-performance system 
backbone bus (AMBA AHB or AMBA ASB), able to sustain the external memory 
bandwidth, on which the CPU, on-chip memory and other Direct Memory Access 
(DMA) devices reside. This bus provides a high-bandwidth interface between the 
elements that are involved in the majority of transfers. Also located on the 
high-performance bus is a bridge to the lower bandwidth APB, where most of the 
peripheral devices in the system are located

<img width="1002" height="382" alt="Screenshot 2025-08-31 180408" src="https://github.com/user-attachments/assets/0dfc8a16-0e95-4bd5-8b3a-e06ca6c91a5f" />

---

## Advanced High-performance Bus (AHB)
The AMBA AHB is for high-performance, high clock frequency system modules.
The AHB acts as the high-performance system backbone bus. AHB supports the 
efficient connection of processors, on-chip memories and off-chip external memory 
interfaces with low-power peripheral macrocell functions. 

### Features
 * High performance
 * Pipelined operation
 * Multiple bus masters
 * Burst transfers
 * Split transactions
 * wider data bus configurations (64/128 bits)
 * single-clock edge operation

### AHB Signals
<img width="872" height="778" alt="Screenshot 2025-08-31 193720" src="https://github.com/user-attachments/assets/fa1942ae-a81e-4fe6-b079-238f1a056c30" />

<img width="882" height="353" alt="Screenshot 2025-08-31 193752" src="https://github.com/user-attachments/assets/4374f629-3c75-4226-b879-5ac48e0dcd56" />

---

## Advanced Peripheral Bus (APB)
The AMBA APB is for low-power peripherals.
AMBA APB is optimized for minimal power consumption and reduced interface 
complexity to support peripheral functions. APB can be used in conjunction with either 
version of the system bus.

### Features
 * Low power
 * Latched address and control
 * Simple interface
 * Suitable for many peripherals

### APB Signals
<img width="894" height="595" alt="Screenshot 2025-08-31 193818" src="https://github.com/user-attachments/assets/9c7c0350-f00e-4d97-9560-076fcc42b744" />

---

## AHB to APB Bridge
An AHB-to-APB Bridge is a hardware module that connects the high-speed AHB bus to the low-speed APB bus. The AHB to APB bridge interface is an AHB slave.
It takes AHB transactions (read/write), converts them into APB transactions, and ensures proper synchronization between their different clock domains.


### ⚙️ Why do we need it?

- The AHB bus is fast, pipelined, and used for CPU ↔ Memory/DMA communication.
- The APB bus is slow, simple, and used for peripherals like UART, SPI, GPIO.
- These buses don’t “speak the same language” — AHB supports burst and pipelined transfers, but APB uses a simple setup–access protocol.
- The bridge solves this mismatch by adapting signals, timing, and handshaking.
- As the APB is pipelined, then wait states are added during transfers to and from the APB where the AHB is required to wait for the APB.

### 🏗️ Functions of the Bridge

- Captures AHB address, control, and data signals.
- Converts AHB transfer protocol into APB’s simple setup-access cycle.
- Handles synchronization if AHB and APB run on different clocks (HCLK vs PCLK).
- Generates handshaking signals (PENABLE, PWRITE, PREADY) for APB.
- Returns response back to the AHB master once APB transfer is done.

--- 

## Block Diagram of AHB2APB Bridge

<img width="541" height="372" alt="Screenshot 2025-08-31 194814" src="https://github.com/user-attachments/assets/6f9467e2-5b38-4fad-be9c-a96a86a8c351" />

### Working
Bridge performs the following operations:-
- Latches the address and holds it valid throughout the transfer.
- Decodes the address and generates a peripheral select, PSELx. Only one select signal can be achieved during a transfer.
- Drives the data onto the APB for write transfer.
- Drives the APB data onto a system bus for read transfer.
- Generates a timing strobe, PENABLE, for the transfer.
  
---

## Block Diagram showing Connections in Bridge Top

<img width="811" height="413" alt="Screenshot 2025-08-31 195304" src="https://github.com/user-attachments/assets/35c7a27f-b4dc-4db8-825e-40649bda529e" />

---

## 📁 Project Structure
```
**AHB_Master.v** – AHB bus master module; initiates read/write transfers.
**AHB_SLAVE_interface.v** – AHB slave interface module; captures address, control, and data signals.
**APB_Interface.v** – APB bus interface; drives APB peripheral access.
**APB_controller.v** – Implements the finite-state machine (FSM) that sequences APB transfers.
**Bridge_Top.v** – Top-level integration of AHB master, bridge, and APB modules.
**LICENSE** – MIT license.
**README.md** – This documentation.
```
---

##  How It Works (Block Flow)

1. **AHB Master** initiates read/write with address and control signals.
2. **AHB Slave Interface** captures these signals and registers them for the bridge.
3. **Bridge FSM (in APB_Controller)**:
   - Detects pending operations via handshaking flags.
   - Initiates APB cycle (setup + access phases); waits for `PREADY`.
   - Returns response back to the AHB side when complete.
4. **APB Interface** coordinates actual transfer to APB peripheral.
5. **Bridge Top** ties everything together, wiring signals and managing resets/clocks.
   
 ---

## Working of AHB

### AHB Master
A bus master is able to initiate read and write operations by 
providing an address and control information. Only one bus 
master is allowed to actively use the bus at any one time.

1. **Single Write**
   - Places address (`Haddr`) on bus  
   - Sets `Hwrite = 1`, `Htrans = NONSEQ (2’b10)`  
   - On next clock: places data (`Hwdata`)  

2. **Single Read**
   - Places address on bus  
   - Sets `Hwrite = 0`, `Htrans = NONSEQ`  
   - On next clock: `Htrans = IDLE (2’b00)`  
   - Data should be captured from `Hrdata` *(though code doesn’t latch it explicitly)*  

3. **Burst Write (Incrementing Burst)**
   - Starts with `NONSEQ` transfer, `Hburst = 3’b011 (INCR4)`  
   - Next transfers are `SEQ (2’b11)` with incremented address and new data each cycle  
   - Random data is driven  
   - Last cycle goes to `IDLE`  

4. **Burst Read (Incrementing Burst)**
   - Starts with `NONSEQ` transfer, `Hwrite = 0`  
   - `Hburst = 3’b011 (INCR4)`  
   - Sequential addresses are generated with `SEQ` transfers  
   - Data is expected to come from slave via `Hrdata`  

### AHB Slave Interface

An AHB bus slave responds to transfers initiated by bus masters within the system. The 
slave uses a HSELx select signal from the decoder to determine when it should respond 
to a bus transfer. All other signals required for the transfer, such as the address and 
control information, will be generated by the bus master. 

- pipelines AHB address/data/write for timing alignment,
- decodes the address to select a peripheral,
- qualifies a transfer with a valid flag,
- passes APB read data (Prdata) back to AHB as Hrdata,
- returns a fixed OKAY response (Hresp=2’b00).

---


## Working of APB

### APB Controller

The AHB to APB bridge comprises a state machine, which is used to control the 
generation of the APB and AHB output signals, and the address decoding logic which 
is used to generate the APB peripheral select lines.

This module implements a finite-state machine that takes qualified AHB inputs (valid, pipelined Haddr/Hwdata/Hwritereg, tempselx) and generates APB control signals (Pselx, Paddr, Pwdata, Pwrite, Penable) while driving Hreadyout back to the AHB master to indicate transfer completion.
  
<img width="656" height="396" alt="Screenshot 2025-08-31 222741" src="https://github.com/user-attachments/assets/3f6bd9e6-a0ed-4b59-8be1-9eae5befef37" />

### APB Interface

---
 

## 🛠️ Tools & Technologies  

<p align="center">
  <img src="https://img.shields.io/badge/HDL-Verilog-blue?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Simulator-ModelSim-green?style=for-the-badge" />
  <img src="https://img.shields.io/badge/FPGA%20Tool-Quartus%20Prime-orange?style=for-the-badge" />
</p>

---

## Schematic 
### Top Level
<img width="1000" height="800" alt="Screenshot 2025-04-05 183559" src="https://github.com/user-attachments/assets/917320ae-0039-4363-93be-33a84e807023" />

### AHB Slave
<img width="1000" height="800" alt="Screenshot 2025-04-05 183651" src="https://github.com/user-attachments/assets/5509dbbb-ac8d-4aa8-922e-23babe9c5199" />

### APB Controller
<img width="542" height="800" alt="Screenshot 2025-04-05 183713" src="https://github.com/user-attachments/assets/5a387ec4-4f63-4ec2-b062-7ce309e6cebe" />

---

## Simulation Results
