//genesis

/***************************		MS Model, Version 5.2	*********************
**************************** 	  		CaR_channel.g 			*********************
		Tom Sheehan tsheeha2@gmu.edu	thsheeha@vt.edu	703-538-8361
******************************************************************************
max cond is now a parameter in globals, though use in this function is irrelevant
******************************************************************************/

function create_CaR
	str chanName = "CaR_channel"
	str compPath = "/library"

	int c = 0	
	int xdivs = 3000

	float x = -0.1
	float xmin = -0.1
	float xmax = 0.05
        float increment ={{xmax}-{xmin}}/{xdivs}
        echo "CaR increment:" {increment} "V"
  	float mPower = 1.0
  	float hPower = 1.0

	float mvHalfCaR = -10.3e-3
	float mkCaR     = -6.6e-3
	float hvHalfCaR = -33.3e-3
	float hkCaR     = 17e-3

	float mTauCaR = 1.7e-003
	float mInfCaR = 0.0
	float hTauCaR = 0.0
	float hInfCaR = 0.0

	float surf = 0.0
	float gMax = 2.6e-007

	float theta = 0.0
	float theta_exp = 0.0

	create tabchannel {chanName}
  	setfield {chanName} Xpower {mPower} Ypower {hPower}
	call {chanName} TABCREATE X {xdivs} {xmin} {xmax}
   call {chanName} TABCREATE Y {xdivs} {xmin} {xmax}

	for(c = 0; c < {xdivs} + 1; c = c + 1)
		/************************ Begin CaR_mTau *********************/
		// mTauCaR = 1.7e-3*ones(vDiv+1,1); 
		mTauCaR = 1.7e-003
		setfield {chanName} X_A->table[{c}] {mTauCaR}
		/************************ End CaR_mTau ***********************/
		
		/************************ Begin CaR_mInf *********************/
		//mInfCaR   = 1./(1 + exp((vMemb - mvHalfCaR)/mkCaR));
		theta = {{x} - {mvHalfCaR}}/{mkCaR}
		theta_exp = {exp {theta}} + 1.0
		mInfCaR = 1.0/{theta_exp}
		setfield {chanName} X_B->table[{c}] {mInfCaR}
		/************************ End CaR_mInf ***********************/

		/************************ Begin CaR_hTau *********************/
		//genCarTauH = nfCarTauH * 1e-3 / qFactCaR;
		//genCarV = nfCarV * 1e-3;
		//genCarVmax = max(nfCarV * 1e-3);
		//genCarVmin = min(nfCarV * 1e-3);
		//genCarVxdiv = length(nfCarV) - 1;
		//hTauCaR = interp1(genCarV, genCarTauH, vMemb,'pchip');
		//hTauCaR(find(vMemb < min(genCarV))) = 
		//					genCarTauH(find(genCarV==min(genCarV)));
		//hTauCaR(find(vMemb > max(genCarV))) = 
		//					genCarTauH(find(genCarV==max(genCarV))); 
		if(x <= -0.03)
			hTauCaR = 0.03333
		else
			if(x <= -0.01)
				hTauCaR = -1.08*{x} + 0.0009
			else
				if(x <= 0.01)
					hTauCaR = -0.25*{x} + 0.0092
				else
					hTauCaR = 0.0067
				end
			end
		end
		setfield {chanName} Y_A->table[{c}] {hTauCaR}
		/************************ End CaR_hTau ***********************/
		
		/************************ Begin CaR_hInf *********************/
		//hInfCaR   = 1./(1 + exp((vMemb - hvHalfCaR)/hkCaR));
		theta = {{x} - {hvHalfCaR}}/{hkCaR}
		theta_exp = {exp {theta}} + 1.0
		hInfCaR = 1.0/{theta_exp}
		setfield {chanName} Y_B->table[{c}] {hInfCaR}
		/************************ End CaR_hInf ***********************/
    	x = x + increment
	end

	tweaktau {chanName} X
	tweaktau {chanName} Y

  	create ghk {chanName}GHK

  	setfield {chanName}GHK Cout 2 // Carter & Sabatini 2004 uses 2mM, 
											// Wolf 5mM
  	setfield {chanName}GHK valency 2.0
  	setfield {chanName}GHK T {TEMPERATURE}
	
  	setfield {chanName} Gbar {gMax*surf}
  	addmsg {chanName} {chanName}GHK PERMEABILITY Gk	
  	pope
end


