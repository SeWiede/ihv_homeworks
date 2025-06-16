
all:
	vsim -c -do compile_questa.do
	vcover report -details -html avmm_mem.ucdb

clean:
	rm -rf avmm_mem.ucdb 
	rm -rf certe_dump.xml
	rm -rf covhtmlreport
	rm -rf transcript
	rm -rf vsim.wlf
	rm -rf work

wave:
	vsim vsim.wlf -do wave.do
