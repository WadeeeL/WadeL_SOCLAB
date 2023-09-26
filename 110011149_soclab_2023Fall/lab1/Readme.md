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

## Test result by Jupyter Notebook

<img width="723" alt="螢幕擷取畫面 2023-09-22 021440" src="https://github.com/WadeeeL/WadeLien_SOC_LAB/assets/134760983/1af5fc55-7fd7-40a4-899b-8d669dbd4616">
<img width="316" alt="螢幕擷取畫面 2023-09-22 021500" src="https://github.com/WadeeeL/WadeLien_SOC_LAB/assets/134760983/ca7b3533-783d-49fd-82cf-48c4c1f29ee6">

## Linux instruction in ubuntu
```
sudo : 讓權限受到限制的使用者，暫時以超級使用者的權限執行特定指令
pwd : 顯示資料夾完整路徑
lsblk : 即list block，列出系統的可用 Block Device，但不會列出RAM disk
cd : 變更目錄
cp : copy
```
