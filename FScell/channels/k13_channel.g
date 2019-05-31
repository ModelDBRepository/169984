/* K3132 channel
 *      fills tables with values for alpha and beta and then
 *      uses tweakalpha to alter the values to A and B
 *      values for alpha and beta are taken from:
 *      J. Neurophysiology 82: 2476-2389, 1999 
 *      on page 2478
 * 
 *      the functions below convert to physiological units to do the 
 *      calulations and convert back to SI units for the output
 */

/* alpha for the type X gate (activation) */
function K13ChanAlphaX(voltage)

    float voltage = {{voltage} * 1e3  - 0} /* convert to mV, add offset */
    
    float num = {-{0.616 + {0.014 * {voltage}}}}
    float denom = {{exp {{44 + {voltage}} / {-2.3}}} - 1}

    /* convert sec to msec */
    float act = {{num} / {denom}} * 1e3
    
    return act
end

/* beta for the type X gate (activation) */
function K13ChanBetaX(voltage) 

    float voltage = {{voltage} * 1e3 - 0} /* convert to mV */

    float num = 0.0043
    float denom = {exp {{44 + {voltage}} / 34}}

    /* convert sec to msec */
    float act = {{num} / {denom}} * 1e3

    return act
end

function make_K13_channel 

    float Erev = -0.090   /* reversal potential of potassium */

    str path = "K13_channel"  

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

    /* set the tau and m_inf for the activation and inactivation */
    for(c = 0; c < {xdivs} + 1; c = c + 1)
        setfield {path} X_A->table[{c}] {K13ChanAlphaX {{c * {step}} + xmin}}
        setfield {path} X_B->table[{c}] {K13ChanBetaX {{c * {step}} + xmin}}
    end

  /* for testing */
//  for(c = 0; c < 30; c = c + 1)  
//        showfield {path} X_A->table[{c}] 
//        showfield {path} X_B->table[{c}] 
//    end


    setfield {path} Ek {Erev} Xpower 4

    /* fill the tables with the values of alpha and beta
     * calculated from tau and m_inf
     */
    tweakalpha {path} X

    call {path} TABFILL X 3000 0 

    //setfield {path} X_A->calc_mode 0 X_B->calc_mode 0
end




