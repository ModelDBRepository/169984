//addoutput.g
	// function for saving parameter in ascii file.  
	//function is made and called in this file
	
//make function 

function sav_disk_asc(diskpath,srcpath,field)
    create asc_file /output/{diskpath}
    setfield /output/{diskpath}   flush 1  leave_open 1 append 1 \
          float_format %0.6g
    useclock /output/{diskpath} 0
    setfield /output/{diskpath} filename output/{diskpath}
    addmsg {srcpath} /output/{diskpath}  SAVE {field}
    call /output/{diskpath} OUT_OPEN
    call /output/{diskpath} OUT_WRITE "time #1" //header
    echo {diskpath}
end
		
		
		
//call function
	
	/*******************save soma information****************************************************
		//sav_disk_asc somaVm{subunit}{stimtype} {cellpath}/soma Vm
	*******************************************************************************************/
	
	/*******************save secondary dendrite parameters**************************************
		//sav_disk_asc dendCa{subunit}{stimtype} {cellpath}/secdend3/{CalciumBuffer_3} Ca  
		//sav_disk_asc NMDACa{subunit}{stimtype} {cellpath}/secdend3/spine_1/head/buffer_NMDA Ca
		//sav_disk_asc spineCa{subunit}{stimtype} {cellpath}/secdend3/spine_1/head/SpineCa Ca
		//sav_disk_asc LspineCa{subunit}{stimtype} {cellpath}/secdend3/spine_1/head/SpineCaL Ca
		//sav_disk_asc Ikblock{subunit}{stimtype} {cellpath}/secdend3/spine_1/head/{subunit}/block Ik
		//sav_disk_asc spineVm{subunit}{stimtype} {cellpath}/secdend3/spine_1/head Vm
	*******************************************************************************************/
 
	/******************save tertiary dendrite information****************************************
		sav_disk_asc dendCa{subunit}{stimtype}3 {cellpath}/tertdend3/{CalciumBuffer_3} Ca
	//	sav_disk_asc spineCa{subunit}{stimtype}3 {cellpath}/tertdend3/tert_dend5/spine_1/head/buffer_NMDA
	//	sav_disk_asc Ikblock{subunit}{stimtype}3 {cellpath}/tertdend3/tert_dend5/spine_1/head/{subunit}/block Ik Ca
	//	sav_disk_asc spineVm{subunit}{stimtype}3 {cellpath}/tertdend3/tert_dend5/spine_1/head Vm
	//	sav_disk_asc IkAMPA{stitype}3 {cellpath}/tertdend3/tert_dend5/spine_1/head/AMPA Ik
	//	sav_disk_asc IkAMPA{stitype}2 {cellpath}/tertdend3/tert_dend5/spine_1/head/AMPA Ik
	*********************************************************************************************/
 
 // this function allows you to put several columns in the same file and name them using the call function series below it.  

function add_output_both
     int ctr	
     str net_n="/SPnetwork/SPcell"
     for(ctr = 0; ctr < 100; ctr = {ctr + 1})
        create asc_file /output/CaSomaOutCell{ctr}
        create asc_file /output/CaPrim2OutCell{ctr}
        create asc_file /output/CaSec6OutCell{ctr}
        create asc_file /output/CaTert12OutCell{ctr}
        create asc_file /output/VmSec6OutCell{ctr}
        create asc_file /output/VmTert12OutCell{ctr}
        create asc_file /output/VmSomaOutCell{ctr}
        setfield /output/CaSomaOutCell{ctr}   flush 1  leave_open 1 append 1 float_format %0.6g
        setfield /output/CaPrim2OutCell{ctr}   flush 1  leave_open 1 append 1 float_format %0.6g
        setfield /output/CaSec6OutCell{ctr}   flush 1  leave_open 1 append 1 float_format %0.6g
        setfield /output/CaTert12OutCell{ctr}   flush 1  leave_open 1 append 1 float_format %0.6g
        setfield /output/VmSec6OutCell{ctr}   flush 1  leave_open 1 append 1 float_format %0.6g
        setfield /output/VmTert12OutCell{ctr}   flush 1  leave_open 1 append 1 float_format %0.6g
        setfield /output/VmSomaOutCell{ctr}   flush 1  leave_open 1 append 1 float_format %0.6g
        useclock /output/CaSomaOutCell{ctr} {CaOutDt}
        useclock /output/CaPrim2OutCell{ctr} {CaOutDt}
        useclock /output/CaSec6OutCell{ctr} {CaOutDt}
        useclock /output/CaTert12OutCell{ctr} {CaOutDt}
        useclock /output/VmSec6OutCell{ctr} {VmOutDt}
        useclock /output/VmTert12OutCell{ctr} {VmOutDt}
        useclock /output/VmSomaCell{ctr} {VmOutDt}

        addmsg {net_n}[{ctr}]/soma/{CA_BUFF_3} /output/CaSec6OutCell{ctr}  SAVE Ca  //not hooked up?
        addmsg {net_n}[{ctr}]/primdend2/{CA_BUFF_3} /output/CaTert12OutCell{ctr}  SAVE Ca  //not hooked up?
        addmsg {net_n}[{ctr}]/secdend6/{CA_BUFF_3} /output/CaSec6OutCell{ctr}  SAVE Ca  //not hooked up?
        addmsg {net_n}[{ctr}]/tertdend12/{CA_BUFF_3} /output/CaTert12OutCell{ctr}  SAVE Ca  //not hooked up?
        addmsg {net_n}[{ctr}]/secdend6 /output/VmSec6OutCell{ctr}  SAVE Vm  //not hooked up?
        addmsg {net_n}[{ctr}]/tertdend12 /output/VmTert12OutCell{ctr}  SAVE Vm  //not hooked up?        
        addmsg {net_n}[{ctr}]/soma /output/VmSomaOutCell{ctr}  SAVE Vm
 
      end
  
