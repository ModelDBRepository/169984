//genesis
//nsynapses

int densityMax_soma_AMPA_SP_D1 = 0, densityMax_pd_AMPA_SP_D1 = 0, densityMax_sd_AMPA_SP_D1 = 1,  densityMax_td_1_AMPA_SP_D1 = 2
int densityMax_td_2_AMPA_SP_D1 = 1
int densityMax_soma_AMPA_SP = 0, densityMax_soma_GABA_SP = 3, densityMax_pd_AMPA_SP = 0, densityMax_pd_GABA_SP = 6
int densityMax_sd_AMPA_SP = 1, densityMax_sd_GABA_SP = 3 , densityMax_td_AMPA_SP = 2, densityMax_td_GABA_SP = 1
int densityMax_soma_AMPA_FS = 1, densityMax_soma_GABA_FS = 3, densityMax_pd_AMPA_FS = 1, densityMax_pd_GABA_FS = 3
int densityMax_sd_AMPA_FS = 0, densityMax_sd_GABA_FS = 3 , densityMax_td_AMPA_FS = 1, densityMax_td_GABA_FS = 0
//3 6 3 1
int prim_dend_num_SP = 4, sec_dend_num_SP = 8, tert_dend_num_SP = 16*11
int nAMPA_SP = {densityMax_soma_AMPA_SP} + {densityMax_pd_AMPA_SP}*{prim_dend_num_SP} + {densityMax_sd_AMPA_SP}*{sec_dend_num_SP} + {densityMax_td_AMPA_SP}*{tert_dend_num_SP}
int nGABA_SP = {densityMax_soma_GABA_SP} + {densityMax_pd_GABA_SP}*{prim_dend_num_SP} + {densityMax_sd_GABA_SP}*{sec_dend_num_SP} + {densityMax_td_GABA_SP}*{tert_dend_num_SP}

int prim_dend_num_FS = 3*2, sec_dend_num_FS = 6*4, tert_dend_num_FS = 12*8
int nAMPA_FS = {densityMax_soma_AMPA_FS} + {densityMax_pd_AMPA_FS}*{prim_dend_num_FS} + {densityMax_sd_AMPA_FS}*{sec_dend_num_FS} + {densityMax_td_AMPA_FS}*{tert_dend_num_FS}
int nGABA_FS = {densityMax_soma_GABA_FS} + {densityMax_pd_GABA_FS}*{prim_dend_num_FS} + {densityMax_sd_GABA_FS}*{sec_dend_num_FS} + {densityMax_td_GABA_FS}*{tert_dend_num_FS}


function add_field (cellpath)
str cellpath, CName
//echo "entering add_field cellpath" {cellpath}
if ({cellpath} == "/library/SPcell_D2")
  foreach CName ({el {cellpath}/##[TYPE=compartment]}) 
 //   echo " entered foreach"
    addfield {CName} nsynallowed_a
    addfield {CName} nsynallowed_g
    if ({getfield {CName} position}==1.599999996e-05)
 //     echo "soma"
      setfield {CName} nsynallowed_a {densityMax_soma_AMPA_SP}
      setfield {CName} nsynallowed_g {densityMax_soma_GABA_SP}
    elif ({getfield {CName} position}==3.599999764e-05) 
 //     echo "prim"
      setfield {CName} nsynallowed_a {densityMax_pd_AMPA_SP}
      setfield {CName} nsynallowed_g {densityMax_pd_GABA_SP}
    elif ({getfield {CName} position}==6.022999878e-05)
  //    echo "sec"
      setfield {CName} nsynallowed_a {densityMax_sd_AMPA_SP}
      setfield {CName} nsynallowed_g {densityMax_sd_GABA_SP}
    elif ({getfield {CName} position}>7.0e-05)
  //    echo "tert"
      setfield {CName} nsynallowed_a {densityMax_td_AMPA_SP}
      setfield {CName} nsynallowed_g {densityMax_td_GABA_SP}
    end
  end
elif ({cellpath} == "/library/SPcell_D1")
foreach CName ({el {cellpath}/##[TYPE=compartment]}) 
 //   echo " entered foreach"
    addfield {CName} nsynallowed_a
    addfield {CName} nsynallowed_g
    if ({getfield {CName} position}==1.599999996e-05)
 //     echo "soma"
      setfield {CName} nsynallowed_a {densityMax_soma_AMPA_SP_D1}
      setfield {CName} nsynallowed_g {densityMax_soma_GABA_SP}
    elif ({getfield {CName} position}==3.599999764e-05) 
 //     echo "prim"
      setfield {CName} nsynallowed_a {densityMax_pd_AMPA_SP_D1}
      setfield {CName} nsynallowed_g {densityMax_pd_GABA_SP}
    elif ({getfield {CName} position}==6.022999878e-05)
  //    echo "sec"
      setfield {CName} nsynallowed_a {densityMax_sd_AMPA_SP_D1}
      setfield {CName} nsynallowed_g {densityMax_sd_GABA_SP}
    elif ({getfield {CName} position}>7.0e-05 && {getfield {CName} position}<2.5e-04) 
  //    echo "tert"
      setfield {CName} nsynallowed_a {densityMax_td_1_AMPA_SP_D1}
      setfield {CName} nsynallowed_g {densityMax_td_GABA_SP}
    elif ({getfield {CName} position}>2.6e-04) 
  //    echo "tert2"
      setfield {CName} nsynallowed_a {densityMax_td_2_AMPA_SP_D1}
      setfield {CName} nsynallowed_g {densityMax_td_GABA_SP}
    end
  end
elif ({cellpath} == "/library/FScell")
  foreach CName ({el {cellpath}/##[TYPE=compartment]}) 
     addfield {CName} nsynallowed_a
     addfield {CName} nsynallowed_g
     if ({getfield {CName} position}==1.999999949e-05)
  //    echo "soma"
      setfield {CName} nsynallowed_a {densityMax_soma_AMPA_FS}
      setfield {CName} nsynallowed_g {densityMax_soma_GABA_FS}
     elif ({getfield {CName} position}>6.0e-05 && {getfield {CName} position}<12.0e-05) 
   //   echo "prim"
      setfield {CName} nsynallowed_a {densityMax_pd_AMPA_FS}
      setfield {CName} nsynallowed_g {densityMax_pd_GABA_FS}
     elif ({getfield {CName} position}>14.0e-05 && {getfield {CName} position}<26.0e-05)
  //    echo "sec"
      setfield {CName} nsynallowed_a {densityMax_sd_AMPA_FS}
      setfield {CName} nsynallowed_g {densityMax_sd_GABA_FS}
     elif ({getfield {CName} position}>28.0e-05 && {getfield {CName} position}<50.0e-05)
   //   echo "tert"
      setfield {CName} nsynallowed_a {densityMax_td_AMPA_FS}
      setfield {CName} nsynallowed_g {densityMax_td_GABA_FS}
     end
  end
end
end //function end

//SP
//int nAMPA  = 360
//int nGABA  = 227

//FS
//nAMPA = 127 
//nGABA = 93

//echo "nAMPA = "{nAMPA}""
//echo "nGABA = "{nGABA}""


function ndups_a (pDup,n)	
	float pDup
        int n
	int nD_a = {round {{pDup}*{n}}}
	return {nD_a}
end

function ndups_g (pDup,n)	
	float pDup
        int n
	int nD_g = {round {{pDup}*{n}}}
	return {nD_g}
end
	
