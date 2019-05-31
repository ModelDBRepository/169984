//genesis
//net_func.g 

/*
This file sets the netowork of SP cells up by calling the function that
sets up the SP-SP inhibitory network and calling the functions that connect
extrinsic input to the SP network.This file also has the include statements
for the file that prints out the connection of the SP-SP network. 
*/

/*
function include_net (net)
str net
addglobal str cellPath
setglobal cellPath "/library/"{net}"cell"
if ({net} == "SP")
  include MScell/MScellSyn.g // Single SP neuron model with synaptic channels
  makeMScellSyn {getglobal cellPath} "MScell/MScell.p"
else 
end
if ({net} == "FS") 
  include FScell/FScellSyn.g // Single FS neuron model with synaptic channels
  makeFScellSyn {getglobal cellPath} "FScell/FScell.p"
else
end

make_spike {cellPath}/soma
add_field {cellPath}
setfield /library/{net}cell/soma/spike thresh 0  abs_refract 0.004  output_amp 1
end
*/

/****************************Begin Network description****************************************************/
function rannum_new2 (tablename)
  str tablename
  int i
  int last={getfield {tablename} X_A->xmax}  //get the index of last element from the value of xmax
  //echo "last=" {last}
  int index={ round {rand -0.499 {last+0.499}} }  //choose a random index
  int filenum={getfield {tablename} X_A->table[{index}]}  //return filenum associated with index selected above
  setfield {tablename} X_A->table[{filenum}] {getfield {tablename} X_A->table[{last}]} //replace selected filenum with last element
  setfield {tablename} X_A->xmax {last-1} //set xmax to be {last-1}
  return {filenum}
end


function chan_mod (net, channame, perc)
	
	str net, channame
   	float std_val, std_val_D1, std_val_D2, perc, g, g_soma, g_prim, g_sec, g_tert, g_a, std_val_D1_soma, std_val_D2_soma, std_val_D1_prim, std_val_D2_prim, std_val_D1_sec, std_val_D2_sec, std_val_D1_tert, std_val_D2_tert
   	int i, d1_num, d2_num
 
   	d1_num = {getfield /SPnetwork/SPcell/soma d1_cnt}
   	d2_num = {getfield /SPnetwork/SPcell/soma d2_cnt}

