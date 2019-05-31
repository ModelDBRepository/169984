//genesis

/***************************		MS Model, Version 5.11	**********************
**************************** 	      	MS_cell.g 			***************
Tom Sheehan tsheeha2@gmu.edu	thsheeha@vt.edu	703-538-8361
*************************
	MS_cell.g has only one externally called function: make_MS_cell. That primary 
	function uses the services of the following two local subroutines:
		set_position
		add_channels

******************************************************************************/

include MScell/globals  		// Defines & initializes cell specific parameters

include MScell/addchans	// provides access to add_uniform_channel & add_CaShells 
					// as required by local subroutine add_channels
include MScell/proto  // provides access to make_prototypes required by primary
					// routine make_MS_cell
    	
//************************ Begin Local Subroutines ****************************
//*****************************************************************************

	//************************ Begin function set_position *********************
	//**************************************************************************
	function set_position (cellpath)
		//********************* Begin Local Variables ************************
 		str compt, cellpath
 		float dist2soma,x,y,z
 		//********************* End Local Variables *****************************
 		
 		if (!{exists {cellpath}})
  			echo The current input {cellpath} does not exist (set_position) 
  			return
 		end
 
 		foreach compt ({el {cellpath}/##[TYPE=compartment]})
     		  x={getfield {compt} x}
     		  y={getfield {compt} y}
     		  z={getfield {compt} z}
     		  dist2soma={sqrt {({pow {x} 2 }) + ({pow {y} 2}) + ({pow {z} 2})} }  
     		  setfield {compt} position {dist2soma}
   	        end
	end
	//************************ End function set_position ***********************
	//**************************************************************************

	//************************ Begin function add_channels *********************
	//**************************************************************************
	function add_channels (cellpath)
         str cellpath
		/************************************************************************
		next, to add ion channels the function "add_uniform_channel" is  
		called to insert channels in to the cell with the distance to soma  
		between a(minimum) and b(max) more details can be found in the file 
		"adjust.g"
		MAGIC_NUMBERS_1
		However the question remains: where do the values of a, b, & conductance
		density come from?
		************************************************************************/

		/* add_uniform_channel (from addchans.g)
					channel_Name	a    		b 	density	  */

		// Naf in the soma 
		add_uniform_channel "NaF_channel_D1"   0        16.1e-6	{gNaFprox_D1} {cellpath}
		// Naf in the dendrites
		add_uniform_channel "NaF_channel_D1"   16.1e-6  90e-6 	{gNaFmid_D1}  {cellpath}
		add_uniform_channel "NaF_channel_D1"   90.0e-6  500e-6 	{gNaFdist_D1}  {cellpath} 

		// KaF in the soma and proximal dendrites
		add_uniform_channel "KAf_channel"   0        16.1e-6	{gKAfprox_D1} {cellpath}
		//  KaF in the middel and distal dendrites
		add_uniform_channel "KAf_channel"   16.1e-6  60.5e-6	{gKAfmid_D1}   {cellpath}
		add_uniform_channel "KAf_channel"   60.5e-6  272e-6    {gKAfdist_D1}  {cellpath}
		add_uniform_channel "KAf_channel"   272e-6  1000e-6    {gKAfdist2_D1}  {cellpath}
          
		//  KAs in the soma and proximal dendrites
		add_uniform_channel "KAs_channel"  0         16.1e-6	{gKAsprox_D1} {cellpath}   
		//  KAs in the middle and distal dendrites
		add_uniform_channel "KAs_channel"  16.1e-6  1000.0e-6 	{gKAsdist_D1} {cellpath}
    
		add_uniform_channel "KIR_channel"   0        16.1e-6	 {gKIR_D1}  {cellpath}  
		add_uniform_channel "KIR_channel"   16.1e-6  1000e-6	 {gKIR_D1}  {cellpath}

  		add_uniform_channel "K_DR"          0        16.1e-6     {gKDR_D1}  {cellpath}
		add_uniform_channel "K_DR"          16.1e-6  1000e-6     {gKDR_D1}  {cellpath}
  
		// function add_CaShells is defined in adjust.g
		// to be coupled with N/Q/R Ca2+ channels 
		add_CaShells {CA_BUFF_1}  0 500e-6   {cellpath} 
		// to be coupled with T/L Ca2+ channels 
		add_CaShells {CA_BUFF_2}  0 500e-6  {cellpath} 
		// to be coupled with all Ca2+ channels    
		add_CaShells {CA_BUFF_3}  0 500e-6   {cellpath} 

		/************************************************************************
		the parameters for Pbar of Calcium channels are adopted from Wolf's 
		2005 model. Please note in order to transfer the units into SI unites, 
		all parameters should be multiplied by 1e-2
		************************************************************************/

//		add_uniform_channel "CaQ_channel" 		0 	16e-6	{gCaQ}  {cellpath}
 
		add_uniform_channel "CaR_channel" 		0 	500e-6  {gCaR} {cellpath}
 
		add_uniform_channel "CaN_channel" 		0 	16e-6  	{gCaN_D1}  {cellpath}

		add_uniform_channel "CaL12_channel"        0 	500e-6  {gCaL12_D1}  {cellpath}

		add_uniform_channel "CaL13_channel_D1" 	        0 	500e-6  {gCaL13_D1} {cellpath}

		add_uniform_channel "CaT_channel" 		0 	500e-6  {gCaT} {cellpath}

		add_uniform_channel "BKK_channel" 		0 	500e-6	10 {cellpath}
		add_uniform_channel "SK_channel" 		0 	500e-6  0.5 {cellpath}

	end

 
	//************************ End function add_channels ***********************
	//**************************************************************************
//************************ End Local Subroutines ******************************
//*****************************************************************************

//************************ Begin Primary Routine ******************************
//*****************************************************************************

	//************************ Begin function make_MS_cell *********************
	//**************************************************************************
	function make_MS_cell (cellpath,pfile)
         str cellpath,pfile
         echo {cellpath}
 	// function make_MS_cell is the first call from the primary file (MSsim.g). 
	// Note that the first thing it does is to call make_protypes in proto.g. 
	// These prototypes must be made before the call to add_channels. When the
	// function add_channels is modified (as in msv4.0) to no longer add
	// certain channels (such as K13, KRPI & KRPII), then the respective 
	// make_prototypes calls (i.e. make_KRPII_channel should be deleted as 
	// dead code. That is to say that only those channels shown in add_channels 
	// (above) should have a make prototype in function make_prototypes in
	// proto.g
		make_prototypes					//	see proto.g
//		readcell {pfile} {cellpath} -hsolve	//	see MScell.g
              readcell {pfile} {cellpath}
		set_position {cellpath}					// local call
		add_channels {cellpath}					// local call
	end	
	//************************ End function make_MS_cell ***********************
	//**************************************************************************			
//************************ End Primary Routine ********************************
//*****************************************************************************
