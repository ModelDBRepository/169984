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
 function add_output_sec 
     int ctr	
     str net_n="/SPnetwork/SPcell"
     create asc_file /output/plot_out
	setfield /output/plot_out   flush 1  leave_open 1 append 1 \
          float_format %0.6g
    useclock /output/plot_out 1
 for(ctr = 0; ctr < 10; ctr = {ctr + 1})
    addmsg {net_n}[{ctr}]/secdend3/{CA_BUFF_3} /output/plot_out  SAVE Ca  //not hooked up?
    addmsg {net_n}[{ctr}]/soma /output/plot_out  SAVE Vm
    addmsg {net_n}[{ctr}]/tertdend1/{CA_BUFF_3} /output/plot_out  SAVE Ca  //not hooked up?
    //addmsg {cellpath}/secdend3/spine_1/head/buffer_NMDA /output/plot_out  SAVE Ca
end
    //addmsg {cellpath}/secdend3/tert_dend5/spine_1/head/{subunit}/block /output/plot_out  SAVE Ik
    //addmsg {cellpath}/secdend3/spine_1/head/spineCaL /output/plot_out  SAVE Ca
	//addmsg {cellpath}/secdend3/spine_1/head/spineCa /output/plot_out  SAVE Ca
    //addmsg {cellpath}/secdend3/spine_1/head /output/plot_out SAVE Vm
	
	call /output/plot_out OUT_OPEN
	call /output/plot_out OUT_WRITE "time  CaDend  	SomaVm" //header
end
   
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
   
   
   
