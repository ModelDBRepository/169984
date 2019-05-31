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
        str gNaFprox_D1={85500}  //qfactor = 1.2   // 95%
        str gNaFmid_D1={2594}    //95%
        str gNaFdist_D1={927}    //95%

        str gNaFprox_D2={99000}  //qfactor = 1.2 //110% 
        str gNaFmid_D2={3003}    //110%
        str gNaFdist_D2={1073}    //110%

       	str gKAfprox_D1={3214}   //qfactor=1.5 for inact -3214
        str gKAfmid_D1={571}     //1/qfactor=1.5 for act!!!   471  571- pretty good 591-better 571
	str gKAfdist_D1={554}    // 314 414 614 554
        str gKAfdist2_D1={314}    // 314

	str gKAfprox_D2={3214}   //qfactor=1.5 for inact
        str gKAfmid_D2={471}     //1/qfactor=1.5 for act!!!  471
        str gKAfdist_D2={234}    //314  OLD- 3214 371 234  304.7 25.19

        str gKAsprox_D1={277}    //qfactor=2	 
        str gKAsdist_D1={22.9}

        str gKAsprox_D2={304.7}    //qfactor=2  //110%	 
        str gKAsdist_D2={25.19}   //110%

        str gKIR_D1=5.25          //qfactor = 0.5 //125%
        str gKDR_D1={7.25}       //qfactor = 0.5  

        str gKIR_D2=4.2          //qfactor = 0.5
        str gKDR_D2={7.25}       //qfactor = 0.5  

	float gCaL13_D1 = 1.0625e-7  //qfactor=2
        float gCaL13_D2 = 0.796875e-7  //qfactor=2  //75%
	float gCaT  =  0.5875e-8
	float gCaR  =  6.5e-7
//	float gCaQ  =  1.5e-7
	float gCaN_D1 =   0.8e-7       //qfactor=2 //20%
	float gCaL12_D1 = 1.675e-7    //qfactor=2  //200%
        float gCaN_D2 =   2.5e-7       //qfactor=2
	float gCaL12_D2 = 0.8375e-7    //qfactor=2


