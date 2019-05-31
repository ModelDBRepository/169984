//FScell.p cell parameter file 
// co-ordinate mode
*relative
*cartesian
*asymmetric
*lambda_warn

// specifying constants, SI units
// Plenz D, Aertsen A. Neuroscience. 1996 Feb;70(4):861-91
// J Neurosci 1994,14:4613-4638 says Cm=0.007-0.008, Rm 120-200kOhm*cm^2 ???
//*set_compt_param RM 0.95 //ohm*m^2 =10 kohm*cm^2
*set_compt_param RM 2 //ohm*m^2 //Avrama decreased from 3 to 2 fix timeconstants
//*set_compt_param CM 0.01 //farads/m^2
*set_compt_param CM 0.007 //farads/m^2
//*set_compt_param RA 2  //ohm*m = 100 ohm*cm
*set_compt_param RA 3  //ohm*m
*set_compt_param EREST_ACT -0.063 //?? relative to zero??

// ELEAK is -0.063 without dopamine and -0.061 with dopamine
*set_compt_param ELEAK -0.063  // resting, Volts, was -65mV before



*start_cell /library/tert_dend
// x, y, z or x=length if y and z=0
   tert_dend   none        30    0    0    0.5 
   tert_dend2  .           30    0    0    0.5 
   tert_dend3  .           30    0    0    0.5 
   tert_dend4  .           30    0    0    0.5
   tert_dend5  .           30    0    0    0.5 
   tert_dend6  .           30    0    0    0.5 
   tert_dend7  .           30    0    0    0.5 
   tert_dend8  .           30    0    0    0.5 

// make distal dend with 8 compartments a prototype
*makeproto /library/tert_dend

*start_cell /library/sec_dend
   sec_dend   none   37    0    0    0.75 A_channel 00
   sec_dend2  .      37    0    0    0.75 A_channel 00
   sec_dend3  .      37    0    0    0.75 A_channel 00
   sec_dend4  .      37    0    0    0.75 A_channel 00

*makeproto /library/sec_dend

*start_cell /library/prim_dend
   prim_dend  none  45  0  0  1 A_channel 90  Na_channel 0 K3132_channel 0
   prim_dend2 .  45  0  0  1 A_channel 90  Na_channel 0 K3132_channel 0
  
*makeproto /library/prim_dend

*start_cell 
   soma   none  20  0  0 15 Na_channel 1149 K3132_channel 582 A_channel 333 K13_channel 1.46


*compt /library/prim_dend
primdend1   soma      45    0    0    1 
primdend2   soma      45    0    0    1 
primdend3   soma      45    0    0    1 
 
*compt /library/sec_dend
   secdend1  primdend1/prim_dend2 37  0  0  0.75
   secdend2   primdend1/prim_dend2 37  0  0  0.75
   secdend3   primdend2/prim_dend2 37  0  0  0.75 
   secdend4   primdend2/prim_dend2 37  0  0  0.75
   secdend5  primdend3/prim_dend2 37  0  0  0.75
   secdend6  primdend3/prim_dend2 37  0  0  0.75


*compt /library/tert_dend
tertdend1  secdend1/sec_dend4 30    0  0  0.5 
tertdend2  secdend1/sec_dend4 30    0  0  0.5 
tertdend3  secdend2/sec_dend4 30    0  0  0.5 
tertdend4  secdend2/sec_dend4 30    0  0  0.5 
tertdend5  secdend3/sec_dend4 30    0  0  0.5 
tertdend6  secdend3/sec_dend4 30    0  0  0.5 
tertdend7  secdend4/sec_dend4 30    0  0  0.5
tertdend8  secdend4/sec_dend4 30    0  0  0.5
tertdend9  secdend5/sec_dend4 30    0  0  0.5 
tertdend10  secdend5/sec_dend4 30    0  0  0.5 
tertdend11  secdend6/sec_dend4 30    0  0  0.5
tertdend12  secdend6/sec_dend4 30    0  0  0.5

