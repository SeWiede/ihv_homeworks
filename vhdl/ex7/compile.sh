# LAB-PC
#gcc -shared -m32 -fPIC -std=c99 -I /opt/HDL/modelsim_de/modelsim_dlx/include/ -Wall -o shared.so shared.c
gcc -shared -fPIC -std=c99 -I /opt/questa_core_prime_22.4-for_quartus22.1std/mentor/2022-23/RHELx86/QUESTA-CORE-PRIME_22.4a/questasim/include/ -Wall -o shared.so shared.c
# WSL
#gcc -shared -m32 -I /mnt/c/modelsim/intel_20.3/modelsim_ase/include -Wall -o shared.so shared.c
