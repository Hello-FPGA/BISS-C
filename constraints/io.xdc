set_property IOSTANDARD LVCMOS33 [get_ports pl_led]
set_property PACKAGE_PIN J16 [get_ports pl_led]

set_property IOSTANDARD LVCMOS33 [get_ports led0]
set_property PACKAGE_PIN M14 [get_ports led0]

set_property IOSTANDARD LVCMOS33 [get_ports led1]
set_property PACKAGE_PIN M15 [get_ports led1]

#pfi 0 used as external sample clcok source B35_L17_N h20
set_property IOSTANDARD LVCMOS33 [get_ports pfi0]
set_property PACKAGE_PIN H20 [get_ports pfi0]

#biss_ma biss_slo
set_property IOSTANDARD LVCMOS33 [get_ports biss_ma[*]]
#MA output B35_L7_P
set_property PACKAGE_PIN M19 [get_ports biss_ma[0]]
#B35_L9_N
set_property PACKAGE_PIN L20 [get_ports biss_ma[1]]
#B35_L8_P
set_property PACKAGE_PIN M17 [get_ports biss_ma[2]]
#B35_L16_P
set_property PACKAGE_PIN G17 [get_ports biss_ma[3]]
#B35_L5_P
set_property PACKAGE_PIN E18 [get_ports biss_ma[4]]
#B35_L6_P
set_property PACKAGE_PIN F16 [get_ports biss_ma[5]]
#B35_L22_P
set_property PACKAGE_PIN L14 [get_ports biss_ma[6]]
#B35_L21_P
set_property PACKAGE_PIN N15 [get_ports biss_ma[7]]

set_property IOSTANDARD LVCMOS33 [get_ports biss_slo[*]]
#B35_L7_N
set_property PACKAGE_PIN M20 [get_ports biss_slo[0]]
#B35_L9_P
set_property PACKAGE_PIN L19 [get_ports biss_slo[1]]
#B35_L8_N
set_property PACKAGE_PIN M18 [get_ports biss_slo[2]]
#B35_L16_N
set_property PACKAGE_PIN G18 [get_ports biss_slo[3]]
#B35_L5_N
set_property PACKAGE_PIN E19 [get_ports biss_slo[4]]
#B35_L6_N
set_property PACKAGE_PIN F17 [get_ports biss_slo[5]]
#B35_L22_N
set_property PACKAGE_PIN L15 [get_ports biss_slo[6]]
#B35_L21_N
set_property PACKAGE_PIN N16 [get_ports biss_slo[7]]