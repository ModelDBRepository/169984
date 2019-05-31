//genesis
//net.g 

/*
This file sets the netowork of SP cells up by calling the function that
sets up the SP-SP inhibitory network and calling the functions that connect
extrinsic input to the SP network.This file also has the include statements
for the file that prints out the connection of the SP-SP network. 
*/

include protospike
include nsynapses
include Net_parameters
include InputFromFile // External input
include net_conn
include net_func
include Utilities/connect_utility_pre
include Utilities/connect_utility_post

addglobal str cellPath_D1
setglobal cellPath_D1 "/library/SPcell_D1"
addglobal str cellPath_D2
setglobal cellPath_D2 "/library/SPcell_D2"
include MScell/MScellSyn_D1.g // Single SP neuron model with synaptic channels
makeMScellSyn "/library/SPcell_D1"  "MScell/MScell08CM3_D1.p"
make_spike {cellPath_D1}/soma
add_field {cellPath_D1}
setfield {cellPath_D1}/soma/spike thresh 0  abs_refract 0.004  output_amp 1
include MScell/MScellSyn_D2.g // Single SP neuron model with synaptic channels
makeMScellSyn  "/library/SPcell_D2" "MScell/MScell08CM3_D2.p"
make_spike {cellPath_D2}/soma
add_field {cellPath_D2}
setfield {cellPath_D2}/soma/spike thresh 0  abs_refract 0.004  output_amp 1
//D1-0 D2-1
make_net "SP" 0.5

addglobal str cellPath_FS
setglobal cellPath_FS "/library/FScell"
include FScell/FScellSyn.g // Single FS neuron model with synaptic channels
makeFScellSyn {getglobal cellPath_FS} "FScell/FScell.p"
make_spike {cellPath_FS}/soma
add_field {cellPath_FS}
setfield /library/FScell/soma/spike thresh 0  abs_refract 0.004  output_amp 1
make_net "FS" 0.5

//chan_mod "SP" "NR2A" 0.10
chan_mod "SP" "KAf" 0.10
chan_mod_FS "FS" "A" 0.5
//chan_mod "SP" "KIR" 0.2
//chan_mod "FS" "AMPA" 0.10
conn "FS" "FS"
conn "SP" "SP"
//conn "FS" "SP"
//pre "/SPnetwork/SPcell[]" "/SPnetwork/SPcell[]"
//post "/SPnetwork/SPcell[]" "/SPnetwork/SPcell[]"
//pre "/FSnetwork/FScell[]" "/FSnetwork/FScell[]"
//post "/FSnetwork/FScell[]" "/FSnetwork/FScell[]"
include Utilities/gaba_count
