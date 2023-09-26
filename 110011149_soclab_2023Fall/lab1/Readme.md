# Lab1 -- Vitis / Vivado Tools installtion & Test

* Environment : Ubuntu_20.04.4_VB
* Board : PYNQ-Z2 ( xc7z020clg400-1 )
* Vitis version: 2022.1 ( vitis_hls / vivado )

## Outline

```
Purpose of Lab1 is let us to familiar with HLS design flow.
By Vitis_HLS , turn C++ code to RTL ip. And then import ip into Vivado , to synthesize , implement and generat bitstream.
Finally , using PYNQ-Z2 to verify design on Jupyter notebook.
( This HLS test design is a 32-bits multiplier. )
```

## What is observed & learned 

```
Observe that 
Learn how to use HLS tool and Integrate it on Vivado.
```

## Screen dump 

### C Synthesis Performance & Utilization ( Vitis HLS )

<img width="682" alt="synth_Performance   Utilization" src="https://github.com/WadeeeL/WadeLien_SOC_LAB/assets/134760983/6160f645-be46-4a8b-8e24-2c4574683045">

###　Utilization　( Vivado )

<img width="762" alt="vivado_utilization" src="https://github.com/WadeeeL/WadeLien_SOC_LAB/assets/134760983/e9ea3d44-294e-4bc5-8843-193a34e45d5c">

### Cosimulation Performance ( Vitis HLS )

<img width="330" alt="co-sim_Performance" src="https://github.com/WadeeeL/WadeLien_SOC_LAB/assets/134760983/6d23b886-af3f-418f-879c-ce0716912c64">

### C Synthesis Interface ( Vitis HLS )

<img width="406" alt="synth_Interface" src="https://github.com/WadeeeL/WadeLien_SOC_LAB/assets/134760983/c0573efe-1621-4de1-899f-8fc4968226a1">

### Co-simulation waveform ( Vivado )

<img width="1205" alt="Design_Co-sim waveform" src="https://github.com/WadeeeL/WadeLien_SOC_LAB/assets/134760983/d1b0f017-45a3-4885-a4c0-5b2b8194db64">
<img width="1203" alt="Testbench_Co-sim waveform" src="https://github.com/WadeeeL/WadeLien_SOC_LAB/assets/134760983/25b2089b-53df-46c6-823f-b56c15ff4258">

### Jupyter Notebook execution results

<img width="723" alt="螢幕擷取畫面 2023-09-22 021440" src="https://github.com/WadeeeL/WadeLien_SOC_LAB/assets/134760983/1af5fc55-7fd7-40a4-899b-8d669dbd4616">
<img width="316" alt="螢幕擷取畫面 2023-09-22 021500" src="https://github.com/WadeeeL/WadeLien_SOC_LAB/assets/134760983/ca7b3533-783d-49fd-82cf-48c4c1f29ee6">

## Some Linux instruction in ubuntu
```
sudo : 讓權限受到限制的使用者，暫時以超級使用者的權限執行特定指令
pwd : 顯示資料夾完整路徑
lsblk : 即list block，列出系統的可用 Block Device，但不會列出RAM disk
cd : 變更目錄
cp : copy
```
