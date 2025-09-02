
  <h1 align="center">🚀 AMBA AHB-to-APB Bridge Design</h1>

<p align="center">
  <img src="https://img.shields.io/badge/Language-Verilog-blue?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Protocol-AMBA-orange?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Bus%20Bridge-AHB2APB-green?style=for-the-badge" />
</p>

---

## 📖 Project Overview  

This project implements an **AHB-to-APB Bridge** in **Verilog HDL**, which connects the **high-performance AHB bus** with the **low-power APB bus** inside a System-on-Chip (SoC).  

- ⚡ The AHB bus is typically used by **CPUs, DMA, and memory** for fast transactions.  
- 🔌 The APB bus is used by **peripherals like UART, GPIO, Timers** that don’t need high bandwidth.  
- 🔄 The **bridge** acts as a translator, handling protocol differences and synchronizing transfers across clock domains.  

It ensures **seamless data transfer** between high-speed and low-speed components, enabling efficient SoC design.  

---

## 🧩 What is AMBA?  
The **Advanced Microcontroller Bus Architecture (AMBA)** specification defines an on-chip communications standard for designing high-performance embedded microcontrollers.  

Three distinct buses are defined within the AMBA specification:  
- 🟢 **AHB (Advanced High-performance Bus)**  
- 🟡 **ASB (Advanced System Bus)**  
- 🔵 **APB (Advanced Peripheral Bus)**  

---

## 🖥️ A Typical AMBA-based Microcontroller  

An AMBA-based microcontroller typically consists of a **high-performance system backbone bus** (AMBA AHB or AMBA ASB), able to sustain external memory bandwidth.  

- CPU, on-chip memory, and DMA devices reside on this high-performance bus.  
- A bridge connects this backbone bus to the **lower-bandwidth APB**, where most peripheral devices exist.  

<p align="center">
<img width="700" height="382" src="https://github.com/user-attachments/assets/0dfc8a16-0e95-4bd5-8b3a-e06ca6c91a5f" />
</p>

---

## ⚡ Advanced High-performance Bus (AHB)  

The **AMBA AHB** is for **high-performance, high-frequency system modules**.  
It serves as the backbone bus to connect processors, memories, and external memory interfaces with low-power peripherals.  

### ✨ Features
- High performance  
- Pipelined operation  
- Multiple bus masters  
- Burst transfers  
- Split transactions  
- Wider data bus configurations (64/128 bits)  
- Single-clock edge operation  

### 📡 AHB Signals
<p align="center">
<img width="700" height="600" src="https://github.com/user-attachments/assets/fa1942ae-a81e-4fe6-b079-238f1a056c30" />
</p>

<p align="center">
<img width="700" height="300" src="https://github.com/user-attachments/assets/4374f629-3c75-4226-b879-5ac48e0dcd56" />
</p>

---

## 🔌 Advanced Peripheral Bus (APB)  

The **AMBA APB** is optimized for **low power consumption** and **simplified interface complexity** for peripherals.  

### ✨ Features
- Low power  
- Latched address and control  
- Simple interface  
- Suitable for many peripherals  

### 📡 APB Signals
<p align="center">
<img width="700" height="400" src="https://github.com/user-attachments/assets/9c7c0350-f00e-4d97-9560-076fcc42b744" />
</p>

---

## 🔄 AHB to APB Bridge  

An **AHB-to-APB Bridge** is a hardware module that connects the high-speed AHB bus to the low-speed APB bus.  

- Acts as an **AHB slave**  
- Converts AHB transactions (read/write) into APB transactions  
- Synchronizes between different clock domains  

### ⚙️ Why Do We Need It?
- AHB = fast, pipelined, CPU ↔ Memory/DMA transfers  
- APB = slow, simple, UART/SPI/GPIO transfers  
- They don’t “speak the same language” → bridge adapts signals & timing  
- Adds wait states to synchronize transfers  

### 🏗️ Functions of the Bridge
- Latches and holds address throughout transfer  
- Decodes address → generates **PSELx** (only one active at a time)  
- Drives data for **write transfer**  
- Returns APB data on **read transfer**  
- Generates **PENABLE strobe**  

---

## 📊 Block Diagram of AHB2APB Bridge  
<p align="center">
<img width="541" height="372" src="https://github.com/user-attachments/assets/6f9467e2-5b38-4fad-be9c-a96a86a8c351" />
</p>

---

## 🔗 Block Diagram Showing Connections in Bridge Top  
<p align="center">
<img width="811" height="413" src="https://github.com/user-attachments/assets/35c7a27f-b4dc-4db8-825e-40649bda529e" />
</p>

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


---

## 🔄 How It Works (Block Flow)  

