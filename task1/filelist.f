alu.sv
randtrans.sv
alu_test.sv
top.sv

# basic flags that we were using the previous labs as well 
-sverilog -timescale=1ns/10ps 


# Enable Coverage
-cm line+tgl+cond+branch+fsm+assert


##this the used commands in terminal
## vcs -full64 -f filelist.f -o simv ; ./simv -cm line+cond+fsm+branch+tgl 
##  dve -cov -dir simv.vdb & 