end
 
function check_input
	int ctr, ctr2, count=0
     	float gaba	
     	str network="/SPnetwork/SPcell", gc
	for (ctr = 0;ctr< {getglobal numCells_SP}; ctr = {ctr+1})   
		create diffamp /SPnetwork/SPcell[{ctr}]/add
		setfield /SPnetwork/SPcell[{ctr}]/add gain 1 saturation 30000 
        	foreach gc ({el /SPnetwork/SPcell[{ctr}]/##[TYPE=compartment]/GABA})
			addmsg {gc} /SPnetwork/SPcell[{ctr}]/add PLUS Gk  		
		end
	 	create asc_file /output/checkInput{ctr}
		setfield /output/checkInput{ctr}   flush 1  leave_open 1 append 1 float_format %0.6g	
		useclock /output/checkInput{ctr} 1e-3
		addmsg /SPnetwork/SPcell[{ctr}]/add /output/checkInput{ctr} SAVE output  
   	end
end

function add_output_sec 

    create xform /Cadata [265,50,400,460]
    create xlabel /Cadata/label -hgeom 5% -label {graphlabel}
    create xgraph /Cadata/Calevel -hgeom 80% -title "Ca2+ level sec3 Control" -bg white
    setfield ^ XUnits sec YUnits M
    setfield ^ xmax {tmax} ymin {1e-05} ymax {50e-05}
    //makegraphscale /Cadata/Calevel
    addmsg /SPnetwork/SPcell[0]/secdend6/{CA_BUFF_3} /Cadata/Calevel PLOTSCALE \
	Ca *"1 " *black 1 0
/*
    addmsg /SPnetwork/SPcell[1]/secdend3/{CA_BUFF_3} /Cadata/Calevel PLOTSCALE \
	Ca *"2 " *red 1 0
    addmsg /SPnetwork/SPcell[2]/secdend3/{CA_BUFF_3} /Cadata/Calevel PLOTSCALE \
	Ca *"3 " *blue 1 0
    addmsg /SPnetwork/SPcell[3]/secdend3/{CA_BUFF_3} /Cadata/Calevel PLOTSCALE \
	Ca *"4 " *green 1 0
*/  
  xshow /Cadata

end
   
function add_output_tert 
    
    create xform /Cadata2 [265,50,400,460]
    create xlabel /Cadata2/label -hgeom 5% -label {graphlabel}
    create xgraph /Cadata2/Calevel -hgeom 80% -title "Ca2+ level tert1 Control" -bg white
    setfield ^ XUnits sec YUnits M
    setfield ^ xmax {tmax} ymin {1e-05} ymax {50e-05}
    //makegraphscale /Cadata2/Calevel
    addmsg /SPnetwork/SPcell[0]/tertdend12/{CA_BUFF_3} /Cadata2/Calevel PLOTSCALE \
	Ca *"1 " *black 1 0
/*
    addmsg /SPnetwork/SPcell[1]/tertdend1/{CA_BUFF_3} /Cadata2/Calevel PLOTSCALE \
	Ca *"2 " *red 1 0
    addmsg /SPnetwork/SPcell[2]/tertdend1/{CA_BUFF_3} /Cadata2/Calevel PLOTSCALE \
	Ca *"3 " *blue 1 0
    addmsg /SPnetwork/SPcell[3]/tertdend1/{CA_BUFF_3} /Cadata2/Calevel PLOTSCALE \
	Ca *"4 " *green 1 0
*/    
  xshow /Cadata2

end
   
/*

function add_output_tert
	create asc_file /output/plot_out
	setfield /output/plot_out   flush 1  leave_open 1 append 1 \
          float_format %0.6g
    useclock /output/plot_out 1
    addmsg {cellpath}/tertdend3/tert_dend3/{CA_BUFF_3} /output/plot_out  SAVE Ca  //not hooked up?
    addmsg {cellpath}/tertdend3/tert_dend3/spine_1/head/buffer_NMDA /output/plot_out  SAVE Ca
    //addmsg {cellpath}/tertdend3/tert_dend3/tert_dend5/spine_1/head/{subunit}/block /output/plot_out  SAVE Ik
    addmsg {cellpath}/tertdend3/tert_dend3/spine_1/head/spineCaL /output/plot_out  SAVE Ca
	addmsg {cellpath}/tertdend3/tert_dend3/spine_1/head/spineCa /output/plot_out  SAVE Ca
    //addmsg {cellpath}/tertdend3/tert_dend3/spine_1/head	/output/plot_out SAVE Vm
	addmsg {cellpath}/soma /output/plot_out  SAVE Vm
	call /output/plot_out OUT_OPEN
	call /output/plot_out OUT_WRITE "time  CaDend CaNMDA   SpineLtype	SpineCa	SomaVm" //header
end

*/

/*this part goes in a sim file and calls the add_ouput file above.    
	str diskpath 
	add_output_sec
	// open file for 1AP, then run sim
	stimtype="1APnegsec"
	diskpath=(subunit)@(stimtype)@".txt"
	echo {diskpath}
	setfield /output/plot_out filename output/{diskpath}
		call /output/plot_out OUT_OPEN
		call /output/plot_out OUT_WRITE "time	-20" 
	reset
	include 1APnegsec.g
*/
   
   
   
