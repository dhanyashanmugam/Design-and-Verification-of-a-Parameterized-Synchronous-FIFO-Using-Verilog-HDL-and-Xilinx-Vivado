# Clock
create_clock -name clk -period 10.000 [get_ports clk]

# Input maximum delays
set_input_delay -clock clk -max 2.000 [get_ports {data_in[*]}]
set_input_delay -clock clk -max 2.000 [get_ports {cs we re rst}]

# Input minimum delays
set_input_delay -clock clk -min 0.000 [get_ports {data_in[*]}]
set_input_delay -clock clk -min 0.000 [get_ports {cs we re rst}]

# Output maximum delays
set_output_delay -clock clk -max 2.000 [get_ports {data_out[*]}]
set_output_delay -clock clk -max 2.000 [get_ports {full empty}]

# Output minimum delays
set_output_delay -clock clk -min 0.000 [get_ports {data_out[*]}]
set_output_delay -clock clk -min 0.000 [get_ports {full empty}]

# Learning-only configuration assumption
set_property CFGBVS GND [current_design]
set_property CONFIG_VOLTAGE 1.8 [current_design]