//genesis

/***************************		MS Model, Version 5.2	*********************
**************************** 	  CaL12NOINACT_channel.g 	*********************
		Tom Sheehan tsheeha2@gmu.edu	thsheeha@vt.edu	703-538-8361
******************************************************************************
******************************************************************************/

function create_CaL12NOINACT
	str chanName = "CaL12NOINACT_channel"
	str compPath = "/library"
	int c

	float xmin = -0.1
	float xmax = 0.05
	int 	xdivs = 3000
	float mPower = 1.0
	float hPower = 0.0
	
	float increment = 0.00005	
	float x = -0.1
  	float surf = 0
 	float gMax = 5.5610000e-008  

	float CaL12NOINACT_mTau = 0.0
	float CaL12NOINACT_mInf	= 0.0
	float mvHalfCaL12 = -8.9e-3
	float mkCaL12     = -6.7e-3

	float theta	= 0.0
	float beta	= 0.0
	float beta_exp	= 0.0
	float mA = 0.0
	float mB = 0.0
	float qFactCaL12 	= {3.0/{CaSlow}}
		
	pushe {compPath}

	create tabchannel {chanName}
  	setfield {chanName} Xpower {mPower} Ypower {hPower}
	call {chanName} TABCREATE X {xdivs} {xmin} {xmax}

	for(c = 0; c < {xdivs} + 1; c = c + 1)

		/**************************** Begin CaL12NOINACT_mTau ********************/
		//mA = 0.0398e6*(vMemb + 8.124e-3)./(exp((vMemb + 8.124e-3)/9.005e-3) - 1);
		//mB = 0.99e3*exp(vMemb/31.4e-3);
		//CaL12NOINACT_mTau = 1./(mA + mB) / qFactCaL12;
		theta = 0.0398e6*{ {x} + 8.124e-3}
		beta = {{x} + 8.124e-3}/9.005e-3
		beta_exp = {exp {beta}}
		beta_exp = beta_exp - 1.0
		mA = {{theta}/{beta_exp}}
		
		beta = {{x}/31.4e-3}
		beta_exp = {exp {beta}} 
		mB = 0.99e3*{beta_exp}

		CaL12NOINACT_mTau = {1.0/{mA + mB}}/{qFactCaL12}
		setfield {chanName} X_A->table[{c}] {CaL12NOINACT_mTau}	
		/**************************** End CaL12NOINACT_mTau **********************/		
	
		/**************************** Begin CaL12NOINACT_mInf ********************/
		// CaL12NOINACT_mInf   = 1./(1 + exp((vMemb - mvHalfCaL12)/mkCaL12));
		beta = {{x} - {mvHalfCaL12}}/{mkCaL12}
		beta_exp = {exp {beta}} + 1.0
		CaL12NOINACT_mInf = 1.0/{beta_exp}
		setfield {chanName} X_B->table[{c}] {CaL12NOINACT_mInf}
		/**************************** End CaL12NOINACT_mInf **********************/

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
