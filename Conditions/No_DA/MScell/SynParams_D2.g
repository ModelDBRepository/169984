//genesis
//SynParams.g

	str AMPAname = "AMPA"
	float EkAMPA = 0.0
        float AMPAtau1 = 1.1e-3
        float AMPAtau2 = 5.75e-3 
        float AMPAgmax = 87.2e-12 //593e-12 keeping with 2.75/1 NMDA/AMPA ratio

        str GABAname = "GABA"
        float GABAtau1 = 0.75e-3    // From Galarreta and Hestrin 1997 
        float GABAtau2 = 3.65e-3    //(used in Wolfs model)
        float EkGABA = -0.060
        float GABAgmax = 450e-12  //750e-12Modified Koos 2004 (Wolf uses 435e-12)

	int GABA2Spine = 1                                // = 0, No GABA; 
                                                  //   1, add GABA to spine head
                                                  //   2, add GABA to spine neck
	
	int addCa2Spine = 1		// 0, no ca channels in spine, 
					//1, yes ca channels in spine (non-synaptic)
	int NMDABufferMode = 0          // 1, connect both NMDA and AMPA calcium to NMDA_buffer
                                     // 0, connect only NMDA currents to NMDA_buffer

/********allows for changing NMDA subunit easily*************/
include MScell/parametersA_D2.g
