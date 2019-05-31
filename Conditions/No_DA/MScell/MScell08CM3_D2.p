//***************************		MS Model, Version 5.0	**********************
//*************************** 	      MScell.p 			**********************
//			Tom Sheehan tsheeha2@gmu.edu	thsheeha@vt.edu	703-538-836
//*****************************************************************************

*relative
*cartesian
*asymmetric
*lambda_warn

*set_global ELEAK -0.070
//*set_global RA 1.0 
//*set_global RM 8.695652  1.8 1.83-0.0295  1.86-0.029  1.96-0.0275 2.16-0.025
*set_global RM 1.8  //1.8-0.03
//*set_global CM 0.010 
//change Cm to account for no spines - make 3x higher?  0.03  0.025
*set_global CM 0.03
*set_global EREST_ACT -0.085

*start_cell /library/tert_dend
tert_dend none 35.927 0 0 0.80
tert_dend2 . 35.927 0 0 0.80 
tert_dend3 . 35.927 0 0 0.80
tert_dend4 . 35.927 0 0 0.80
tert_dend5 . 35.927 0 0 0.80 
tert_dend6 . 35.927 0 0 0.80
tert_dend7 . 35.927 0 0 0.80 
tert_dend8 . 35.927 0 0 0.80
tert_dend9 . 35.927 0 0 0.80
tert_dend10 . 35.927 0 0 0.80
tert_dend11 . 35.927 0 0 0.80
*makeproto /library/tert_dend

*start_cell /library/sec_dend

sec_dend none 24.230 0 0 1.100
*makeproto /library/sec_dend

*start_cell /library/prim_dend

prim_dend none 20.000 0 0 2.250
*makeproto /library/prim_dend

*start_cell
*spherical
*set_compt_param RA 4
soma none 16.000 0 0 16.000

*cylindrical

*set_compt_param RA 4
*compt /library/prim_dend
primdend1 soma 20 0 0 2.25
primdend2 soma 20 0 0 2.25
primdend3 soma 20 0 0 2.25
primdend4 soma 20 0 0 2.25

*set_compt_param RA 4
*compt /library/sec_dend
secdend1 primdend1 24.23 0 0 1.1
secdend2 primdend1 24.23 0 0 1.1
secdend3 primdend2 24.23 0 0 1.1
secdend4 primdend2 24.23 0 0 1.1
secdend5 primdend3 24.23 0 0 1.1
secdend6 primdend3 24.23 0 0 1.1
secdend7 primdend4 24.23 0 0 1.1
secdend8 primdend4 24.23 0 0 1.1

*set_compt_param        RA      2
*compt /library/tert_dend
tertdend1 secdend1 35.927  0  0  0.8
tertdend2 secdend1 35.927  0  0  0.8
tertdend3 secdend2 35.927  0  0  0.8
tertdend4 secdend2 35.927  0  0  0.8
tertdend5 secdend3 35.927  0  0  0.8
tertdend6 secdend3 35.927  0  0  0.8
tertdend7 secdend4 35.927  0  0  0.8
tertdend8 secdend4 35.927  0  0  0.8
tertdend9 secdend5 35.927  0  0  0.8
tertdend10 secdend5 35.927  0  0  0.8
tertdend11 secdend6 35.927  0  0  0.8
tertdend12 secdend6 35.927  0  0  0.8
tertdend13 secdend7 35.927  0  0  0.8
tertdend14 secdend7 35.927  0  0  0.8
tertdend15 secdend8 35.927  0  0  0.8
tertdend16 secdend8 35.927  0  0  0.8
