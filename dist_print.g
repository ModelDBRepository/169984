//genesis
//net_conn.g - Description of the FS and SP connections to the SP network

//This file sets up the SP-SP connections based on the factor sent to the netconn function



  for(ctrpre = 0; ctrpre < {getglobal numCells_{net}}; ctrpre = {ctrpre + 1})  //loops through presynaptic cells
        xpre={getfield {network}[{ctrpre}]/soma/ x}  //get x location
	ypre={getfield {network}[{ctrpre}]/soma/ y}  //get y location

	for(ctrpost = 0; ctrpost < {getglobal numCells_{net2}}; ctrpost= {ctrpost +1})  //loops through postsynaptic cells

		if ({ctrpre}!={ctrpost}) //only if pre and post synaptic cells are different start connecting                                                                                                 
                   xpost={getfield {network2}[{ctrpost}]/soma/ x} //get x location
		   ypost={getfield {network2}[{ctrpost}]/soma/ y} //get y location

                   dist2parent={{pow {xpost-xpre} 2 } + {pow {ypost-ypre} 2}}   // calculating distance between the cells               
             
