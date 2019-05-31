//genesis
//MScellSpine.g
//This routine takes the MScell without synapses, and adds synapses

include MScell/MScell.g                 //MScell without synapses
include MScell/SynParams.g               //parameters on synaptic channels
include MScell/channels/nmda_channel.g   //function to make nmda channel, either GHK or not, in library
include MScell/channels/synaptic_channel.g // function to make non nmda synaptic channels in library
include MScell/AddSynapticChannels.g	// contains functions to add channels to compartments
include MScell/spines.g           //creates spines, puts channels & calcium in spines


function make_MS_cell_spine (cellname,pfile)
   str cellname,pfile

   str CompName

   make_MS_cell {cellname} {pfile}

	//************* create synaptic channels in library *********
	pushe /library

  	make_synaptic_channel  {AMPAname} {AMPAtau1} {AMPAtau2} {AMPAgmax} {EkAMPA}
  	make_NMDA_channel    {NMDAname} {EkNMDA} {Kmg} {NMDAtau2} {NMDAgmax} {ghk_yesno}
	make_synaptic_channel  {GABAname} {GABAtau1} {GABAtau2} {GABAgmax} {EkGABA}


	make_spines

        pope {cellname}
	
   //********************* end synaptic channels in library **************


  //**************SPINES*************************/
    /* these functions needs to be modified.  The following 3 should be optional
        1. allow for putting synaptic channels on spines in library
        2. use new calcium functions and optionally create such in spine
        3. possibly vdep channels in the spines
    */

	//add_spines_evenly  {cellname} spine   310.0e-6    320.0e-6       0.1
	add_spines_evenly  {cellname} spine   16.1e-6   200.0e-6       0.1

end
