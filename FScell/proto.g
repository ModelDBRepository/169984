//genesis

/**************************** 	      	proto.g 				**********************
Johannes Hjorth, Sriraman Damodaran     **************************************************************
	proto.g contains one primary routine:  
		make_prototypes
 	and one local routine 
		make_cylind_compartment
	these are used by the primary and are not intended for external calls
	The primary function, make_prototypes is called exactly once by FScell.g

******************************************************************************/
include FScell/errorHandler
include FScell/include_channels		// required for calls in make_protypes

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

       	if (!{exists /library})
  	   create neutral /library
  	   disable /library
        else
        end
	pushe /library

        make_cylind_compartment
	//********************* create non-synaptic channels in library ************************
        make_K3132_channel
        make_K13_channel
        make_A_channel
        make_Na_channel
        pope
	//********************* End channels in library ************************

end
//************************ End function make_prototypes ***********************

