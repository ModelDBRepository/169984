//genesis

/***************************		MS Model, Version 5.10	**********************
**************************** 	      	globals.g 			**********************
Tom Sheehan tsheeha2@gmu.edu	thsheeha@vt.edu	703-538-8361
*******************************************************************************
	The capatilized parameters defined below are global and visable to all files
	Capatilized parameters should be treated as constants
******************************************************************************/
/* AB: Comments indicate the qfactor used with the various channels
*  conductance of CaN and CaL12 sum the inactivating and non-inactivating channel
*  conductances from the previous model
*/
        float ELEAK = -0.070
        float PI = 3.1415926
        float RA = 1.0;
        float RM = 8.69565217;
        float CM = 0.01;
        float EREST_ACT = -0.085
 	float TEMPERATURE = 35
	str  CA_BUFF_1 = "Ca_difshell_1"     // L and T type channels
	str  CA_BUFF_2 = "Ca_difshell_2"     // coupled to the other channels
	str  CA_BUFF_3 = "Ca_difshell_3"     // all calcium channels
	
	int CaDyeFlag = 0    // flags of calcium dye. "0" means NO calcium dyes.
                     // flag =2 : Fluo-4
                     // flag =3 : Fluo-5F
	int shellMode = 1     // we  have two shell-modes:
                     //  mode = 0 : detailed multi-shell model, using "difshell" object
                     //  mode = 1 : simple calcium pool adopted from  Sabatini's work(Sabatini, 2001, 2004)

//parameters determined by hand tuning to match spike width, AHP shape &amp, fI curve
//spike width with these globals plus spines = 0.88 ms
        str gNaFprox={90000}  //qfactor = 1.2   
        str gNaFmid={2730}
        str gNaFdist={975}

        str gKAfprox={3214}   //qfactor=1.5 for inact
        str gKAfmid={471}     //1/qfactor=1.5 for act!!!
        str gKAfdist={314}

        str gKAsprox={277}    //qfactor=2	 
        str gKAsdist={22.9}

        str gKIR=4.2          //qfactor = 0.5
        str gKDR={7.25}       //qfactor = 0.5  

	float gCaL13 = {1.0625e-7+1.07e-7}  //qfactor=2
	float gCaT  =  {0.5875e-8+0.58e-8}
	float gCaR  =  {6.5e-7+6.43e-7}
//	float gCaQ  =  1.5e-7
	float gCaN =   2.5e-7       //qfactor=2
	float gCaL12 = {0.8375e-7+0.83e-7}    //qfactor=2

/* Surface area of spine head = 7.853981593e-13m^2, 165 spines (205 total comps)
   gCaR = 13e-7 -> 1.021017568e-18 /spine -> 1.6838e-16 total
   gCaT = 0.235e-7 -> 1.845685677e-20 /spine -> 3.0454e-18 total
   gCaL12 = 3.35e-7 -> 2.631083943e-19 /spine -> 4.34e-17 total
   gCaL13 = 4.25e-7 -> 3.337942088e-19 /spine -> 5.5075e-17 total
conductance of channels in soma (SA=8e-10), primdend1 (1.4e-10), secdend1 (0.84e-10), 
gCaR =   5.227605712e-16 9.189150748e-17 5.44263204e-17 
gCaT =   4.724951198e-18 8.305578876e-19 4.919302039e-19
gCaL12 = 6.735568939e-17 1.183986707e-17 7.012622166e-18
gCaL13 = 8.545124467e-17 1.502072808e-17 8.896610384e-18

If we add 1 spines worth of calcium per compartment, hopefully that will restore activity to the spine state:
increment for no spines (uses 0.9e-10*(165/205), ~0.7, as comp SA:
gCaR 6.43e-7
gCaT 0.58e-8
gCaL12 0.83e-7
gCaL13 1.07e-7
Each spine contributes RM/SA and CM*SA.  Thus, removing the spines requires and increase in CM and decrease in RM to compensate.  But increase should be proportional to relative area of spine head, e.g. ~1e-12 for spine vs 0.84e-10 for secdend, and 0.909e-10 (tert)

*/
