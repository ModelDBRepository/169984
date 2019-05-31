//genesis

/***************************		MS Model, Version 5.2	*********************
**************************** 	  		CaT_channel.g 			*********************
		Tom Sheehan tsheeha2@gmu.edu	thsheeha@vt.edu	703-538-8361
******************************************************************************
max cond is now a parameter in globals, though use in this function is irrelevant
******************************************************************************/

function create_CaT
	str chanName = "CaT_channel"
	str compPath = "/library"

	int c = 0	
	float increment = 0.00005	
	float x = -0.1
	int xdivs = 3000
	float xmin = -0.1
	float xmax = 0.05
        float increment ={{xmax}-{xmin}}/{xdivs}
        echo "CaT increment:" {increment} "V"
  	float mPower = 1.0
  	float hPower = 1.0		

  	float mInfCaT = 0.0
	float mvHalfCaT = -51.73e-3;
  	float mkCaT     = -6.53e-3;
  	float hvHalfCaT = -80e-3;
  	float hkCaT     = 6.7e-3;
  	float hInfCaT = 0.0

  	float mTauCaT = 0.0
  	float mInfCaT = 0.0
  	float hTauCaT = 0.0
  	float hInfCaT = 0.0

	float surf = 0.0
	float gMax = 4.0e-009

	float theta = 0.0
	float theta_exp = 0.0

	pushe {compPath}

	create tabchannel {chanName}
  	setfield {chanName} Xpower {mPower} Ypower {hPower}
	call {chanName} TABCREATE X {xdivs} {xmin} {xmax}
   call {chanName} TABCREATE Y {xdivs} {xmin} {xmax}

	for(c = 0; c < {xdivs} + 1; c = c + 1)
		/************************ Begin CaR_mTau *********************/
		// From MatLab in Johanes/striatum/mspn/vectMakers/makeTables.m
		// qFactCaT = 3;
		// nfCatTauM = load([neuronPath 'taum_cat.txt']);
		// genCatTauM = nfCatTauM * 1e-3 / qFactCaT;
		// genCatV = nfCatV * 1e-3;
		// mTauCaT = interp1(genCatV, genCatTauM, vMemb, 'pchip');
		// mTauCaT(find(vMemb < min(genCatV))) = 
		//						genCatTauM(find(genCatV==min(genCatV)));
		// mTauCaT(find(vMemb > max(genCatV))) = 
		//						genCatTauM(find(genCatV==max(genCatV)));

		if(x < -0.06)
			mTauCaT = 0.00673333
		else // x >= -0.06
			if(x <= -0.05)	// -0.06 <= x <= -0.05
				mTauCaT = -0.3833*{x} -0.016265
			else // x > -0.05
				if(x <= -0.04) // -0.05 < x <= -0.04
					mTauCaT = -0.103*{x} -0.00225
				else // x > -0.04
					if(x <= -0.02) // -0.04 < x <= -0.02
						mTauCaT = -0.03855*{x} + 0.000329
					else // x > -0.02
						mTauCaT = 0.0011
					end
				end
			end
		end
		setfield {chanName} X_A->table[{c}] {mTauCaT}
		/************************ End CaT_mTau ***********************/
		
		/************************ Begin CaT_mInf *********************/
		// From MatLab in Johanes/striatum/mspn/vectMakers/makeTables.m
		// mInfCaT   = 1./(1 + exp((vMemb - mvHalfCaT)/mkCaT));
		theta = {{x} - {mvHalfCaT}}/{mkCaT}
		theta_exp = {exp {theta}} + 1.0
		mInfCaT = 1.0/{theta_exp}
		setfield {chanName} X_B->table[{c}] {mInfCaT}
		/************************ End CaT_mInf ***********************/

		/************************ Begin CaT_hTau *********************/
		// From MatLab in Johanes/striatum/mspn/vectMakers/makeTables.m
		// qFactCaT = 3;
		// nfCatTauH = load([neuronPath 'tauh_cat.txt']);
		// nfCatV = load([neuronPath 'vtau_cat.txt']); 
		// genCatTauH = nfCatTauH * 1e-3 / qFactCaT;
		// genCatV = nfCatV * 1e-3;
		// hTauCaT = interp1(genCatV, genCatTauH, vMemb, 'pchip');
		// hTauCaT(find(vMemb < min(genCatV))) = 
		//						genCatTauH(find(genCatV==min(genCatV)));
		// hTauCaT(find(vMemb > max(genCatV))) = 
		//						genCatTauH(find(genCatV==max(genCatV)));
		if(x < -0.065)
			hTauCaT = 0.1273333
		else // x >= -0.065
			if(x <= -0.06)	// -0.065 <= x <= -0.06
				hTauCaT = -11.55066*{x} -0.62345996
			else // x > -0.06
				if(x <= -0.05) // -0.06 < x <= -0.05
					hTauCaT = -2.65278*{x} -0.0895868
				else // x > -0.05
					if(x <= -0.04) // -0.05 < x <= -0.04
						hTauCaT = -0.73847*{x} + 0.0061287
					else // x > -0.04
						if(x <= -0.01) // -0.04 < x <= -0.01
							hTauCaT = -0.0332833*{x} + 0.03699
						else // x > -0.01
							hTauCaT = 0.0366666
						end
					end
				end
			end
		end
		setfield {chanName} Y_A->table[{c}] {hTauCaT}
		/************************ End CaT_hTau ***********************/
		
		/************************ Begin CaT_hInf *********************/
		// From MatLab in Johanes/striatum/mspn/vectMakers/makeTables.m
		// hInfCaT   = 1./(1 + exp((vMemb - hvHalfCaT)/hkCaT));
		theta = {{x} - {hvHalfCaT}}/{hkCaT}
		theta_exp = {exp {theta}} + 1.0
		hInfCaT = 1.0/{theta_exp}
		setfield {chanName} Y_B->table[{c}] {hInfCaT}
		/************************ End CaT_hInf ***********************/
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
end
