set_global_assignment -entity "pll_100MHz" -library "lib_pll_100MHz" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "pll_100MHz" -library "lib_pll_100MHz" -name IP_TOOL_VERSION "22.1"
set_global_assignment -entity "pll_100MHz" -library "lib_pll_100MHz" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_pll_100MHz" -name SPD_FILE [file join $::quartus(sip_path) "pll_100MHz.spd"]

set_global_assignment -library "lib_pll_100MHz" -name MISC_FILE [file join $::quartus(sip_path) "pll_100MHz_sim/pll_100MHz.vo"]
