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
function K3132ChanAlphaX(voltage)

    float voltage = {voltage} * 1e3 /* convert to mV */
    
    float num = {95 - {voltage}}
    float denom = {{exp {{-95 + {voltage}} / {-11.8}}} - 1}

    /* convert sec to msec */
    float act = {{num} / {denom}} * 1e3
    
    return act
end

/* beta for the type X gate (activation) */
function K3132ChanBetaX(voltage) 

    float voltage = {voltage} * 1e3 /* convert to mV */

    float num = 0.025
    float denom = {exp {{voltage} / 22.222}}

    /* convert sec to msec */
    float act = {{num} / {denom}} * 1e3

    return act
end

function make_K3132_channel 

    float Erev = -0.090   /* reversal potential of potassium */

    str path = "K3132_channel"  

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

    /* set the alpha and beta for the activation and inactivation */
    for(c = 0; c < {xdivs} + 1; c = c + 1)
        setfield {path} X_A->table[{c}] {K3132ChanAlphaX {{c * {step}} + xmin}}
        setfield {path} X_B->table[{c}] {K3132ChanBetaX {{c * {step}} + xmin}}
    end

  /* for testing */
//  for(c = 0; c < 30; c = c + 1)  
//        showfield {path} X_A->table[{c}] 
//        showfield {path} X_B->table[{c}] 
//    end


    setfield {path} Ek {Erev} Xpower 2

    /* fill the tables with the values of A and B
     * calculated from alpha and beta
     */
    tweakalpha {path} X


    call {path} TABFILL X 3000 0 

    setfield {path} X_A->calc_mode 0 X_B->calc_mode 0
end











