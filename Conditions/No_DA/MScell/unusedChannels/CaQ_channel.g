//genesis

/***************************		MS Model, Version 5.2	*********************
**************************** 	  		CaQ_channel.g 			*********************
		Tom Sheehan tsheeha2@gmu.edu	thsheeha@vt.edu	703-538-8361
******************************************************************************
******************************************************************************/

function create_CaQ
	str chanName = "CaQ_channel"
	str compPath = "/library"

	int c = 0	
	float increment = 0.00005	
	float x = -0.1
	int xdivs = 3000
	float xmin = -0.1
	float xmax = 0.05
  	float mPower = 1.0
  	float hPower = 0.0

	float mvHalfCaQ = -9.0e-3
	float mkCaQ = -6.6e-3
	float mInfCaQ= 0.0
	float mTauCaQ = 0.0

	float surf = 0.0
	float qFactCaN = {3.0/{CaSlow}}
	float gMax = 6.0e-008

	float theta = 0.0
	float theta_exp = 0.0

	pushe {compPath}

	create tabchannel {chanName}
  	setfield {chanName} Xpower {mPower} Ypower {hPower}
	call {chanName} TABCREATE X {xdivs} {xmin} {xmax}

	for(c = 0; c < {xdivs} + 1; c = c + 1)
		/************************ Begin CaQ_mTau *********************/
		//mTauCaQ   = 0.377e-3*ones(vDiv+1,1);
		mTauCaQ = 3.77e-004
		setfield {chanName} X_A->table[{c}] {mTauCaQ}
		/************************ End CaQ_mTau ***********************/
		
		/************************ Begin CaQ_mInf *********************/
		//mInfCaQ   = 1./(1 + exp((vMemb - mvHalfCaQ)/mkCaQ));
		theta = {{x} - {mvHalfCaQ}}/{mkCaQ}
		theta_exp = {exp {theta}} + 1.0
		mInfCaQ = 1.0/{theta_exp}
		setfield {chanName} X_B->table[{c}] {mInfCaQ}
		/************************ End CaQ_mInf ***********************/
    	x = x + increment
	end

	tweaktau {chanName} X

  	create ghk {chanName}GHK

  	setfield {chanName}GHK Cout 2 // Carter & Sabatini 2004 uses 2mM, 
											// Wolf 5mM
  	setfield {chanName}GHK valency 2.0
  	setfield {chanName}GHK T {TEMPERATURE}
	
  	setfield {chanName} Gbar {gMax*surf}
  	addmsg {chanName} {chanName}GHK PERMEABILITY Gk	
  	pope 
end

