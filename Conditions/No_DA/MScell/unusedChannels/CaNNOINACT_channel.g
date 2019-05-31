//genesis

/***************************		MS Model, Version 5.2	*********************
**************************** 	  CaNNOINACT_channel.g 		*********************
		Tom Sheehan tsheeha2@gmu.edu	thsheeha@vt.edu	703-538-8361
******************************************************************************
******************************************************************************/

function create_CaNNOINACT
	str chanName = "CaNNOINACT_channel"
	str compPath = "/library"

	int c = 0	
	float increment = 0.00005	
	float x = -0.1
	int xdivs = 3000
	float xmin = -0.1
	float xmax = 0.05
  	float mPower = 1.0
  	float hPower = 0.0

	float mvHalfCaN = -8.7e-3
	float mkCaN = -7.4e-3
	float mTauCaNNOINACT = 0.0
	float mInfCaNNOINACT = 0.0

	float theta	= 0.0
	float beta	= 0.0
	float beta_exp	= 0.0
	float mA	= 0.0
	float mB	= 0.0
	float surf = 0.0
	int qFactCaN = {3.0/{CaSlow}}
	float gMax = 7.9e-008

	pushe {compPath}

	create tabchannel {chanName}
  	setfield {chanName} Xpower {mPower} Ypower {hPower}
	call {chanName} TABCREATE X {xdivs} {xmin} {xmax}

	for(c = 0; c < {xdivs} + 1; c = c + 1)
		/****************** Begin CaNNOINACT_mTau ********************/
		// mA = 0.03856e6*(vMemb + 17.19e-3)./
		//                      (exp((vMemb + 17.19e-3)/15.22e-3)-1);
		// mB = 0.3842e3*exp(vMemb/23.82e-3);
		// mTauCaN = (1./(mA + mB)) / qFactCaN;

		theta = 0.03856e6*{ {x} + 17.19e-3}
		beta = {{x}  + 17.19e-3}/15.22e-3
		beta_exp = {exp {beta}}
		beta_exp = beta_exp - 1.0
		mA = {{theta}/{beta_exp}}

		beta = {{x}/23.82e-3}
		beta_exp = {exp {beta}} 
		mB = 0.3842e3*{beta_exp}

		mTauCaNNOINACT = {1/{mA + mB}}/{qFactCaN}		
		setfield {chanName} X_A->table[{c}] {mTauCaNNOINACT}
		/***************** End CaNNOINACT_mTau ***********************/
	
		/***************** Begin CaNNOINACT_mInf *********************/
		// mInfCaN   = 1./(1 + exp((vMemb - mvHalfCaN)/mkCaN));
		beta = {{x} - {mvHalfCaN}}/{mkCaN}
		beta_exp = {exp {beta}} + 1.0
		mInfCaNNOINACT = 1.0/{beta_exp}
		setfield {chanName} X_B->table[{c}] {mInfCaNNOINACT}
		/***************** End CaNNOINACT_mInf ***********************/
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
