# KV260 Phase 5 Physicalization constraints
# ext_irq_npu_trigger[7:0] routed to the PMOD GPIO header (3.3V bank)
# PMOD pins on KV260 carrier:
#   HDA11 HDA12 HDA13 HDA14 HDA15 HDA16 HDA17 HDA18

set_property PACKAGE_PIN H12 [get_ports {ext_irq_npu_trigger[0]}]
set_property PACKAGE_PIN E10 [get_ports {ext_irq_npu_trigger[1]}]
set_property PACKAGE_PIN D10 [get_ports {ext_irq_npu_trigger[2]}]
set_property PACKAGE_PIN C11 [get_ports {ext_irq_npu_trigger[3]}]
set_property PACKAGE_PIN B10 [get_ports {ext_irq_npu_trigger[4]}]
set_property PACKAGE_PIN E12 [get_ports {ext_irq_npu_trigger[5]}]
set_property PACKAGE_PIN D11 [get_ports {ext_irq_npu_trigger[6]}]
set_property PACKAGE_PIN B11 [get_ports {ext_irq_npu_trigger[7]}]

set_property IOSTANDARD LVCMOS33 [get_ports {ext_irq_npu_trigger[*]}]
set_property SLEW SLOW [get_ports {ext_irq_npu_trigger[*]}]
set_property DRIVE 4 [get_ports {ext_irq_npu_trigger[*]}]

set_property BITSTREAM.CONFIG.OVERTEMPSHUTDOWN ENABLE [current_design]