// MAKE IT COMPARTMENT DEPENDENT

   	if ({net}=="SP")
        	if ({channame}=="NR2A")       
      			std_val_D1 = {getfield /library/{net}cell_D1/soma/{channame} gmax}
			std_val_D2 = {getfield /library/{net}cell_D2/soma/{channame} gmax}
        	else
                	std_val_D1_soma = {getfield /library/{net}cell_D1/soma/{channame}_channel Gbar} 
			std_val_D2_soma = {getfield /library/{net}cell_D2/soma/{channame}_channel Gbar}
                        std_val_D1_prim = {getfield /library/{net}cell_D1/primdend1/{channame}_channel Gbar} 
			std_val_D2_prim = {getfield /library/{net}cell_D2/primdend1/{channame}_channel Gbar}
                        std_val_D1_sec = {getfield /library/{net}cell_D1/secdend1/{channame}_channel Gbar} 
			std_val_D2_sec = {getfield /library/{net}cell_D2/secdend1/{channame}_channel Gbar}
                        std_val_D1_tert = {getfield /library/{net}cell_D1/tertdend1/{channame}_channel Gbar} 
			std_val_D2_tert = {getfield /library/{net}cell_D2/tertdend1/{channame}_channel Gbar}
        	end
   	else
		std_val = {getfield /library/{net}cell/soma/{channame}_channel Gbar}
   	end

   	float mod_D1 = {perc*std_val_D1}
   	float min_D1 = {std_val_D1 - mod_D1}
   	float max_D1 = {std_val_D1 + mod_D1}

   	float m_D1 = {min_D1}
   	float dm_D1 = ({max_D1 - min_D1})/({d1_num})

   	float mod_D2 = {perc*std_val_D2}
   	float min_D2 = {std_val_D2 - mod_D2}
   	float max_D2 = {std_val_D2 + mod_D2}

   	float m_D2 = {min_D2}
   	float dm_D2 = ({max_D2 - min_D2})/({d2_num})

  	float mod_D1_soma = {perc*std_val_D1_soma}
   	float min_D1_soma = {std_val_D1_soma - mod_D1_soma}
   	float max_D1_soma = {std_val_D1_soma + mod_D1_soma}

   	float m_D1_soma = {min_D1_soma}
   	float dm_D1_soma = ({max_D1_soma - min_D1_soma})/({d1_num})

   	float mod_D2_soma = {perc*std_val_D2_soma}
   	float min_D2_soma = {std_val_D2_soma}
   	float max_D2_soma = {std_val_D2_soma + mod_D2_soma}

   	float m_D2_soma = {min_D2_soma}
   	float dm_D2_soma = ({max_D2_soma - min_D2_soma})/({d2_num})

  	float mod_D1_prim = {perc*std_val_D1_prim}
   	float min_D1_prim = {std_val_D1_prim - mod_D1_prim}
   	float max_D1_prim = {std_val_D1_prim + mod_D1_prim}

   	float m_D1_prim = {min_D1_prim}
   	float dm_D1_prim = ({max_D1_prim - min_D1_prim})/({d1_num})

   	float mod_D2_prim = {perc*std_val_D2_prim}
   	float min_D2_prim = {std_val_D2_prim}
   	float max_D2_prim = {std_val_D2_prim + mod_D2_prim}

   	float m_D2_prim = {min_D2_prim}
   	float dm_D2_prim = ({max_D2_prim - min_D2_prim})/({d2_num})

  	float mod_D1_sec = {perc*std_val_D1_sec}
   	float min_D1_sec = {std_val_D1_sec - mod_D1_sec}
   	float max_D1_sec = {std_val_D1_sec + mod_D1_sec}

   	float m_D1_sec = {min_D1_sec}
   	float dm_D1_sec = ({max_D1_sec - min_D1_sec})/({d1_num})

   	float mod_D2_sec = {perc*std_val_D2_sec}
   	float min_D2_sec = {std_val_D2_sec}
   	float max_D2_sec = {std_val_D2_sec + mod_D2_sec}

   	float m_D2_sec = {min_D2_sec}
   	float dm_D2_sec = ({max_D2_sec - min_D2_sec})/({d2_num})

        float mod_D1_tert = {perc*std_val_D1_tert}
   	float min_D1_tert = {std_val_D1_tert - mod_D1_tert}
   	float max_D1_tert = {std_val_D1_tert + mod_D1_tert}

   	float m_D1_tert = {min_D1_tert}
   	float dm_D1_tert = ({max_D1_tert - min_D1_tert})/({d1_num})

   	float mod_D2_tert = {perc*std_val_D2_tert}
   	float min_D2_tert = {std_val_D2_tert}
   	float max_D2_tert = {std_val_D2_tert + mod_D2_tert}

   	float m_D2_tert = {min_D2_tert}
   	float dm_D2_tert = ({max_D2_tert - min_D2_tert})/({d2_num})

   	echo "m_d1" {m_D1_soma}
   	echo "m_d2" {m_D2_prim}
   	echo "dm_d1" {dm_D1_sec}
   	echo "dm_d2" {dm_D2_tert}

   	if (!{exists val_D1})
   		create tabchannel val_D1  //
   	else
   	end
   	
	disable val_D1
   	int tablemax_D1 = {getfield /SPnetwork/SPcell/soma d1_cnt}
   	call val_D1 TABCREATE X {{tablemax_D1}-1} 0 {{tablemax_D1}-1}
        call val_D1 TABCREATE Y {{tablemax_D1}-1} 0 {{tablemax_D1}-1}
   	call val_D1 TABCREATE Z {{tablemax_D1}-1} 0 {{tablemax_D1}-1}

	for (i=0; i<{tablemax_D1}; i={i+1})
        	setfield val_D1 X_A->table[{i}] {m_D1} //
                setfield val_D1 X_B->table[{i}] {m_D1_soma} //
                setfield val_D1 Y_A->table[{i}] {m_D1_prim} //
                setfield val_D1 Y_B->table[{i}] {m_D1_sec} //
                setfield val_D1 Z_A->table[{i}] {m_D1_tert} //
        	m_D1 = {m_D1 + dm_D1}
                m_D1_soma = {m_D1_soma + dm_D1_soma}
                m_D1_prim = {m_D1_prim + dm_D1_prim}
                m_D1_sec = {m_D1_sec + dm_D1_sec}     
                m_D1_tert = {m_D1_tert + dm_D1_tert}         
   	end

   	if (!{exists val_D2})
   		create tabchannel val_D2  //
   	else
   	end

   	disable val_D2
   	int tablemax_D2 = {getfield /SPnetwork/SPcell/soma d2_cnt}
   	call val_D2 TABCREATE X {{tablemax_D2}-1} 0 {{tablemax_D2}-1}
        call val_D2 TABCREATE Y {{tablemax_D2}-1} 0 {{tablemax_D2}-1}
   	call val_D2 TABCREATE Z {{tablemax_D2}-1} 0 {{tablemax_D2}-1}

	for (i=0; i<{tablemax_D2}; i={i+1})
        	setfield val_D2 X_A->table[{i}] {m_D2} //
                setfield val_D2 X_B->table[{i}] {m_D2_soma} //
                setfield val_D2 Y_A->table[{i}] {m_D2_prim} //
                setfield val_D2 Y_B->table[{i}] {m_D2_sec} //
                setfield val_D2 Z_A->table[{i}] {m_D2_tert} //
        	m_D2 = {m_D2 + dm_D2}
                m_D2_soma = {m_D2_soma + dm_D2_soma}
                m_D2_prim = {m_D2_prim + dm_D2_prim}
                m_D2_sec = {m_D2_sec + dm_D2_sec}     
                m_D2_tert = {m_D2_tert + dm_D2_tert}         
   	end

   	int tablemax = {getglobal numCells_{net}}
   	if (!{exists ind})
   		create tabchannel ind  //create a table to contain the indices of the filenames
   	else
   	end
   	disable ind
   	tablemax = {getglobal numCells_{net}}
   	call ind TABCREATE X {{tablemax}-1} 0 {{tablemax}-1}
   
  	for (i=0; i<{tablemax}; i={i+1})
        	setfield ind X_A->table[{i}] {i} //indices of unique filenames
   	end

   	str cN
   	int inCtr, ctr, d2Ctr, d1_numC = {{d1_num}-1}
   
   	for(i = 0; i < {getglobal numCells_{net}}; i = {i + 1})
       		inCtr = {rannum_new2 ind}
       		if ({inCtr}>{d1_numC})
			//echo "inctr" {inCtr} "d1" {d1_num}
			d2Ctr = {{inCtr}-{d1_num}} 
			//echo "diff" {inCtr-d1_num} "d2Ctr" {d2Ctr}
       	   		g = {getfield val_D2 X_A->table[{d2Ctr}]}
                        g_soma = {getfield val_D2 X_B->table[{d2Ctr}]}
                        g_prim = {getfield val_D2 Y_A->table[{d2Ctr}]}
                        g_sec = {getfield val_D2 Y_B->table[{d2Ctr}]}
                        g_tert = {getfield val_D2 Z_A->table[{d2Ctr}]}
			//echo "g D2" {g}
       		else
           		g = {getfield val_D1 X_A->table[{inCtr}]}
                        g_soma = {getfield val_D1 X_B->table[{inCtr}]}
                        g_prim = {getfield val_D1 Y_A->table[{inCtr}]}
                        g_sec = {getfield val_D1 Y_B->table[{inCtr}]}
                        g_tert = {getfield val_D1 Z_A->table[{inCtr}]}
			//echo "g D1" {g}
       		end
       		if ({channame}== "NR2A")
           		g_a = {g/2.75}
       		else
       		end
       		ctr=0
       		foreach cN ({el /{net}network/{net}cell[{i}]/##[TYPE=compartment]})  
           		ctr = {ctr+1}
           		if ({channame}=="NR2A")
               			setfield {cN}/{channame} gmax {g}  
               			setfield {cN}/AMPA gmax {g_a}
           		else
               			if (({ctr}<32 && {net}=="FS") || {net}=="SP")
     				//   if exists{{cN}/{channame}_channel}
                                     if ({getfield {cN} position}==1.599999996e-05)
                                        setfield {cN}/{channame}_channel Gbar {g_soma}
                                     elif ({getfield {cN} position}==3.599999764e-05) 
                                        setfield {cN}/{channame}_channel Gbar {g_prim}
                                     elif ({getfield {cN} position}==6.022999878e-05)
                                        setfield {cN}/{channame}_channel Gbar {g_sec}
                                     elif ({getfield {cN} position}>7.0e-05)
                                        setfield {cN}/{channame}_channel Gbar {g_tert}
               			//	setfield {cN}/{channame}_channel Gbar {g}
                                     end    
               			//        setfield /library/{net}cell_D1/soma/{channame}_channel Gbar
                                else
               			end
           		end
       		end
	end
end // chan_mod function end 

function chan_mod_FS (net, channame, perc)
	
	str net, channame
   	float std_val, std_val_D1, std_val_D2, perc, g, g_soma, g_prim, g_sec, g_tert, g_a, std_val_D1_soma, std_val_D2_soma, std_val_D1_prim, std_val_D2_prim, std_val_D1_sec, std_val_D2_sec, std_val_D1_tert, std_val_D2_tert
   	int i, d1_num, d2_num
 
   	d1_num = {getglobal numCells_{net}}
 

// MAKE IT COMPARTMENT DEPENDENT


       
                	std_val_D1_soma = {getfield /library/FScell/soma/{channame}_channel Gbar} 
			
                        std_val_D1_prim = {getfield /library/FScell/primdend1/{channame}_channel Gbar} 
			
                        std_val_D1_sec = {getfield /library/FScell/secdend1/{channame}_channel Gbar} 
		
			

   	float mod_D1 = {perc*std_val_D1}
   	float min_D1 = {std_val_D1 - mod_D1}
   	float max_D1 = {std_val_D1 + mod_D1}

   	float m_D1 = {min_D1}
   	float dm_D1 = ({max_D1 - min_D1})/({d1_num})



  	float mod_D1_soma = {perc*std_val_D1_soma}
   	float min_D1_soma = {std_val_D1_soma - mod_D1_soma}
   	float max_D1_soma = {std_val_D1_soma + mod_D1_soma}

   	float m_D1_soma = {min_D1_soma}
   	float dm_D1_soma = ({max_D1_soma - min_D1_soma})/({d1_num})



  	float mod_D1_prim = {perc*std_val_D1_prim}
   	float min_D1_prim = {std_val_D1_prim - mod_D1_prim}
   	float max_D1_prim = {std_val_D1_prim + mod_D1_prim}

   	float m_D1_prim = {min_D1_prim}
   	float dm_D1_prim = ({max_D1_prim - min_D1_prim})/({d1_num})


  	float mod_D1_sec = {perc*std_val_D1_sec}
   	float min_D1_sec = {std_val_D1_sec - mod_D1_sec}
   	float max_D1_sec = {std_val_D1_sec + mod_D1_sec}

   	float m_D1_sec = {min_D1_sec}
   	float dm_D1_sec = ({max_D1_sec - min_D1_sec})/({d1_num})



  
   	echo "m_d1" {m_D1_soma}
  
   	echo "dm_d1" {dm_D1_sec}
   	

   	if (!{exists val_D1})
   		create tabchannel val_D1  //
   	else
   	end
   	
	disable val_D1
   	int tablemax_D1 = {getglobal numCells_{net}}
   	call val_D1 TABCREATE X {{tablemax_D1}-1} 0 {{tablemax_D1}-1}
        call val_D1 TABCREATE Y {{tablemax_D1}-1} 0 {{tablemax_D1}-1}
   	call val_D1 TABCREATE Z {{tablemax_D1}-1} 0 {{tablemax_D1}-1}

	for (i=0; i<{tablemax_D1}; i={i+1})
        	setfield val_D1 X_A->table[{i}] {m_D1} //
                setfield val_D1 X_B->table[{i}] {m_D1_soma} //
                setfield val_D1 Y_A->table[{i}] {m_D1_prim} //
                setfield val_D1 Y_B->table[{i}] {m_D1_sec} //
        
        	m_D1 = {m_D1 + dm_D1}
                m_D1_soma = {m_D1_soma + dm_D1_soma}
                m_D1_prim = {m_D1_prim + dm_D1_prim}
                m_D1_sec = {m_D1_sec + dm_D1_sec}     
             
   	end

   

   	

   	int tablemax = {getglobal numCells_{net}}
   	if (!{exists ind})
   		create tabchannel ind  //create a table to contain the indices of the filenames
   	else
   	end
   	disable ind
   	tablemax = {getglobal numCells_{net}}
   	call ind TABCREATE X {{tablemax}-1} 0 {{tablemax}-1}
   
  	for (i=0; i<{tablemax}; i={i+1})
        	setfield ind X_A->table[{i}] {i} //indices of unique filenames
   	end

   	str cN
   	int inCtr, ctr, d2Ctr, d1_numC = {{d1_num}-1}
   
   	for(i = 0; i < {getglobal numCells_{net}}; i = {i + 1})
       		inCtr = {rannum_new2 ind}
       		
           		g = {getfield val_D1 X_A->table[{inCtr}]}
                        g_soma = {getfield val_D1 X_B->table[{inCtr}]}
                        g_prim = {getfield val_D1 Y_A->table[{inCtr}]}
                        g_sec = {getfield val_D1 Y_B->table[{inCtr}]}
                      
			//echo "g D1" {g}
       		
       		if ({channame}== "NR2A")
           		g_a = {g/2.75}
       		else
       		end
       		ctr=0
       		foreach cN ({el /{net}network/{net}cell[{i}]/##[TYPE=compartment]})  
           		ctr = {ctr+1}
           		if ({channame}=="NR2A")
               			setfield {cN}/{channame} gmax {g}  
               			setfield {cN}/AMPA gmax {g_a}
           		else
               			if (({ctr}<32 && {net}=="FS") || {net}=="SP")
     				//   if exists{{cN}/{channame}_channel}
                                     if ({getfield {cN} position}==1.999999949e-05)
                                        setfield {cN}/{channame}_channel Gbar {g_soma}
                                     elif ({getfield {cN} position}>6.0e-05 && {getfield {cN} position}<12.0e-05) 
                                        setfield {cN}/{channame}_channel Gbar {g_prim}
                                   // elif ({getfield {cN} position}>14.0e-05 && {getfield {cN} position}<26.0e-05)
                                    //    setfield {cN}/{channame}_channel Gbar {g_sec}
                          
               			//	setfield {cN}/{channame}_channel Gbar {g}
                                     end    
               			//        setfield /library/{net}cell_D1/soma/{channame}_channel Gbar
                                else
               			end
           		end
       		end
	end
end // chan_mod function end 

function make_net (net,dopa)
str net
int i, n_ctr, inCtr, tablemax
float dopa,rand_num

if ({net}=="SP")

  create neutral /{net}network
 
int d1_count=0, d2_count=0
for(i = 0; i < {getglobal numCells_{net}}; i = {i + 1})
       rand_num = {rand 0 1}
       if ({dopa}<{rand_num})
       copy /library/SPcell_D1 /SPnetwork/SPcell[{i}] //Copy a D1 neuron here
       addfield /SPnetwork/SPcell[{i}]/soma D1
       setfield /SPnetwork/SPcell[{i}]/soma D1 1
       d1_count = d1_count + 1
       else
       copy /library/SPcell_D2 /SPnetwork/SPcell[{i}] //Copy a D2 neuron here
       addfield /SPnetwork/SPcell[{i}]/soma D1
       setfield /SPnetwork/SPcell[{i}]/soma D1 0
       d2_count = d2_count + 1
       end
end
addfield /SPnetwork/SPcell/soma d1_cnt
setfield /SPnetwork/SPcell/soma d1_cnt {d1_count}
addfield /SPnetwork/SPcell/soma d2_cnt
setfield /SPnetwork/SPcell/soma d2_cnt {d2_count}

int k
int NX = {getglobal NX_{net}}
int NX_2 = {pow {NX} 2}
float x = 1.6e-5, y = 0, x_ze = 0, y_ze = 0
str cName
setfield /{net}network/{net}cell[0]/ x 0
setfield /{net}network/{net}cell[0]/ y {y}
//setfield /{net}network/{net}cell[0]/soma/ z {z}
 // echo "NX squared"{NX_2}
for(k = 1; k < {getglobal numCells_{net}}; k = {k + 1})
	if ( {k%{NX}} == 0 )
		x = 0
		y = {y + 25e-6}
        elif ( {k%{NX}} != 0  )
        	x = {x + 25e-6}
        end        	
	foreach cName ({el /SPnetwork/SPcell[{k}]/##[TYPE=compartment]})
		x_ze = {getfield {cName} x0}
		y_ze = {getfield {cName} y0}
		setfield {cName} x {x + x_ze}
        	setfield {cName} y {y + y_ze}
	end
	//setfield /SPnetwork/SPcell[{k}]/ x
	//setfield /SPnetwork/SPcell[{k}]/ y
end


//createmap /library/{net}cell /{net}network {getglobal NX_{net}} {getglobal NY_{net}} -delta {getglobal SEP_X_{net}} {getglobal SEP_Y_{net}} -origin //{getglobal origin_x_{net}} {getglobal origin_y_{net}}

elif ({net}=="FS")

createmap /library/{net}cell /{net}network {getglobal NX_{net}} {getglobal NY_{net}} -delta {getglobal SEP_X_{net}} {getglobal SEP_Y_{net}} -origin {getglobal origin_x_{net}} {getglobal origin_y_{net}}

end

end //make_net function end
/* 
There will be NX cells along the x-direction, separated by SEP_X,
and  NY cells along the y-direction, separated by SEP_Y.
The default origin is (0, 0).  This will be the coordinates of /network/SPcell[0].
The last cell,SPcell[{NX*NY-1}], will be at (NX*SEP_X -1, NY*SEP_Y-1).
*/

////////////////////////////////Connecting Inhibitory SP network/////////////////////////////////////////////////

//1- soma, 2- primary dendrite, 3-secondary dendrite, 4- tertiary dendrite
int cellCtr
echo "Connecting  Inhibitory SP_network."
/* 
Call function that connects SP-SP neurons based on probability function 
that is exponential. Argument is the desired factor of the exponential funtion.
*/

function conn (net,net2)
str net,net2, input_folder
if ({net}=="FS" && {net2}=="SP")
loops_SP=1
factor_SP = 100e-6
else
end

if ({net}=="FS" && {net2}=="FS")
weight_FS=1
else
end

echo "fact1" {getglobal factor_{net}}
echo "fact2" {getglobal factor_{net2}}

if ({net2}=="FS")
netconn {net} {net2} ""/{net}"network/"{net}"cell"  ""/{net2}"network/"{net2}"cell" {getglobal factor_{net2}} {getglobal loops_{net2}} {getglobal weight_{net}} 1 0 0.75 0.3 2e9
elif ({net2}=="SP")
//last 3 params - SP(1/0), FS(1/0), intrinsic percentage(0-1)
netconn_SP {net} {net2} ""/{net}"network/"{net}"cell"  ""/{net2}"network/"{net2}"cell" {getglobal factor_{net2}} 1 0 0.65
end

// gap probs - a combination of g&H and striatal data
if ({net}=="FS" && {net2}=="SP")
echo "FS SP netconn done"
elif ({net}=="SP" && {net2}=="SP")
echo "SP SP netconn done"
end
////////////////////Connecting FS and cortical input to SP network///////////////

/* 
FS and cortical input are connected to the SP network by using 
MATLAB generated input trains. Functions are called that 
(i) Convert the MATLAB generated files into GENESIS timetables
(ii) Connect the timetables to the SP network

readInputFromFile connects the MATLAB generated files to timetables.
The function is called once for AMPA and once for GABA. The files for
the unique input are called within the loop and inputs for the duplicate
input are called once outside the loop.The arguments for this function are:
(i) Name of the timetable
(ii) Name of the MATLAB file to read from
(iii) Number of synaptic inputs
(iv) Number of connections from unique or duplicate input files
*/

if ({net}=={net2})
    if ({net}=="SP")
    input_folder = "INPUTDATA_SP"
    else
    input_folder = "INPUTDATA_FS"
    end
    echo "input_folder" {input_folder}
for (inputs=0; inputs<{getglobal numCells_{net}}; inputs={inputs+1})
	readInputFromFile {net2} "AMPAinsignal_u_"{inputs}"_" \
		            ""{input_folder}"/AMPAinsignal_"{{inputs}+1}"_" \
                    {getglobal nAMPA_{net}} {getglobal nUnique_a_{net}}

if ({net2}=="FS")
	readInputFromFile {net2} "GABAinsignal_u_"{inputs}"_" \
		            ""{input_folder}"/GABAinsignal_"{{inputs}+1}"_" \
                    {getglobal nGABA_{net2}} {getglobal nUnique_g_{net2}}  
else
end

end

	readInputdFromFile {net2} "AMPAinsignal_d_" \
                    ""{input_folder}"/AMPAinsignal_dup_" \
                    {getglobal nDups_a_{net}}

if ({net2}=="FS")
	readInputdFromFile {net2} "GABAinsignal_d_" \
                    ""{input_folder}"/GABAinsignal_dup_" \
                    {getglobal nDups_g_{net}}
else
end

/*
connectInsignalToCell connects the timetables created by the above function calls
to the SP cell network using a tabchannel and randomly selecting the input name
from this tabchannel. The arguments for this function are:
(i) Name of SP cell to connect to 
(ii) Name of input file to connect the unique input from
(iii) Name of input file to connect the duplicate input from
(iv) Type of synaptic connection
(v) Number of connections from unique and (vi) duplicate input files
*/
int weight_sp=1, weight_fs=1
for(cellCtr = 0; cellCtr < {getglobal numCells_{net}}; cellCtr = {cellCtr + 1})
    //Cortical input
      if ({net}=="SP")
      		if ({getfield /SPnetwork/SPcell[{cellCtr}]/soma D1} == 1)
      			connectInsignalToCell {net2} ""/{net}"network/"{net}"cell["{cellCtr}"]" "AMPAinsignal_u_"{cellCtr}"_"  "AMPAinsignal_d_" "AMPA" {getglobal nUnique_a_{net}_D1} {getglobal nDups_a_{net}_D1} 0 0 
			connectInsignalToCell {net2} ""/{net}"network/"{net}"cell["{cellCtr}"]" "AMPAinsignal_u_"{cellCtr}"_" "AMPAinsignal_d_" "NR2A" {getglobal nUnique_a_{net}_D1} {getglobal nDups_a_{net}_D1} 0 0
		elif ({getfield /SPnetwork/SPcell[{cellCtr}]/soma D1} == 0)
			connectInsignalToCell {net2} ""/{net}"network/"{net}"cell["{cellCtr}"]" "AMPAinsignal_u_"{cellCtr}"_"  "AMPAinsignal_d_" "AMPA" {getglobal nUnique_a_{net}} {getglobal nDups_a_{net}} 0 0 
			connectInsignalToCell {net2} ""/{net}"network/"{net}"cell["{cellCtr}"]" "AMPAinsignal_u_"{cellCtr}"_" "AMPAinsignal_d_" "NR2A" {getglobal nUnique_a_{net}} {getglobal nDups_a_{net}} 0 0
		end
    
      elif ({net2}=="FS")
    		connectInsignalToCell {net2} ""/{net}"network/"{net}"cell["{cellCtr}"]" "AMPAinsignal_u_"{cellCtr}"_"  "AMPAinsignal_d_" "AMPA" {getglobal nUnique_a_{net}} {getglobal nDups_a_{net}} 0 0 
    		connectInsignalToCell {net2}  ""/{net}"network/"{net}"cell["{cellCtr}"]" "GABAinsignal_u_"{cellCtr}"_" "GABAinsignal_d_" "GABA" {getglobal nUnique_g_{net}} {getglobal nDups_g_{net}} {weight_fs} {weight_sp}
	end
end

else
end



/////////////////////////////////////////////////////////////////////////////////////
// include the utilities that will print out the connections between the SP neurons
ce /
/* Set the axonal propagation delay and weight fields of the target
   synchan synapses for all spikegens.  
*/
planardelay /{net}network/{net}cell[]/soma/spike -fixed {prop_delay}
//planarweight /{net}network/{net}cell[]/soma/spike -fixed {syn_weight}
if ({net}=="SP" && {net2}=="SP")
echo "end of SP SP conn"
else
end 

end  //function end
