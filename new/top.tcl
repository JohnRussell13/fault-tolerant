variable dispScriptFile [file normalize [info script]]

proc getScriptDirectory {} {
    variable dispScriptFile
    set scriptFolder [file dirname $dispScriptFile]
    return $scriptFolder
}

set sdir [getScriptDirectory]
cd [getScriptDirectory]

# KORAK#1: Definisanje direktorijuma u kojima ce biti smesteni projekat i konfiguracioni fajl
set resultDir .\/result
file mkdir $resultDir
create_project MBIST $resultDir -part xc7z010clg400-1 -force
set_property board_part digilentinc.com:zybo:part0:1.0 [current_project]
set_property target_language VHDL [current_project]


# KORAK#2: Ukljucivanje svih izvornih fajlova u projekat
add_files -norecurse 	./dsong_pkg.vhd
add_files -norecurse 	./txt_util.vhd
add_files -norecurse 	./elem_sw.vhd
add_files -norecurse 	./fixed_fir.vhd
add_files -norecurse 	./mac.vhd
add_files -norecurse 	./maj3.vhd
add_files -norecurse 	./top.vhd
add_files -norecurse 	./voter.vhd
add_files -fileset constrs_1 ./constr.xdc
add_files -fileset sim_1 ./fix_fir_tb.vhd
update_compile_order -fileset sources_1


# KORAK#3: Pokretanje procesa sinteze
set_property -name {STEPS.SYNTH_DESIGN.ARGS.MORE OPTIONS} -value {-mode out_of_context} -objects [get_runs synth_1]
launch_runs synth_1
wait_on_run synth_1
puts "*****************************************************"
puts "* Sinteza zavrsena! *"
puts "*****************************************************"

# KORAK#4: Pokretanje procesa implementacije
launch_runs impl_1
