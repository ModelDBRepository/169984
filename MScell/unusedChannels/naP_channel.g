//genesis

/***************************		MS Model, Version 5.2	*********************
**************************** 	    	naP_channel.g 			*********************
		Tom Sheehan tsheeha2@gmu.edu	thsheeha@vt.edu	703-538-8361
******************************************************************************
******************************************************************************/



/* Na Persistent channel
 *	In the original program written by Johanes Hjorth a set of MatLab 
 *	routines in striatum/mspn/vectMakers opened a set of text (data) files in 
 *	striatum/mspn/tau_tables and used those to create a set of of text (data)
 * files in striatum/mspn/channels/vecs.
 * The product of this sequence was then opened by a set of genesis
 *	routines in striatum/mspn/channels to populate an approprite set of tabchannels
 * An example is as follows
 *		striatum/mspn/vectMakers/makeNaPtable.m reads:
 *				striatum/mspn/tau_tables/vtau_nap.txt
 *		and then writes:
 *				striatum/mspn/channels/vecs/nap_taum.txt	
 *				striatum/mspn/channels/vecs/nap_tauh.txt
 *				striatum/mspn/channels/vecs/nap_minf.txt
 *				striatum/mspn/channels/vecs/nap_hinf.txt
 *		Later in the running code control shifts to function make_NaP_channel
 *		(in striatum/mspn/channels/naP_channel.g). This function will read those 
 * 	same four files and use them to create the tabchannel NaP_channel
 *
 * In the rework by Kai_Du the MatLab files are remeoved but their product (the
 * four data files noted above are retained.
 *
 * This revision moves the MatLab calculations to the .g file that is creating
 * the tabchannel and removes the data files (four for each channel). In the example 
 * case given above directory vecs has been deleted which removes nap_taum.txt etc,
 * and function make_NaP_channel has been modified to calculate the data in those 
 * files and place it directly into the appropritate tabchannel 
 *************** Tom Sheehan 1/10/09	703-538-8361********************************/
 
function make_NaP_channel 

    /*reversal potential of sodium */   
    float Erev = 0.05 
    
    str path = "NaP_channel" 

    float xmin  = -0.1  /* minimum voltage we will see in the simulation */  
    float xmax  = 0.05  /* maximum voltage we will see in the simulation */ 
    int  xdivs = 14     /* the number of divisions between -0.1 and 0.04 */ 
    int xdivsFiner = 3000
    int c = 0
    float minf = 0
    float hinf = 0
    float htau = 0
    float mtau = 0
    
    /* Begin values from Hjorth: striatum/mspn/vectMakers/makeNaPtable.m */
    float mvhalf = -52.6	//(mV) Magistretti 1999, Fig 4 
    float mslope = -4.6		//(mV) Magistretti 1999, Fig 4 
    float mshift =  0.0	    	
    float hvhalf = -48.8	//(mV) Magistretti 1999, Fig 4 
    float hslope =  10.0	//(mV) Magistretti 1999, Fig 4 
    float hshift =  0.0	 
    /** End values from Hjorth: striatum/mspn/vectMakers/makeNaPtable.m **/
        
 	 /****** Begin vars used to enable genesis calculations ********/
    float increment = 0.05
    float x = -100.00
    float numerator = 0.0
    float denominator = 0.0
    float theta = 0.0
    float exp_theta = 0.0
    float neg_one = -1.0
 	 /****** End vars used to enable genesis calculations **********/    
	
    								
    								
    //make the table for the activation with a range of -100mV - +40mV
    //with an entry for every 10mV
    create tabchannel {path} 
    call {path} TABCREATE X {xdivsFiner} {xmin} {xmax} 
    call {path} TABCREATE Y {xdivsFiner} {xmin} {xmax} 

    // calculate values for minf, mtau, hinf and htau. Each iteration of the for
    // loop calculates those values using an x that begins with -100 and increments
    // by 0.05 with each loop     
    for(c = 0; c < {xdivsFiner} + 1; c = c + 1)
    
    	 	//The equation for htau is a basic fit of the original curve from Johanes
    	 	//Matlab function found in striatum/mspn/vectMakers/makeNaPtable.m
         htau = -3.4566e-008*x*x*x*x -4.7314e-007*x*x*x + 0.00025297*x*x -0.0087294*x + 0.77324
         
			//calculate Hodgkin Huxley hinf -> 1/(1 + exp(x - mvhalf + mshift)/mslope)
	 		numerator = x - hvhalf + hshift  	   	
	 		theta = numerator/hslope	 	 	
	 		exp_theta = {exp {theta}} 		 	 	
	 		denominator = 1.0 + exp_theta	 	
	 		hinf = 1.0/denominator
	 		
         //calculate Hodgkin Huxley minf -> 1/(1 + exp(x - mvhalf + mshift)/mslope)
	 		numerator = x - mvhalf + mshift  	   	
	 		theta = numerator/mslope	 	 	
	 		exp_theta = {exp {theta}} 		 	 	
	 		denominator = 1.0 + exp_theta	 	
	 		minf = 1.0/denominator
         
     	 	//The equation for mtau is an exact fit of the original curve from Johanes
    	 	//Matlab function found in striatum/mspn/vectMakers/makeNaPtable.m        
         if (c < 1410)
         	//mtau = (0.025 + 0.14*exp((x + 40.0) / 10))
         	numerator = x + 40.0    
         	theta = numerator/10
         	exp_theta = {exp {theta}}
         	mtau = 0.025 + 0.14 * {exp_theta}
         	mtau = 1e-3 * mtau      	
         else
         	//mtau = (0.02 + 0.145*exp( -(x + 40.0)) / 10))
         	numerator = x + 40.0
         	numerator = neg_one * numerator        	
         	theta = numerator/10
         	exp_theta = {exp {theta}}
         	mtau = 0.025 + 0.145 * {exp_theta}
         	mtau = 1e-3 * mtau
         end
         
         setfield {path} Y_A->table[{c}] {htau}	         
         setfield {path} Y_B->table[{c}] {hinf}                
         setfield {path} X_A->table[{c}] {mtau}
         setfield {path} X_B->table[{c}] {minf}
         
         x = x + increment
    end
  
    //Define the powers of m and h in the Hodgkin-Huxley equation
    setfield {path} Ek {Erev} Xpower 1 Ypower 1 


    //fill the tables with the values of A and B
    //calculated from tau and n_inf
    tweaktau {path} X 
    tweaktau {path} Y 
end



































