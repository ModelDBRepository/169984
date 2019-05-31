//genesis
//Spnet.g - Description of the spiny projection neuron network

// Notes for Dr. Blackell from Sriram 07/23/09
//1. What this file does:
// This file is the main file which runs the simulation in genesis.
// Its main functions are calling the readinput and connectinput
// functions to connect the input to the synapses. 
// As discussed in our last meeting I have added the mixing of the 
// duplicate and unique input signals in this function. For the time being
// I have just hard-coded the pMix value but we can decide on how we want that
// value decided, either as an input from the genesis prompt or MATLAB prompt.
// In anycase the duplicate and unique signals get mixed here along with the noises.
// I have not added the noise to the input just since this round was utilized to
// get the input connections figured. I will add the optional function of either deciding
// between combined noise and input or separate noise and input. Coming back to the code,
// the randomization of connecting the inputs to the synapses is done in this file.
// I went through the randomize2-2.g file and maybe I understood it incorretly, but I felt
// as if there was a random correlation between the neurons - a correlation which we can't 
// predict from one run to the other on purely mathematical basis. Maybe I am wrong, I probably
// am but this was my understanding. In anycase I just made a quick random array in MATLAB in the 
// Inputwithcorrelation.m file and read in that array to move along the input files. (for eg.
// a random array (3 1 5 2) will be made in MATLAB. I then read the 3rd input file for the first cell,
// the first input file for the second cell and so on. Since I am in the process of getting the
// cygwin and MATLAB on this machine please let me know if I have gotten any of the syntax wrong, 
// especially in genesis. Also let me know if the random selection method I have chosen to connect the 
// input files to the synapses is appropriate or not. If needed I could use your randomize2-2 method or
// some variation of it. I played a lot with the randomize2-2 file too so if needed I can adopt that
// if needed, do let me know. 

//This file also sets up the inhibitory spiny projection neuron network.
//This is accomplished by looping through each cell and connecting 
//using a random selection the compartments which will be connected 
//together. It is based on a probability which is a function of distance.
//The synchan objects are also made here before duplicating the SP single
//cell. The objects are made in the library. 
 
include SP_neuron_include // Single SP neuron model with synaptic inputs excluded.
include InputFromFile
include synapseinfo
include graphics

 
/****************************Begin Network description****************************************************/

/******************Parameters*******************/
str indataInfoFile = "INPUTDATA/inputInfo.txt"
openfile {indataInfoFile} r

str indataType     = {readfile {indataInfoFile}}
float corr_syn_Glu  = {readfile {indataInfoFile}}
float corr_syn_GABA  = {readfile {indataInfoFile}}
float upFreq       = {readfile {indataInfoFile}}
float noiseFreq    = {readfile {indataInfoFile}}
float maxInputTime = {readfile {indataInfoFile}}
int randSeed       = {readfile {indataInfoFile}}
int numCells  = {readfile {indataInfoFile}}
//int nAMPA  = {readfile {indataInfoFile}}
//int nGABA  = {readfile {indataInfoFile}}
int nAMPA = 72
int nGABA = 117
closefile {indataInfoFile}

//nAMPA= {densityMax_s_Glu} + {densityMax_pd_Glu}*{prim_dend_num} + {densityMax_sd_Glu}*{sec_dend_num} + {densityMax_td_Glu}*{tert_dend_num}//nGABA= {densityMax_s_GABA} + {densityMax_pd_GABA}*{prim_dend_num} + {densityMax_sd_GABA}*{sec_dend_num} + {densityMax_td_GABA}*{tert_dend_num} 
//These 2 formulae utilize the density of synapses for each compartment and multiplies it with the number of subcompartments to get the total number of synapses and thus number of loops for the input files to reach all these synapses
//In this case, nAMPA = 72 and nGABA = 117 per cell

// Use the SPRNG random number generator
setrand -sprng
randseed {{randSeed} + 4711}

// Label to appear on the graph
str graphlabel = "Network of Spiny Projection neurons with Fast Spiking interneuronal and cortical input"

float tmax = 1.0		// simulation time
//float dt = 1e-5 // 50e-6		simulation time step
float SEP_X = 500e-6 // 500 um Tunstall et al
float SEP_Y = 500e-6
float syn_weight = 4 // synaptic weight, effectively multiplies gmax
float cond_vel = 1 // m/sec - GABA and the Basal Ganglia by Tepper et al
float syn_weight2 = 4 // synaptic weight, effectively multiplies gmax
float cond_vel2 = 0.8 // m/sec - GABA and the Basal Ganglia by Tepper et al
float prop_delay = {SEP_X}/{cond_vel2}
float gmax = 4e-9 // 1 nS - possibly a little small for this cell
float gmax2 = 6e-9
//int NX = sqrt {numCells}  // number of cells = NX*NY
int NX=1
int NY = NX
float area_x = {NX}*{SEP_X}
float area_y =  {NY}*{SEP_Y}
int num_inter_connections = 9
float spikeoutdt=1e-3  // might remove or move to parameter file for this and the next 2 parameters
float vmOutDt=1e-4  
float simDt=1e-5 //1e-6 needed for voltage clamp


