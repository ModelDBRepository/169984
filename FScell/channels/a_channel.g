
/* describes the activation function for the A channel. 
 * taken from the MSN activation boltzman from:
 * (tkatch, j. neuroscience, 20(2):579-588)
 */

//float EREST_ACT = -0.056
function AChanAct(voltage)

    float voltage
    float vh = -0.045
    float vc = -0.013

  float act = {1 / {1 + {exp {{{voltage}  - {vh}} / {vc}}}}}

    return act
end

/* describes the time constant over a range of voltages
 * taken from Figure 2b of J. neuroscience 20(2):579-588,
 * tkatch january 2000
 */
function AChanTauAct(voltage) 
    float voltage
    float vh = -0.07
    float vc = 0.013
    return {1e-3 * {1 + {exp {-{{voltage} - {vh} } / {vc}}}}}
end

/* describes the inactivation function for the A channel.
 * taken from the MSN inactivation boltzman from:
 * (tkatch, j. neuroscience, 20(2):579-588)
 * vc was not given in this paper, so it was estimated to be
 * about 8mV (see (surmeier, brain research, 473:187-192
 * vh = -0.0756 vc = 0.008
 */
function AChanInact(voltage)

    float voltage
    float vh = -0.077
    float vc =-0.008
    return {1 / {1 + {exp {-{{voltage} - {vh}} / {vc}}}}}

end

/* (tkatch, j. neuroscience, 20(2):579-588)
 * time constant of inactivation of the A channel
 * it is a constant, but the function is placed here in 
 * order to be consistent
 */
function AChanTauInact(voltage) 

    float voltage

    return 0.014

end

function make_A_channel 

    str path = "A_channel"  

    float Erev = -0.09  /* reversal potential of potassium */
    float xmin = -0.1   /* minimum voltage we will see in the simulation */
    float xmax = 0.05   /* maximum voltage we will see in the simulation */
    float step = 0.005  /* use a 5mV step size */
    int xdivs = 30      /* the number of divisions between -0.1 and 0.05 */
    int c = 0

    create tabchannel {path}

    /* make the table for the activation with a range of -100mV - +50mV
     * with an entry for ever 5mV
     */
    call {path} TABCREATE X {xdivs} {xmin} {xmax}
    call {path} TABCREATE Y {xdivs} {xmin} {xmax}

    /* set the tau and m_inf for the activation and inactivation */
    for(c = 0; c <= {xdivs}; c = c + 1)
        setfield {path} X_A->table[{c}] {AChanTauAct {{c * {step}} + xmin}}
        setfield {path} X_B->table[{c}] {AChanAct {{c * {step}} + xmin}}
        setfield {path} Y_A->table[{c}] {AChanTauInact {{c * {step}} + xmin}}
        setfield {path} Y_B->table[{c}] {AChanInact {{c * {step}} + xmin}}
    end

    /* this is fudged from the genesis book */
    setfield {path} Ek {Erev} Xpower 4 Ypower 1
    
    /* fill the tables with the values of A and B
     * calculated from tau and m_inf
     */

/* for testing */
//for(c = 0; c < 30; c = c + 1)  
//        showfield A_channel X_A->table[{c}] 
//        showfield {path} X_B->table[{c}] 
//        showfield {path} Y_A->table[{c}] 
//        showfield {path} Y_B->table[{c}] 
//    end

    tweaktau {path} X
    tweaktau {path} Y


    call {path} TABFILL X 3000 0
    call {path} TABFILL Y 3000 0
end









