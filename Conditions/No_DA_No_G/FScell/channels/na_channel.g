/* Na channel
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

function NaChanAlphaX(voltage)

    float voltage = {voltage} * 1e3 /* convert to mV */

    float num = {3020 - {40 * {voltage}}}
    float denom = {{exp {{-75.5 + {voltage}} / {-13.5}}} - 1}

    /* convert sec to msec */
    float act = {{num} / {denom}} * 1e3
    
    return act
end

/* beta for the type X gate (activation) */
function NaChanBetaX(voltage) 

    float voltage = {voltage} * 1e3 /* convert to mV */

    //echo NaBetaXVoltage: {voltage}
    float num = 1.2262
    float denom = {exp {{voltage} / 42.248}}

    /* convert sec to msec */
    float act = {{num} / {denom}} * 1e3

    return act
end

/* alpha for the type Y gate (inactivation) */
function NaChanAlphaY(voltage)

    float voltage = voltage * 1e3 /* convert to mV */

    float num = 0.0035 
    float denom = {exp {{voltage} / 24.186}}

    /* convert sec to msec */
    float act = {{num} / {denom}} * 1e3

    return act
end

function NaChanBetaY(voltage) 

    float voltage = voltage * 1e3

    float num = {-{0.8712 + {0.017 * {voltage}}}}
    float denom = {{exp {{51.25 + voltage} / -5.2}} - 1}

    /* convert sec to msec */
    float act = {{num} / {denom}} * 1e3

    return act
end

function make_Na_channel 

    float Erev = 0.045  /* reversal potential of sodium */

    str path = "Na_channel"  

    float xmin  = -0.1   /* minimum voltage we will see in the simulation */
    float xmax  = 0.05   /* maximum voltage we will see in the simulation */
    float step  = 0.005  /* use a 5mV step size */
    int   xdivs = 30     /* the number of divisions between -0.1 and 0.05 */
    int   c     = 0
    float y


    create tabchannel {path}

    /* make the table for the activation with a range of -100mV - +50mV
     * with an entry for ever 5mV
     */
    call {path} TABCREATE X {xdivs} {xmin} {xmax}
    call {path} TABCREATE Y {xdivs} {xmin} {xmax}

    /* set the tau and m_inf for the activation and inactivation */
    for(c = 0; c < {xdivs} + 1; c = c + 1)
        setfield {path} X_A->table[{c}] {NaChanAlphaX {{c * {step}} + xmin}}
        setfield {path} X_B->table[{c}] {NaChanBetaX  {{c * {step}} + xmin}}
        setfield {path} Y_A->table[{c}] {NaChanAlphaY {{c * {step}} + xmin}}
        setfield {path} Y_B->table[{c}] {NaChanBetaY  {{c * {step}} + xmin}}
    end

/* for testing */
//for(c = 0; c < 30; c = c + 1)  
//        showfield {path} X_A->table[{c}] 
//        showfield {path} X_B->table[{c}] 
//        showfield {path} Y_A->table[{c}] 
//        showfield {path} Y_B->table[{c}] 
//    end

//for(c = 0; c < 30; c = c + 1)  
//        y = {call Na_channel CALC_ALPHA X {c}}
//        return y
//    end

    setfield {path} Ek {Erev} Xpower 3 Ypower 1

    /* fill the tables with the values of A and B
     * calculated from alpha and beta
     */

    tweakalpha {path} X
    tweakalpha {path} Y

    call {path} TABFILL X 3000 0 
    call {path} TABFILL Y 3000 0

    setfield {path} X_A->calc_mode 0 X_B->calc_mode 0
    setfield {path} Y_A->calc_mode 0 Y_B->calc_mode 0
end