//setclocks
setclock 1 {vmOutDt}
setclock 0 {simDt}

/***********************************************/
/* Neurons will be placed on a two dimensional NX by NY grid, with points
   SEP_X and SEP_Y apart in the x and y directions.

   The distance between interacting Spiny projection neurons was recorded to be
   264 +- 101 um (mean) but to represent a bigger network a separation of
   500 um will be used.- Tunstall but <10 um from Penz's paper
   
*/

// =============================
//   Function definitions
// =============================

function step_tmax
    echo {NX*NY}" cells    dt = "{getclock 0}"   tmax = "{tmax}
    echo "START: " {getdate}
    step {tmax} -time
    echo "END  : " {getdate}
end

function set_weights(weight)
   float weight
   planarweight /network/SPcell[]/soma/spike -fixed {weight}
end

function set_delays(delay)
   float delay
   planardelay /network/SPcell[]/soma/spike -fixed {delay}
end

//===============================
//    Main simulation section
//===============================

setfield /library/SPcell/soma/spike thresh 0  abs_refract 0.004  output_amp 1

/* Make the network
Assemble the components to build the prototype cell under the
neutral element /library.
*/

// Create the prototype cell specified in SPcell.p, using readcell. 
// -> Done in SP_single.
// Create the Synchan objects in the single neuron, done in the library 
// SPcellpath- /library/SPcell

str CompName

