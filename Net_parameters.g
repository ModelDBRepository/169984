//genesis
//Net_parameters.g

//SP Network Parameters

str indataInfoFile = "INPUTDATA_SP/inputInfo.txt"
openfile {indataInfoFile} r
str indataType     = {readfile {indataInfoFile}}
float corr_syn_Glu  = {readfile {indataInfoFile}}
float corr_syn_GABA  = {readfile {indataInfoFile}}
float upFreq       = {readfile {indataInfoFile}}
float noiseFreq    = {readfile {indataInfoFile}}
float maxInputTime = {readfile {indataInfoFile}}
int randSeed       = {readfile {indataInfoFile}}
//int numCells  = {readfile {indataInfoFile}}
closefile {indataInfoFile}
int numCells_SP = 1000
int weight_C_SP =1, weight_C_FS=3

//CLOCKS

float simDt=1e-5 //1e-6 needed for voltage clamp
float VmOutDt=1e-4 
float CaOutDt= 5e-4
float spikeoutdt=1e-3  

float maxTime = 2.0		// simulation time
float tmax = 2.0

str outputName = "SPnetout"

setclock 0 2e-5        // Simulation time step (Second)       
//setclock 1 5e-4        // time step for graphic output 
setclock 1 1e-4


// Use the SPRNG random number generator
setrand -sprng
randseed {{randSeed} + 4680}

int inputs
/* Neurons will be placed on a two dimensional NX by NY grid, with points
   SEP_X and SEP_Y apart in the x and y directions.

   The distance between interacting Spiny projection neurons was recorded to be
   264 +- 101 um (mean) but to represent a bigger network a separation of
   500 um will be used.- Tunstall but <10 um from Plenz's paper */

//int NX_SP = {round {pow {numCells_SP} 0.3333}}  // number of cells = NX*NY
int NX_SP = {sqrt {numCells_SP}}  // number of cells = NX*NY
int NY_SP = NX_SP, NZ_SP = NX_SP
float SEP_X_SP = 25e-6 // 25 um Gittis et al
float SEP_Y_SP = 25e-6
float SEP_Z_SP = 25e-6
float area_x_SP = {NX_SP}*{SEP_X_SP}
float area_y_SP =  {NY_SP}*{SEP_Y_SP}
float area_z_SP = {NZ_SP}*{SEP_Z_SP}
//float syn_weight = 4 // synaptic weight, effectively multiplies gmax
float cond_vel = 1 // m/sec - GABA and the Basal Ganglia by Tepper et al
//float syn_weight2 = 4 // synaptic weight, effectively multiplies gmax
float cond_vel2 = 0.8 // m/sec - GABA and the Basal Ganglia by Tepper et al
float prop_delay = {SEP_X_SP}/{cond_vel2}
float gmax = 4e-9 
float gmax2 = 6e-9
float percDup_SP = 0.1  //0.3
int nDups_a_SP = {ndups_a {percDup_SP} {nAMPA_SP}}
int nDups_g_SP = {ndups_g {percDup_SP} {nGABA_SP}}
int nUnique_a_SP = {{nAMPA_SP} - {nDups_a_SP}}
int nAMPA_SP_D1 = {0.8*{nAMPA_SP}}
int nDups_a_SP_D1 = {ndups_a {percDup_SP} {nAMPA_SP_D1}}
int nUnique_a_SP_D1 = {{nAMPA_SP_D1} - {nDups_a_SP_D1}}
int nUnique_g_SP = {{nGABA_SP} - {nDups_g_SP}}
int loops_SP=2, weight_SP_D1=1, weight_SP_D2=1
float origin_x_SP = 0, origin_y_SP = 0
float factor_SP = 95e-6

/*
function set_weights(weight)
   float weight
   planarweight /network/SPcell[]/soma/spike -fixed {weight}
end

function set_delays(delay)
   float delay
   planardelay /network/SPcell[]/soma/spike -fixed {delay}
end

function step_tmax
    echo {NX*NY}" cells    dt = "{getclock 0}"   tmax = "{maxTime}
    echo "START: " {getdate}
    step {maxTime} -time
    echo "END  : " {getdate}
end

*/

//FS Network Parameters

str parFile = "parameters.txt"
openfile {parFile} r
str readGapLine
int numGaps = {readfile {parFile}}
int nG
  for (nG=1; nG<{numGaps}+1; nG = {nG}+1)
        readGapLine = {readfile {parFile} -linemode}
        addglobal str gapSrc_{nG} {getarg {arglist {readGapLine}} -arg 1}
        addglobal str gapDest_{nG} {getarg {arglist {readGapLine}} -arg 2}
        addglobal str gapRes_{nG} {getarg {arglist {readGapLine}} -arg 3}
  end
closefile {parFile}

int numCells_FS = 49

// Use the SPRNG random number generator
setrand -sprng
randseed {{randSeed} + 4680}

int inputs
/* Neurons will be placed on a two dimensional NX by NY grid, with points
   SEP_X and SEP_Y apart in the x and y directions.

   The distance between interacting Spiny projection neurons was recorded to be
   264 +- 101 um (mean) but to represent a bigger network a separation of
   500 um will be used.- Tunstall but <10 um from Plenz's paper */

int NX_FS = {sqrt {numCells_FS}}  // number of cells = NX*NY
int NY_FS = NX_FS
float SEP_X_FS = 100e-6 // 100 um Gittis et al
float SEP_Y_FS = 100e-6
float area_x_FS = {NX_FS}*{SEP_X_FS}
float area_y_FS =  {NY_FS}*{SEP_Y_FS}
/*
float syn_weight = 4 // synaptic weight, effectively multiplies gmax
float cond_vel = 1 // m/sec - GABA and the Basal Ganglia by Tepper et al
float syn_weight2 = 4 // synaptic weight, effectively multiplies gmax
float cond_vel2 = 0.8 // m/sec - GABA and the Basal Ganglia by Tepper et al
float prop_delay = {SEP_X}/{cond_vel2}
float gmax = 4e-9 
float gmax2 = 6e-9
*/
float percDup_FS = 0.1
int nDups_a_FS = {ndups_a {percDup_FS} {nAMPA_FS}}
int nDups_g_FS = {ndups_g {percDup_FS} {nGABA_FS}}
int nUnique_a_FS = {{nAMPA_FS} - {nDups_a_FS}}
int nUnique_g_FS = {{nGABA_FS} - {nDups_g_FS}}
int loops_FS=1, weight_FS=1, weight_FS_D1=5, weight_FS_D2=5
float origin_x_FS = 50e-6, origin_y_FS = 50e-6 
float factor_FS = 400e-6
float factor_FS_SP = 300e-6
/*
function set_weights(weight)
   float weight
   planarweight /network/FScell[]/soma/spike -fixed {weight}
end

function set_delays(delay)
   float delay
   planardelay /network/FScell[]/soma/spike -fixed {delay}
end
*/

/*
function step_tmax
    echo {NX*NY}" cells    dt = "{getclock 0}"   tmax = "{maxTime}
    echo "START: " {getdate}
    step {maxTime} -time
    echo "END  : " {getdate}
end
*/

