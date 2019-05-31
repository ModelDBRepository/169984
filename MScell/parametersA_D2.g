// genesis

float useAMPANMDAGHKchannels= 0  // we do not use GHK project for NMDA/AMPA

setclock 0 5e-6 //was 5e-6
        // Simulation time step (Second)       
setclock 1 2e-5        //  time step for ascii output
//setclock 1 1e-4 // time step for graphic output


// parameters for NMDA subunits


// NR2A
str	    subunit = "NR2A"
float   EkNMDA   = 0
float	Kmg       = 3.57
float	NMDAtau2      = (112e-3)/2 	// 50e-3 changed to 112 to include 25%NR2B NR2A average from (Vicini et al., 1998 figure 1B)
float	NMDAgmax      = 0.39e-9      //  NR2A and B from (Moyner et al., 1994 figure 7) //0.94e-9 - NMDA
int ghk_yesno=0

str NMDAname = {subunit}

//for saving info on distal or proximal dendrites or massed and spaced. formula typeof dend, # of spines.


