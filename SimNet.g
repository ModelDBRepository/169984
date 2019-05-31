// genesis
//SimNet.g  //Top level file used to run simulation

//include SimGlobals
//str net = {set_net "SP"}
include net
//include SP_output
include MScell/addoutput
include graphics
include LFP

ce /
/*
create spikehistory Ctx.history
setfield Ctx.history ident_toggle 0 filename "Ctx.spikes" initialize 1 leave_open 1 flush 1
//addmsg /input/ Ctx.history SPIKESAVE 
*/

create spikehistory SPcell_D1.history
setfield SPcell_D1.history ident_toggle 0 filename "SPcell_D1.spikes" initialize 1 leave_open 1 flush 1

create spikehistory SPcell_D2.history
setfield SPcell_D2.history ident_toggle 0 filename "SPcell_D2.spikes" initialize 1 leave_open 1 flush 1
int g
for(g = 0; g < {getglobal numCells_SP}; g = {g + 1})
       if ({getfield /SPnetwork/SPcell[{g}]/soma D1} == 1)
       addmsg /SPnetwork/SPcell[{g}]/soma/spike SPcell_D1.history SPIKESAVE
       elif ({getfield /SPnetwork/SPcell[{g}]/soma D1} == 0) 
       addmsg /SPnetwork/SPcell[{g}]/soma/spike SPcell_D2.history SPIKESAVE
       end
end

create spikehistory FScell.history
setfield FScell.history ident_toggle 0 filename "FScell.spikes" initialize 1 leave_open 1 flush 1
addmsg /FSnetwork/FScell[]/soma/spike FScell.history SPIKESAVE

// make the control panel
//make_control

// make the graph to display soma Vm and pass messages to the graph
//make_Vmgraph

//make_netview
//makeOutput ""/{net}"network/"{net}"cell" "/output" 0.01
//make_inview
//add_output_sec 
//add_output_tert

int ctr
//add_output_both
/*
for (ctr=0; ctr<{getglobal numCells_SP}; ctr={ctr+1})

    addglobal str path_c_s{ctr}="Ca_soma_cell"{ctr}".txt"
    addglobal str path_c_t{ctr}="Ca_prim_cell"{ctr}".txt"
    addglobal str path_c_s{ctr}="Ca_sec_cell"{ctr}".txt"
    addglobal str path_c_t{ctr}="Ca_tert_cell"{ctr}".txt"
    //addglobal str path_v_s{ctr}="Vm_sec_cell"{ctr}".txt"
    //addglobal str path_v_t{ctr}="Vm_tert_cell"{ctr}".txt"
    //addglobal str path_v_soma{ctr}="Vm_soma_cell"{ctr}".txt"
   // setfield /output/plot_out filename output/{diskpath}
    setfield /output/CaSomaOutCell{ctr} filename output/"Ca_soma_cell"{ctr}".txt"
    setfield /output/CaPrim2OutCell{ctr} filename output/"Ca_prim_cell"{ctr}".txt"
    setfield /output/CaSec6OutCell{ctr} filename output/"Ca_sec_cell"{ctr}".txt"
    setfield /output/CaTert12OutCell{ctr} filename output/"Ca_tert_cell"{ctr}".txt"
    //setfield /output/VmSec6OutCell{ctr} filename output/"Vm_sec_cell"{ctr}".txt"  
    //setfield /output/VmTert12OutCell{ctr} filename output/"Vm_tert_cell"{ctr}".txt"     
    //setfield /output/VmSomaOutCell{ctr} filename output/"Vm_soma_cell"{ctr}".txt"  
 
end
*/
/*
check_input
for (ctr=0; ctr<{getglobal numCells_SP}; ctr={ctr+1})
    addglobal str in{ctr}="checkInput"{ctr}".txt"
    setfield /output/checkInput{ctr} filename output/"checkInput"{ctr}".txt"
end
*/
//LFP recordings

LFP_all
setfield /output/electrode_all filename output/"electrode_all.txt"
setfield /output/electrode_glut filename output/"electrode_glut.txt"
setfield /output/electrode_gaba filename output/"electrode_gaba.txt"

//colorize
reset
check
//include IF.g
//echo "Network of "{getglobal NX_{net}}" by "{getglobal NY_{net}}" cells with separations "{getglobal SEP_X_{net}}" by "{getglobal SEP_Y_{net}}
//makeOutput "/network/SPcell" {outputName} {vmOutDt}
//uncomment below 2 comments
reset       

step {maxTime} -t



//makeOutput "/network/SPcell" "OUT" 2
//clearOutput {outputName}

//quit

