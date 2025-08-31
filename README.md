<p align="center">
  <h1>🚀 AMBA AHB-to-APB Bridge Design</h1>
  <br>
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
