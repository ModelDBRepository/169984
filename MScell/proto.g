//genesis

/***************************		MS Model, Version 5.12	**********************
**************************** 	      	proto.g 				**********************
Tom Sheehan tsheeha2@gmu.edu	thsheeha@vt.edu	703-538-8361
*******************************************************************************
	proto.g contains one primary routine:  
		make_prototypes
 	and two local routines 
		make_cylind_compartment
		make_spines - this one needs much work
	these are used by the primary and are not intended for external calls
	The primary function, make_prototypes is called exactly once by MSsim.g
AB: removed CaNNOINACT_channel and CaL12NOINACT_channel by combining with inactivating channels
AB: deleted CaQ because no evidence for such in SP, and doesn't contribute much anyway
AB: no longer making naP in the library since it is not used, and has been moved to a different directory
******************************************************************************/

include MScell/include_channels.g		// required for calls in make_protypes

//************************ Begin Local Subroutines ****************************

	//********************* Begin function make_cylind_compartment *************
	function make_cylind_compartment
		if (!{exists compartment})
			echo "COMPARTMENT DID NOT EXIST PRIOR TO CALL TO:"
			echo 			"make_cylind_compartment"
			create	compartment compartment
                        addfield compartment position   // add a new field "postion" to store distance to soma
		end

	setfield compartment 		\ 
     		Em         {ELEAK} 	\
      	        initVm     {EREST_ACT} 	\
		inject		0.0 	\
      	        position    0.0
	end
	//************************ End function make_cylind_compartment ************

	//**************************************************************************

//************************ End Local Subroutines ******************************
//*****************************************************************************

//************** Begin function make_prototypes (primary routine) *************

function make_prototypes

  	create neutral /library
  	disable /library
	pushe /library

        make_cylind_compartment

	//********************* create non-synaptic channels in library ************************
       //voltage dependent Na and K channels
 	make_NaF_channel_D1
        make_NaF_channel_D2 	
//	make_NaP_channel	
	make_KAf_channel		
	make_KAs_channel	
	make_KIR_channel	
	make_K_DR_channel  

       //voltage dependent Ca channels
 	create_CaL12 
	create_CaL13_D1	
        create_CaL13_D2
	create_CaN
//	create_CaQ
	create_CaR
 	create_CaT

       //Ca dependent K channels
	make_BKK_channel
	make_SK_channel
	//********************* End channels in library ************************

end
//************************ End function make_prototypes ***********************



