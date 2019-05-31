//genesis

/***************************		MS Model, Version 6	*********************
**************************** 	    	kAf_chanRE.g 			*********************
						Rebekah Evans rcolema2@gmu.edu	
		Tom Sheehan tsheeha2@gmu.edu	thsheeha@vt.edu	703-538-8361
******************************************************************************
******************************************************************************/


/* K A-type Fast channel
 *  * This is a tab channel created from KAf channel data in Tkatch 2000.
 * They are using dissociated medium spiny neurons, and did not specify recording temperature, so I am assuming room temp.
 * Our data matching process showed that the original model from Johanes Hjorth via Kai Du and Tom Sheehan matched closely with the
 * activation and inactivation inf curves, but did not match the activation tau curve very well. This new tab channel uses Alphas and 
 * Betas obtained by matching both the activation inf and tau curves.  The m power according to wolf is 2 (didn't find in Tkatch)
 * The inactivation curve matched well, and the inactivation tau is constant according to wolf (did not see this in Tkatch either). 
*inactivation has been updated with voltage dependence more consistent with current clamp data
 * *************** Rebekah Evans 02/07/10 rcolema2@gmu.edu ********************************/
/*inactivation has been updated with voltage dependence more consistent 
with current clamp data *** Rebekah Evans Aug 2010 rcolema2@gmu.edu **/


function make_KAf_channel
   //include tabchanforms
  //initial parameters for making tab channel
	float Erev = -0.09
	int m_power = 2
        int h_power = 1
	
//Activation constants for alphas and betas (obtained by matching Tkatch 2000)
//units are mV, ms
	float mA_rate = 1.5
	float mA_vhalf = 4
	float mA_slope = -17
	
	float mB_rate = 0.6
	float mB_vhalf = 10
	float mB_slope = 9
		
//Inactivation constants for alphas and betas
//units are mV, ms
	float hA_rate = 0.105
	float hA_vhalf = -121
	float hA_slope = 22
	
	float hB_rate = 0.065
	float hB_vhalf = -55
	float hB_slope = -11
	    
	//table filling parameters	
    float xmin  = -0.1  /* minimum voltage we will see in the simulation */ 
    float xmax  = 0.05  /* maximum voltage we will see in the simulation */ 
    int  xdivsFiner = 3000
    int c = 0
    float increment =1000*{{xmax}-{xmin}}/{xdivsFiner}
    echo "kAf: inc="{increment}"mV"
    float x = -100

      	
    /* make the table for the activation with a range of -100mV - +50mV
     * with an entry for every 10mV
     */
	 
    str path = "KAf_channel" 
    create tabchannel {path} 
    call {path} TABCREATE X {xdivsFiner} {xmin} {xmax} 
    call {path} TABCREATE Y {xdivsFiner} {xmin} {xmax} 
	 
 
    /*fills the tabchannel with values for minf, mtau, hinf and htau,
     *from the files.
     */
    float slow = 1.5  //original data speeded up too much?
    float qfactor=1.5
    for (c = 0; c < {xdivsFiner} + 1; c = c + 1)
		float m_alpha = {sig_form {mA_rate} {mA_vhalf} {mA_slope} {x}}
		float m_beta = {sig_form {mB_rate} {mB_vhalf} {mB_slope} {x}}
		float h_alpha = {sig_form {hA_rate} {hA_vhalf} {hA_slope} {x}}
		float h_beta = {sig_form {hB_rate} {hB_vhalf} {hB_slope} {x}}
   /* 1e-3 converts from ms to sec */		
		setfield {path} X_A->table[{c}] {{slow}*{1e-3/(m_alpha+m_beta)}}
		setfield {path} X_B->table[{c}] {m_alpha/(m_alpha+m_beta)}
		setfield {path} Y_A->table[{c}] {{1e-3/(h_alpha+h_beta)}/{qfactor}}
                setfield {path} Y_B->table[{c}] {h_alpha/(h_alpha+h_beta)}
		x = x + increment
    end
	
			
    /* Defines the powers of m and h in the Hodgkin-Huxley equation*/
    setfield {path} Ek {Erev} Xpower {m_power} Ypower {h_power} 
    tweaktau {path} X 
    tweaktau {path} Y 

end



































