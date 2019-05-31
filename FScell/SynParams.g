//genesis
//SynParams.g

	str AMPAname = "AMPA"
	float EkAMPA = 0.0
        float AMPAtau1 = 0.67e-3
        float AMPAtau2 = 2e-3 
        float AMPAgmax = 364e-12 //Gittis et al

        str GABAname = "GABA"
        float GABAtau1 = 1.33e-3    // From Galarreta and Hestrin 1997 
        float GABAtau2 = 4e-3    //(used in Wolfs model)
        float EkGABA = -0.060
        float GABAgmax = 50e-12  //750e-12Modified Koos 2004 (Wolf uses 435e-12)

