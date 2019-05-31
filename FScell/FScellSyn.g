//genesis
//FScellSyn.g
//This routine takes the FScell without synapses, and adds synapses

include FScell/FScell.g                 //FScell without synapses
include FScell/SynParams.g               //parameters on synaptic channels
include FScell/channels/synaptic_channel.g // function to make non nmda synaptic channels in library
include FScell/AddSynapticChannels.g	// contains functions to add channels to compartments

function makeFScellSyn (cellname,pfile)
   str cellname,pfile

   str CompName

   make_FS_cell {cellname} {pfile}

	//************* create synaptic channels in library *********
	pushe /library

  	make_synaptic_channel  {AMPAname} {AMPAtau1} {AMPAtau2} {AMPAgmax} {EkAMPA}
  	make_synaptic_channel  {GABAname} {GABAtau1} {GABAtau2} {GABAgmax} {EkGABA}

        pope {cellname}
	
   //********************* end synaptic channels in library **************

      foreach CompName ({el {cellname}/##[TYPE=compartment]}) 
        addSynChannel  {CompName} {AMPAname} {AMPAgmax}
        addSynChannel  {CompName} {GABAname} {GABAgmax}
      end


end
