# Computer-Organization
Use icarus-Verilog (iVerilog) to compile
- Install icarus-Verilog and gtkwave
```
cd <dir>
iverilog -o <filename>.vvp <modualA>.v <moduleB>.v ... <testbench>.v
vvp <filename>.vvp
gtkwave <filename>.vcd (or double click <filename>.vcd directly)
``` 