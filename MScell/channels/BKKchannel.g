//genesis

/***************************		MS Model, Version 5.0	*********************
**************************** 	    	BKKchannel.g 			*********************
		Tom Sheehan tsheeha2@gmu.edu	thsheeha@vt.edu	703-538-8361
******************************************************************************
******************************************************************************/

//==========================================================================
// /* non-inactivating BK-type Ca-dependent K current
// ** Moczydlowski and Latorre 1983, J. Gen. Physiol. 82:511-542.
// ** Implemented by Erik De Schutter BBF-UIA,
// ** with original parameters scaled for units: V, sec, mM. 
// ** Assumes tab2Dchannel "KC" has a sibling Ca_concen "Ca_conc". 
// ** Temprature is modified to be 35C                                      */

// //=======================================================================

function make_BKK_channel
    float EK=-0.9  // V
  //  int xdivs = 299
    int xdivs = 299
    int ydivs = {xdivs}
    float xmin, xmax, ymin, ymax
    xmin = -0.1; xmax = 0.05; ymin = 0.0; ymax = 0.005 // x = Vm, y = [Ca],mM
    int i, j
    float x, dx, y, dy, a, b
    float Temp = 35
    float ZFbyRT = 23210/(273.15 + Temp)
    if (!({exists BKK_channel}))
        create tab2Dchannel BKK_channel
        setfield BKK_channel Ek {EK} Gbar 0.0  \
            Xindex {VOLT_C1_INDEX} Xpower 1 Ypower 0 Zpower 0
        call BKK_channel TABCREATE X {xdivs} {xmin} {xmax} \
            {ydivs} {ymin} {ymax}
    end
    dx = (xmax - xmin)/xdivs
    dy = (ymax - ymin)/ydivs
    x = xmin
    for (i = 0; i <= xdivs; i = i + 1)
        y = ymin
        for (j = 0; j <= ydivs; j = j + 1)
            a = 480*y/(y + 0.180*{exp {-0.84*ZFbyRT*x}})
            b = 280/(1 + y/(0.011*{exp {-1.00*ZFbyRT*x}}))
            setfield BKK_channel X_A->table[{i}][{j}] {a}
            setfield BKK_channel X_B->table[{i}][{j}] {a + b}
            y = y + dy
        end
        x = x + dx
    end
    setfield BKK_channel X_A->calc_mode {LIN_INTERP}
    setfield BKK_channel X_B->calc_mode {LIN_INTERP}

end