1. **AHB Master** initiates transfers (address + control).  
2. **AHB Slave Interface** captures & registers signals.  
3. **Bridge FSM (APB_Controller)**  
   - Detects pending ops  
   - Initiates APB cycle (setup + access)  
   - Waits for `PREADY`  
   - Returns response to AHB side  
4. **APB Interface** → transfers to peripheral.  
5. **Bridge Top** ties everything together.  

---

## 🖧 Working of AHB  

### 🟢 AHB Master  
- Initiates **read/write** by placing address + control signals  
- Supports **single** and **burst** transfers  

1. **Single Write** → Address → Hwrite=1 → Data  
2. **Single Read** → Address → Hwrite=0 → Capture Hrdata  
3. **Burst Write** → INCR4 bursts with sequential addresses & data  
4. **Burst Read** → INCR4 bursts → sequential addresses → read data  

### 🔵 AHB Slave Interface  
- Responds to transfers with `HSELx`  
- Pipelines AHB address/data/write  
- Decodes address → select peripheral  
- Returns **Hrdata** from APB read  
- Always returns `Hresp = OKAY`  

---

## 🖧 Working of APB  

### 🟣 APB Controller  
- FSM to control APB signals & timing  
- Decodes AHB signals → drives Pselx, Paddr, Pwdata, Pwrite, Penable  
- Generates `Hreadyout`  

<p align="center">
<img width="656" height="396" src="https://github.com/user-attachments/assets/3f6bd9e6-a0ed-4b59-8be1-9eae5befef37" />
</p>

### 🟤 APB Interface  
- Pass-through between bridge & APB slave  
- Forwards all signals  
- Generates read data on APB read  

---

## 🛠️ Tools & Technologies  

<p align="center">
  <img src="https://img.shields.io/badge/HDL-Verilog-blue?style=for-the-badge" />
  <img src="https://img.shields.io/badge/Simulator-ModelSim-green?style=for-the-badge" />
  <img src="https://img.shields.io/badge/FPGA%20Tool-Quartus%20Prime-orange?style=for-the-badge" />
</p>

---

## 📐 Schematic  

### 🔝 Top Level  
<img width="1000" height="800" src="https://github.com/user-attachments/assets/917320ae-0039-4363-93be-33a84e807023" />

### 🟢 AHB Slave  
<img width="1000" height="800" src="https://github.com/user-attachments/assets/5509dbbb-ac8d-4aa8-922e-23babe9c5199" />

### 🔵 APB Controller  
<img width="542" height="800" src="https://github.com/user-attachments/assets/5a387ec4-4f63-4ec2-b062-7ce309e6cebe" />

---

## 🧪 Simulation Results  

### 🔹 AHB Master  
<p align="center">
<img width="1000" height="1000" src="https://github.com/SUHANI102003/AMBA_AHB2APB_BRIDGE_DESIGN/blob/main/SIM/AHB_Master_waveform.png" />
</p>

### 🔹 AHB Slave Interface  
<p align="center">
<img width="1000" height="1000" src="https://github.com/SUHANI102003/AMBA_AHB2APB_BRIDGE_DESIGN/blob/main/SIM/AHB_Slave_Interface_sim.png" />
</p>

### 🔹 APB Controller  
<p align="center">
<img width="1000" height="1000" src="https://github.com/SUHANI102003/AMBA_AHB2APB_BRIDGE_DESIGN/blob/main/SIM/APB_controller_sim.png" />
</p>

### 🔹 APB Interface  
<p align="center">
<img width="1000" height="1000" src="https://github.com/SUHANI102003/AMBA_AHB2APB_BRIDGE_DESIGN/blob/main/SIM/APB_Interface_sim.png" />
</p>

### 📝 Single Write  
<p align="center">
<img width="1000" height="1000" src="https://github.com/SUHANI102003/AMBA_AHB2APB_BRIDGE_DESIGN/blob/main/SIM/single_write.png" />
</p>

### 📝 Single Read  
<p align="center">
<img width="1000" height="1000" src="https://github.com/SUHANI102003/AMBA_AHB2APB_BRIDGE_DESIGN/blob/main/SIM/single_read.png" />
</p>

### 📝 Burst Write  
<p align="center">
<img width="1000" height="1000" src="https://github.com/SUHANI102003/AMBA_AHB2APB_BRIDGE_DESIGN/blob/main/SIM/burst_write.png" />
</p>

---

## 📚 References  
[ARM AMBA Specification Rev 2.0](https://developer.arm.com/documentation/ihi0011/latest/)  

---

## 🤝 Contribution  

Contributions are always welcome!  

- Fork the repo 🍴  
- Create a new branch 🌿  
- Commit your changes 💡  
- Open a Pull Request 🚀  

---

## 📜 License  

This project is licensed under the **MIT License**.  