foreach CompName ({el {SPcellpath}/#})  
	pushe {CompName}
	make_AMPA_channel
	make_NMDA_channel
	make_GABA_channel
	pope
end

/*
foreach CompName ({el {SPcellpath}/tertdend#/#})  
	pushe {CompName}
	make_AMPA_channel
	make_NMDA_channel
	make_GABA_channel
	pope
end
*/


/* make a 2D array of cells with copies of /library/cell */

createmap /library/SPcell /network {NX} {NY} -delta {SEP_X} {SEP_Y} 

/* There will be NX cells along the x-direction, separated by SEP_X,
   and  NY cells along the y-direction, separated by SEP_Y.
   The default origin is (0, 0).  This will be the coordinates of cell[0].
   The last cell, cell[{NX*NY-1}], will be at (NX*SEP_X -1, NY*SEP_Y-1).
*/

////////////////////Connecting FS and cortical input to SP network///////////////
int inputs,cellCtr
float percDup = 0.3 // 30% of the inputs to the cells are duplicates 
float tempDup = {percDup}*{numCells}
int nDups = {round {tempDup}}
int Dupc = 0
int dup_yes_no = 0

for (inputs=0; inputs<numCells; inputs=inputs+1)
    
      if (Dupc < nDups)
          dup_yes_no = { {rand 0 1} > {rand 0 1} }
          if (dup_yes_no == 1)
              Dupc = Dupc + 1
              readInputFromFile "AMPAinsignal_"{inputs}"_" \
                    "INPUTDATA/AMPAinsignal_10_" \
                    {nAMPA}
          else
              readInputFromFile "AMPAinsignal_"{inputs}"_" \
                    "INPUTDATA/AMPAinsignal_"{{inputs}+1}"_" \
                    {nAMPA}
          end
      else
          if ({numCells-{{inputs}+1}} > {nDups-Dupc})
          readInputFromFile "AMPAinsignal_"{inputs}"_" \
                    "INPUTDATA/AMPAinsignal_"{{inputs}+1}"_" \
                    {nAMPA}
          else 
          Dupc = Dupc + 1
          readInputFromFile "AMPAinsignal_"{inputs}"_" \
                    "INPUTDATA/AMPAinsignal_10_" \
                    {nAMPA}
          end
     end
end
    
Dupc = 0
dup_yes_no = 0

for (inputs=0; inputs<numCells; inputs=inputs+1)
    
      if (Dupc < nDups)
          dup_yes_no = { {rand 0 1} > {rand 0 1} }
          if (dup_yes_no == 1)
              Dupc = Dupc + 1
              readInputFromFile "GABAinsignal_"{inputs}"_" \
                    "INPUTDATA/GABAinsignal_10_" \
                    {nGABA}
          else
              readInputFromFile "GABAinsignal_"{inputs}"_" \
                    "INPUTDATA/GABAinsignal_"{{inputs}+1}"_" \
                    {nGABA}
          end
      else
         if ({numCells-{{inputs}+1}} > {nDups-Dupc})
          readInputFromFile "GABAinsignal_"{inputs}"_" \
                    "INPUTDATA/GABAinsignal_"{{inputs}+1}"_" \
                    {nGABA}
          else 
          Dupc = Dupc + 1
          readInputFromFile "GABAinsignal_"{inputs}"_" \
                    "INPUTDATA/GABAinsignal_10_" \
                    {nGABA}
          end
     end
end
    


for(cellCtr = 0; cellCtr < {numCells}; cellCtr = cellCtr + 1)
  connectInsignalToCell /network/SPcell[{cellCtr}] "/input/AMPAinsignal_"{cellCtr}"_" "AMPA"
  connectInsignalToCell /network/SPcell[{cellCtr}] "/input/AMPAinsignal_"{cellCtr}"_" "NMDA"
  connectInsignalToCell /network/SPcell[{cellCtr}] "/input/GABAinsignal_"{cellCtr}"_" "GABA"
end

////////////////////////////////Connecting Inhibitory SP network/////////////////////////////////////////////////

//1- soma, 2- primary dendrite, 3-secondary dendrite, 4- tertiary dendrite
int ctrpre, ctrpost, dctr, densityMax_1_SP = 0, densityMax_2_SP = 5, densityMax_3_SP = 5, densityMax_4_SP = 0 

echo "Connecting  Inhibitory SP_network."	
int increment=1, increment2=1
str compname_pre, compname_post

// In all the connections below the proximal connections have a higher density and
// distal connections have a lower density. The first for loop in each case is 
// looping through the cell that sends the spike, the second loop is for the
// receiving cell and the third for loop is for the density.

float xpre, ypre, xpost, ypost, dist2parent, prob, connect
int compt_pre_select, compt_post_select, compt_sub_select
str compt_1="soma", compt_2="primdend", compt_3="secdend", compt_4="tertdend"

///////////////////Random compartment selection//////////////////////////////
// There is no longer a separate distal density term since the probability would take care of the number of times the
//distal dendrites get messsaged.
//Loops- The foreach command loops through the different compartments, the next for-loop loops through the 
//density counter based on the compartment that was randomly selected using the rand command. The if statement,
//if(compt_select==1) checks for the soma because if 'NOT soma' then will have to loop thorugh the subcompartments 
//as well- primdend1,primdend2 etc. so made 2 separate cases. 

int densityMax_s_Glu = 0, densityMax_s_GABA = 3, densityMax_pd_Glu = 0, densityMax_pd_GABA = 3, densityMax_sd_Glu = 1, densityMax_sd_GABA = 3 , densityMax_td_Glu = 1, densityMax_td_GABA = 0,


for(ctrpre = 0; ctrpre < {numCells-1}; ctrpre = ctrpre + 1)
	xpre={getfield /network/SPcell[ctrpre]/soma/ x}
	ypre={getfield /network/SPcell[ctrpre]/soma/ y}
	for(ctrpost = {ctrpre + increment}; ctrpost < Numcells; ctrpost= {ctrpre + increment})
		xpost={getfield /network/SPcell[ctrpost]/soma/ x}
		ypost={getfield /network/SPcell[ctrpost]/soma/ y}
		dist2parent={sqrt {({pow {xpost-xpre} 2 }) + ({pow {ypost-ypre} 2})} }   // calculating distance between the cells
		prob = exp({dist2parent}) //probability as a function of distance, so further it is lower the probability of connection
		connect = {rand 0 0.002} 
		if (connect>{1-prob})  
		    compt_post_select = {trunc {rand 1 4}} //which compartment to connect to
		    if (compt_post_select==1)   // for connecting to soma, separate so as to not use foreach for sub-compartments
				for(dctr = 0; dctr < densityMax_1_SP; dctr = dctr + 1) 
					addmsg /network/SPcell[ctrpre]/soma/spike \
					/network/SPcell[ctrpost]/soma/GABA_channel SPIKE
				end
		    else	
				foreach compname ({el /network/SPcell[]/{compt_{compt_post_select}}#)    //loops through each compartment
					for(dctr = 0; dctr < densityMax_{compt_post_select}_SP; dctr = dctr + 1) //loops through density number based on post compartment
					addmsg /network/SPcell[ctrpre]/soma/spike \
						/network/SPcell[ctrpost]/{compname}/GABA_channel SPIKE
					end
				end
		    end
		end
		increment = {increment + 1}
	end
end

/////////////////////////////////////////////////////////////////////////////////////
 
/* Set the axonal propagation delay and weight fields of the target
   synchan synapses for all spikegens.  
*/

planardelay /network/SPcell[]/soma/spike -fixed {prop_delay}
planarweight /network/SPcell[]/soma/spike -fixed {syn_weight}


create spikehistory Ctx.history
setfield Ctx.history ident_toggle 0 filename "Ctx.spikes" initialize 1 leave_open 1 flush 1
addmsg /in/input[] Ctx.history SPIKESAVE 

create spikehistory SPcell.history
setfield SPcell.history ident_toggle 0 filename "SPcell.spikes" initialize 1 leave_open 1 flush 1
addmsg /network/SPcell[]/soma/spike SPcell.history SPIKESAVE

// make the control panel
make_control

// make the graph to display soma Vm and pass messages to the graph
make_Vmgraph

make_netview

make_inview

colorize

check
echo "Network of "{NX}" by "{NY}" cells with separations "{SEP_X}" by "{SEP_Y}
makeOutput "/SP" {outputName} {vmOutDt}

reset       
reset

step {tmax} -t

clearOutput {outputName}
quit




