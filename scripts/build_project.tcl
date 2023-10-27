
if { [info exists ::env(vivadoprj)] } {
set vivadoprj $::env(vivadoprj)
}

# get script file path
namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}

variable script_folder
set script_folder [_tcl::get_script_folder]
set repo_folder [file normalize "$script_folder/.."]

# add board file search path
set_param board.repoPaths [file normalize "$repo_folder/boards"]

# check folder existence
if {[file exists $repo_folder/prj] != 1} {
	file mkdir $repo_folder/prj
}

# get system clock, so we can recreate the project with current time
# system spi clock 
set systemTime  [clock seconds]
set system_time [clock format $systemTime -format {%Y%m%d_%H%M}]

# ! Should check project dir existence, and prompt for overwriten
if {[file exists $repo_folder/prj/[set vivadoprj $vivadoprj]_$system_time] != 1} {
	file mkdir $repo_folder/prj/[set vivadoprj $vivadoprj]_$system_time
}
cd $repo_folder/prj/[set vivadoprj $vivadoprj]_$system_time
source $script_folder/prj_$vivadoprj.tcl

# add shared ip search path
set_property IP_REPO_PATHS [list \
	[file normalize [file join $repo_folder IP]] \
	
] [current_project]
update_ip_catalog -rebuild

source $script_folder/bd_$vivadoprj.tcl

# upgrade_ips if needed
upgrade_ip [get_ips]
regenerate_bd_layout
save_bd_design

# generte wrapper
set bd_file [get_files $design_name.bd]
make_wrapper -files $bd_file -top 
set bd_dir [file dirname $bd_file]
add_files [glob -nocomplain "$bd_dir/hdl/*.v"]

if { [info exists ::env(GENERATE_BIT)] } {
set GENERATE_BIT $::env(GENERATE_BIT)
}

if {$GENERATE_BIT == "COMPILE"} {
	source $script_folder/release.tcl
}