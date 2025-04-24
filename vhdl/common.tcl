vmap -c
source ../osvvm/Scripts/StartUp.tcl

set osvvm_libs $::osvvm::ToolNameVersion
if {[DirectoryExists "VHDL_LIBS/$osvvm_libs/osvvm"] && [DirectoryExists "VHDL_LIBS/$osvvm_libs/osvvm_common"]} {
  puts "OSVVM exists. Skipping."
} else {
  puts "Building OSVVM"
  build ../osvvm/OsvvmLibraries.pro
}

library common_lib
analyze ../common/common_pkg.vhd
puts ""
puts ""