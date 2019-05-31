//genesis
//net_conn.g - Description of the FS and SP connections to the SP network

//This file sets up the SP-SP connections based on the factor sent to the netconn function

////////////////////////////////Connecting Inhibitory SP network/////////////////////////////////////////////////


//1- soma, 2- primary dendrite, 3-secondary dendrite, 4- tertiary dendrite

function rannum_new (tablename)
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

function rannum_net (tablename,net,min_SP,max_FS,int_perc)
  str tablename,net
  int i,min_SP,max_FS
  float int_perc
  int last={getfield {tablename} X_A->xmax}  //get the index of last element from the value of xmax
  //echo "last=" {last}
  if ({net}=="FS")
  int index={ round {rand -0.499 {max_FS+0.499}} }  //choose a random index
  elif ({net}=="SP")
  int index={ round {rand {min_SP-0.499} {last+0.499}} }  //choose a random index
  elif ({int_perc}!=1)
  int index={ round {rand -0.499 {last+0.499}} }  //choose a random index
  end
  int filenum={getfield {tablename} X_A->table[{index}]}  //return filenum associated with index selected above
  setfield {tablename} X_A->table[{filenum}] {getfield {tablename} X_A->table[{last}]} //replace selected filenum with last element
  setfield {tablename} X_A->xmax {last-1} //set xmax to be {last-1}
  return {filenum}
end

function connectGap(compA, compB, resistance)

    str compA
    str compB
    float resistance

    // Gap junctions go both ways...
    addmsg {compA} {compB} RAXIAL {resistance} Vm
    addmsg {compB} {compA} RAXIAL {resistance} Vm
end

function gapconn

int gapCtr

// Create gap junctions required in file

 for(gapCtr = 1; gapCtr < {numGaps}+1; gapCtr = {gapCtr} + 1)
    if({getglobal gapRes_{gapCtr}} > 0)
      connectGap {getglobal gapSrc_{gapCtr}} {getglobal gapDest_{gapCtr}} {getglobal gapRes_{gapCtr}}
      echo {getglobal gapSrc_{gapCtr}}"-->"{getglobal gapDest_{gapCtr}}" res: "{getglobal gapRes_{gapCtr}}
    else
      echo "WARNING: gapRes: "{getglobal gapRes_{gapCtr}}" ohm, no gap junction created"
    end
 end

end

function netconn(net,net2,network,network2,fact,loops,syn_weight1,chem_gap,ind_gap, gap_prob, ind_prob, gap_res)
//receives the network to connect and the factor to connect it with- could be FS or SP network
str net,net2,network,network2
float fact, gap_res
int ctrpre, ctrpost, dctr,  densityMax_3_SP = 2, densityMax_4_SP = 2, increment=1, loops, syn_weight1
int break0=0, break1=0 , break2=0, break3=0, break4=0, break5=0, break6=0, break7=0
float xpre, ypre, xpost, ypost, dist2parent, prob, connect, dist_f, alpha, beta, gap_conn, gap_prob, gap_ind_conn, ind_prob
int compt_pre_select, compt_post_select=0, compt_sub_select, cellCtr, branch_select, inter=0
str compt_1 = "soma", compt_2 = "primdend", compt_3 = "secdend", compt_4 = "tertdend"
str compname_pre, compname_post, compname, comn, comn2, comn_t, comn_t2
int n_syn, n_syn_allowed, n_ind, c_ctr=0, a_ctr=0, index1, index2, index2_2, gap_rand
int chem_gap, ind_gap, i
addglobal int prim_max_index1_SP 4
addglobal int prim_max_index2_SP 1
addglobal int sec_max_index1_SP 8
addglobal int sec_max_index2_SP 1
addglobal int tert_max_index1_SP 16
addglobal int tert_max_index2_SP 12
addglobal int prim_max_index1_FS 3
addglobal int prim_max_index2_FS 2
addglobal int sec_max_index1_FS 6
addglobal int sec_max_index2_FS 4
addglobal int tert_max_index1_FS 12
addglobal int tert_max_index2_FS 8
if ({net}=="FS" && {net2}=="FS")
inter=1
else
end 

  for(ctrpre = 0; ctrpre < {getglobal numCells_{net}}; ctrpre = {ctrpre + 1})  //loops through presynaptic cells
        xpre={getfield {network}[{ctrpre}]/soma/ x}  //get x location
	ypre={getfield {network}[{ctrpre}]/soma/ y}  //get y location

	for(ctrpost = 0; ctrpost < {getglobal numCells_{net2}}; ctrpost= {ctrpost +1})  //loops through postsynaptic cells

		if ({ctrpre}!={ctrpost}) //only if pre and post synaptic cells are different start connecting                                                                                                 
                   xpost={getfield {network2}[{ctrpost}]/soma/ x} //get x location
		   ypost={getfield {network2}[{ctrpost}]/soma/ y} //get y location

                   dist2parent={{pow {xpost-xpre} 2 } + {pow {ypost-ypre} 2}}   // calculating distance between the cells     
                   //echo {dist2parent} >> dist.log          
                   dist_f= {-dist2parent}/{pow {fact} 2}  
                   prob = {exp {dist_f}} //probability as a function of distance, so farther it is, lower the probability of connection              
                  /* elif ({net}=="FS" && {net2}=="FS")
                   prob = 0.5
                  */
                   connect = {rand 0 1} 
                   if ({connect}<{prob}) 
                     c_ctr=0  //counter to be incremented each time connection between pair established
		    
                     while ({c_ctr} < {loops})  //loop till reaches # of synaptic connections allowed between each pair of cells
                         if ({net}=="FS" && {net2}=="FS") 
                         compt_post_select = {rand 1 5}
                         end
                         if ({compt_post_select}==1)
                               n_syn = {getfield {network2}[{ctrpost}]/soma/GABA nsynapses}
                               if ({n_syn}==0)
                                n_ind = 0
                               else
                                n_ind = {n_syn-1}
                               end
                               n_syn_allowed = {getfield {network2}[{ctrpost}]/soma nsynallowed_g}
                               if (({n_syn}<{n_syn_allowed}) && ({connect}<{prob}))
			       addmsg {network}[{ctrpre}]/soma/spike \
				    {network2}[{ctrpost}]/soma/GABA SPIKE
                               setfield {network2}[{ctrpost}]/soma/GABA synapse[{n_ind}].weight {syn_weight1}
                               c_ctr = {c_ctr} + 1
                               end

                        elif ({compt_post_select}==2)
                      
                           branch_select = {rand 1 {{getglobal prim_max_index1_{net2}}*{getglobal prim_max_index2_{net2}}}}  //since this morphology has multiple compartments                                                                                             for each tertiary dendrite
                    
                           index1 = {branch_select}/{getglobal prim_max_index2_{net2}}  //sets quotient as tertdend number
                           index2_2 = {getglobal prim_max_index2_{net2}}
                           index2 = {branch_select}%{index2_2}  //sets remainder as tert_dend number
                       //    echo "index1="{index1}
                       //    echo "index2="{index2}
                           if ({index1}==0)
                             comn_t ="primdend1"
                           else
                             comn_t = "primdend"@{index1}
                           end
                           if ({index2}==1 || {index2}==0)  //no need to select tert_dend number for these cases
                               n_syn = {getfield {network2}[{ctrpost}]/{comn_t}/GABA nsynapses}
                               if ({n_syn}==0)
                                n_ind = 0
                               else
                                n_ind = {n_syn-1}
                               end
                               n_syn_allowed = {getfield {network2}[{ctrpost}]/{comn_t} nsynallowed_g}
                               if (({n_syn}<{n_syn_allowed}) && ({connect}<{prob}))
			       addmsg {network}[{ctrpre}]/soma/spike \
				    {network2}[{ctrpost}]/{comn_t}/GABA SPIKE
                               //echo "n synapses" {n_syn}
                               setfield {network2}[{ctrpost}]/{comn_t}/GABA synapse[{n_ind}].weight {syn_weight1}
                               c_ctr = {c_ctr} + 1
                                //if ({chem_gap}==1 && {inter}==1)
                                   gap_conn = {rand 0 1}
                                   if ({gap_conn}<{gap_prob})
                                   connectGap {network}[{ctrpre}]/{comn_t} {network2}[{ctrpost}]/{comn_t} {gap_res}
                                   echo {ctrpre}  {ctrpost}   {comn_t} >> gaps.log 
                                   end
                               //  elif ({ind_gap}==1 && {inter}==1)
                               //    gap_conn = {rand 0 1}
                               //    if ({gap_conn}<{ind_prob})
                               //    connectGap {network}[{ctrpre}]/{comn_t} {network2}[{ctrpost}]/{comn_t} {gap_res}
                               //    echo {ctrpre}  {ctrpost}   {comn_t} >> gaps.log
                               //   end
                               //  end
                               end
                           else
                              comn_t2 = "prim_dend"@{index2}
                              n_syn = {getfield {network2}[{ctrpost}]/{comn_t}/{comn_t2}/GABA nsynapses}
                              if ({n_syn}==0)
                                n_ind = 0
                               else
                                n_ind = {n_syn-1}
                               end
                              n_syn_allowed = {getfield {network2}[{ctrpost}]/{comn_t}/{comn_t2} nsynallowed_g}  
                              if (({n_syn}<{n_syn_allowed}) && ({connect}<{prob}))
			       addmsg {network}[{ctrpre}]/soma/spike \
				    {network2}[{ctrpost}]/{comn_t}/{comn_t2}/GABA SPIKE
                               setfield {network2}[{ctrpost}]/{comn_t}/{comn_t2}/GABA synapse[{n_ind}].weight {syn_weight1}
                               c_ctr = {c_ctr} + 1
                               // if ({chem_gap}==1 && {inter}==1)
                                   gap_conn = {rand 0 1}
                                   if ({gap_conn}<{gap_prob})
                                   connectGap {network}[{ctrpre}]/{comn_t}/{comn_t2} {network2}[{ctrpost}]/{comn_t}/{comn_t2} {gap_res}
                                   echo {ctrpre}  {ctrpost}   {comn_t} >> gaps.log
                                   end
                           /*      elif ({ind_gap}==1 && {inter}==1)
                                   gap_conn = {rand 0 1}
                                   if ({gap_conn}<{ind_prob})
                                   connectGap {network}[{ctrpre}]/{comn_t} {network2}[{ctrpost}]/{comn_t} {gap_res}
                                   echo {ctrpre}  {ctrpost}   {comn_t} >> gaps.log
                                   end
                                 end
*/
                              end

                           end

                        elif ({compt_post_select}==3)
                           branch_select = {rand 1 {{getglobal sec_max_index1_{net2}}*{getglobal sec_max_index2_{net2}}}}  //since this morphology has multiple compartments                                                                                             for each tertiary dendrite
                   //        echo "branch select"{branch_select}
                           index1 = {branch_select}/{getglobal sec_max_index2_{net2}}  //sets quotient as tertdend number
                           index2_2 = {getglobal sec_max_index2_{net2}}
                           index2 = {branch_select}%{index2_2}  //sets remainder as tert_dend number
                      //     echo "index1="{index1}
                      //     echo "index2="{index2}
                           if ({index1}==0)
                             comn_t ="secdend1"
                           else
                             comn_t = "secdend"@{index1}
                           end
                           if ({index2}==1 || {index2}==0)  //no need to select tert_dend number for these cases
                               n_syn = {getfield {network2}[{ctrpost}]/{comn_t}/GABA nsynapses}
                               if ({n_syn}==0)
                                n_ind = 0
                               else
                                n_ind = {n_syn-1}
                               end
                               n_syn_allowed = {getfield {network2}[{ctrpost}]/{comn_t} nsynallowed_g}
                               if (({n_syn}<{n_syn_allowed}) && ({connect}<{prob}))
			       addmsg {network}[{ctrpre}]/soma/spike \
				    {network2}[{ctrpost}]/{comn_t}/GABA SPIKE
                               //echo "n synapses" {n_syn}
                               setfield {network2}[{ctrpost}]/{comn_t}/GABA synapse[{n_ind}].weight {syn_weight1}
                               c_ctr = {c_ctr} + 1
                           //     if ({chem_gap}==1 && {inter}==1)
                                   gap_conn = {rand 0 1}
                                   if ({gap_conn}<{gap_prob})
                                   connectGap {network}[{ctrpre}]/{comn_t} {network2}[{ctrpost}]/{comn_t} {gap_res}
                                   echo {ctrpre}  {ctrpost}   {comn_t} >> gaps.log
                                   end
                          /*      elif ({ind_gap}==1 && {inter}==1)
                                   gap_conn = {rand 0 1}
                                   if ({gap_conn}<{ind_prob})
                                   connectGap {network}[{ctrpre}]/{comn_t} {network2}[{ctrpost}]/{comn_t} {gap_res}
                                   echo {ctrpre}  {ctrpost}   {comn_t} >> gaps.log
                                   end
                                 end
*/
                               end
                           else
                              comn_t2 = "sec_dend"@{index2}
                              n_syn = {getfield {network2}[{ctrpost}]/{comn_t}/{comn_t2}/GABA nsynapses}
                          //    echo "network2" {network2}
                          //    echo "cell no"{ctrpost} "comp1"{comn_t} "comp2" {comn_t2}
                              if ({n_syn}==0)
                                n_ind = 0
                               else
                                n_ind = {n_syn-1}
                               end  
                              n_syn_allowed = {getfield {network2}[{ctrpost}]/{comn_t}/{comn_t2} nsynallowed_g}  
                              if (({n_syn}<{n_syn_allowed}) && ({connect}<{prob}))
			       addmsg {network}[{ctrpre}]/soma/spike \
				    {network2}[{ctrpost}]/{comn_t}/{comn_t2}/GABA SPIKE
                               setfield {network2}[{ctrpost}]/{comn_t}/{comn_t2}/GABA synapse[{n_ind}].weight {syn_weight1}
                               c_ctr = {c_ctr} + 1
                             //   if ({chem_gap}==1 && {inter}==1)
                                   gap_conn = {rand 0 1}
                                   if ({gap_conn}<{gap_prob})
                                   connectGap {network}[{ctrpre}]/{comn_t}/{comn_t2} {network2}[{ctrpost}]/{comn_t}/{comn_t2} {gap_res}
                                   echo {ctrpre}  {ctrpost}   {comn_t} >> gaps.log
                                   end
                        /*        elif ({ind_gap}==1 && {inter}==1)
                                   gap_conn = {rand 0 1}
                                   if ({gap_conn}<{ind_prob})
                                   connectGap {network}[{ctrpre}]/{comn_t} {network2}[{ctrpost}]/{comn_t} {gap_res}
                                   echo {ctrpre}  {ctrpost}   {comn_t} >> gaps.log
                                   end
                                 end
*/
                              end

                           end                
 
     elif ({compt_post_select}==4)
    if ({net}=="FS" && {net2}=="SP") 
                      //    echo "tert" 
                          end
                           branch_select = {rand 1 {{getglobal tert_max_index1_{net2}}*{getglobal tert_max_index2_{net2}}}}  //since this morphology has multiple compartments                                                                                             for each tertiary dendrite
                    //       echo "branch select"{branch_select}
                           index1 = {branch_select}/{getglobal tert_max_index2_{net2}}  //sets quotient as tertdend number
                           index2_2 = {getglobal tert_max_index2_{net2}}
                           index2 = {branch_select}%{index2_2}  //sets remainder as tert_dend number
                     //      echo "index1="{index1}
                      //     echo "index2="{index2}
                           if ({index1}==0)
                             comn_t ="tertdend1"
                           else
                             comn_t = "tertdend"@{index1}
                           end
                           if ({index2}==1 || {index2}==0)  //no need to select tert_dend number for these cases
                               n_syn = {getfield {network2}[{ctrpost}]/{comn_t}/GABA nsynapses}
                               if ({n_syn}==0)
                                n_ind = 0
                               else
                                n_ind = {n_syn-1}
                               end
                               n_syn_allowed = {getfield {network2}[{ctrpost}]/{comn_t} nsynallowed_g}
                               if (({n_syn}<{n_syn_allowed}) && ({connect}<{prob}))
			       addmsg {network}[{ctrpre}]/soma/spike \
				    {network2}[{ctrpost}]/{comn_t}/GABA SPIKE
                               //echo "n synapses" {n_syn}
                               setfield {network2}[{ctrpost}]/{comn_t}/GABA synapse[{n_ind}].weight {syn_weight1}
                               c_ctr = {c_ctr} + 1
                        /*        if ({chem_gap}==1 && {inter}==1)
                                   gap_conn = {rand 0 1}
                                   if ({gap_conn}<{gap_prob})
                                   connectGap {network}[{ctrpre}]/{comn_t} {network2}[{ctrpost}]/{comn_t} {gap_res}
                                   echo {ctrpre}  {ctrpost}   {comn_t} >> gaps.log
                                   end
                                elif ({ind_gap}==1 && {inter}==1)
                                   gap_conn = {rand 0 1}
                                   if ({gap_conn}<{ind_prob})
                                   connectGap {network}[{ctrpre}]/{comn_t} {network2}[{ctrpost}]/{comn_t} {gap_res}
                                   echo {ctrpre}  {ctrpost}   {comn_t} >> gaps.log
                                   end
                                 end
*/
                               end
                           else
                              comn_t2 = "tert_dend"@{index2}
                              n_syn = {getfield {network2}[{ctrpost}]/{comn_t}/{comn_t2}/GABA nsynapses}
                              if ({n_syn}==0)
                                n_ind = 0
                               else
                                n_ind = {n_syn-1}
                               end
                              n_syn_allowed = {getfield {network2}[{ctrpost}]/{comn_t}/{comn_t2} nsynallowed_g}  
                              if (({n_syn}<{n_syn_allowed}) && ({connect}<{prob}))
			       addmsg {network}[{ctrpre}]/soma/spike \
				    {network2}[{ctrpost}]/{comn_t}/{comn_t2}/GABA SPIKE
                               setfield {network2}[{ctrpost}]/{comn_t}/{comn_t2}/GABA synapse[{n_ind}].weight {syn_weight1}
                               c_ctr = {c_ctr} + 1
/*
                                if ({chem_gap}==1 && {inter}==1)
                                   gap_conn = {rand 0 1}
                                   if ({gap_conn}<{gap_prob})
                                   connectGap {network}[{ctrpre}]/{comn_t}/{comn_t2} {network2}[{ctrpost}]/{comn_t}/{comn_t2} {gap_res}
                                   echo {ctrpre}  {ctrpost}   {comn_t} >> gaps.log
                                   end
                                elif ({ind_gap}==1 && {inter}==1)
                                   gap_conn = {rand 0 1}
                                   if ({gap_conn}<{ind_prob})
                                   connectGap {network}[{ctrpre}]/{comn_t} {network2}[{ctrpost}]/{comn_t} {gap_res}
                                   echo {ctrpre}  {ctrpost}   {comn_t} >> gaps.log
                                   end
                                 end
*/
	                      
                              end
                           end 
                       else 
                       end   

                      end //while
		   else
                   end
                 else
                 end
          end
   end
echo "End of netconn"
end


//Connect SP network
function netconn_SP(net,net2,network,network2,fact,SP,FS,int_perc)
        int SP, FS, pre_rem, prev
	str net,net2,network,network2,DA
	float fact, gap_res, int_perc
	int int_GABA= {round {{int_perc}*{getglobal nGABA_{net2}}}}	//intrinsic GABAergic input calculated
	int numCells_pre = {{SP}*{numCells_SP} + {FS}*{numCells_FS}}	//# of SP and FS GABAergic input
	int ctrpre, ctrpost, dctr,  densityMax_3_SP = 2, densityMax_4_SP = 2, increment=1, loops, inCtr, ctr_pre
	int break0=0, break1=0 , break2=0, break3=0, break4=0, break5=0, break6=0, break7=0
	float xpre, ypre, xpost, ypost, dist2parent, prob, connect, dist_f, alpha, beta, gap_conn, gap_prob, gap_ind_conn, ind_prob
	int compt_pre_select, compt_post_select=0, compt_sub_select, cellCtr, branch_select, inter=0
	str compt_1 = "soma", compt_2 = "primdend", compt_3 = "secdend", compt_4 = "tertdend"
	str compname_pre, compname_post, compname, comn, comn2, comn_t, comn_t2
	int n_syn, n_syn_allowed, n_ind, c_ctr, a_ctr=0, index1, index2, index2_2, gap_rand
	int chem_gap, ind_gap, i
	addglobal int prim_max_index1_SP 4
	addglobal int prim_max_index2_SP 1
	addglobal int sec_max_index1_SP 8
	addglobal int sec_max_index2_SP 1
	addglobal int tert_max_index1_SP 16
	addglobal int tert_max_index2_SP 12
	addglobal int prim_max_index1_FS 3
	addglobal int prim_max_index2_FS 2
	addglobal int sec_max_index1_FS 6
	addglobal int sec_max_index2_FS 4
	addglobal int tert_max_index1_FS 12
	addglobal int tert_max_index2_FS 8
	addglobal int nsyn_FS 22701
	addglobal int nsyn_SP 16000
	addglobal int ctr_SP 0
	addglobal int ctr_FS 15999
	//int proximal = {densityMax_soma_GABA_SP} + {densityMax_pd_GABA_SP}*{prim_dend_num_SP} + {densityMax_sd_GABA_SP}*{sec_dend_num_SP}
	int i,j,k,x,p,w=0
	int min_SP=1 //oorschot 18% somal
	str InsignalPath=""
        //setting the branches based on number of GABAergic synapses
	for (i=1; i<{{densityMax_soma_GABA_SP}+1}; i={i+1})
		addglobal str branch_{i} "soma"
   		addglobal str branch2_{i} "" 
	end 
   	x={i}
  	j=0
   	k=1
   	for (i={x}; i<{{x}+{{densityMax_pd_GABA_SP}*{prim_dend_num_SP}}}; i={i+1})
   		j = {j+1}
   		if (({j}%{{densityMax_pd_GABA_SP}+1})==0)
    			k={k+1}
   		end
   		addglobal str branch_{i} "primdend"{k}""
   		addglobal str branch2_{i} ""
   	end 
   	x={i}
	j=0
   	k=1
   	for (i={x}; i<{{x}+{{densityMax_sd_GABA_SP}*{sec_dend_num_SP}}}; i={i+1})
   		j = {j+1}
   		if (({j}%{{densityMax_sd_GABA_SP}+1})==0)
    			k={k+1}
   		end
   		addglobal str branch_{i} "secdend"{k}""
   		addglobal str branch2_{i} ""
   	end 
   	x={i}
   	int max_FS={x-4}   //index starts from 0 and FS proximal
   	//echo "max_fs" {max_FS}
   	j=0
   	k=1
   	for (i={x}; i<{{x}+{{densityMax_td_GABA_SP}*{tert_dend_num_SP}}}; i={i+1})
   		j = {j+1}
   		w = {w+1}
   		if (({j}%{{{densityMax_td_GABA_SP}*11}+1})==0)
    			k={k+1}
    			w=1
   		end
   		addglobal str branch_{i} "tertdend"{k}""
   		if ({w}>1 && {w<12})
   			addglobal str branch2_{i} "tert_dend"{w}""
   		else
   			addglobal str branch2_{i} ""
   		end
   	end  
	if (!{exists synap})
   		create tabchannel synap  
   	end
   	disable synap
   	int tablemax = {getglobal nGABA_{net2}}
	if (!{exists pre})
   		create tabchannel pre  
   	end
   	disable pre
	if (!{exists pre_num})
   		create tabchannel pre_num  
   	end
   	disable pre_num   
   	call pre_num TABCREATE X {{getglobal numCells_{net2}}-1} 0 {{getglobal numCells_{net2}}-1}
   	for (i=0; i<{getglobal numCells_{net2}}; i={i+1})
      		setfield pre_num X_B->table[{i}] 1
   	end 
	if (!{exists pre_spk})
   		create tabchannel pre_spk  
   	end
   	disable pre_spk
   	call pre_spk TABCREATE X {{getglobal numCells_{net2}}-1} 0 {{getglobal numCells_{net2}}-1}
   	call pre_spk TABCREATE Y {{getglobal numCells_{net2}}-1} 0 {{getglobal numCells_{net2}}-1}
   	call pre_spk TABCREATE Z {{getglobal numCells_{net2}}-1} 0 {{getglobal numCells_{net2}}-1}
   	for (i=0; i<{getglobal numCells_{net2}}; i={i+1})
      		setfield pre_spk X_A->table[{i}] 0
      		setfield pre_spk X_B->table[{i}] 0
      		setfield pre_spk Y_A->table[{i}] 0
   	end 
	//int nu = {getglobal nUnique_g_{net2}}
        //create tabchannel for type of extrinsic input
	/*
   	if (!{exists inp_fil})
   		create tabchannel inp_fil  
   	end
   	disable inp_fil
   	int tabmax = {getglobal nGABA_{net2}}  //set tablemax to be number of synaptic inputs
  	call inp_fil TABCREATE X {{tabmax}-1} 0 {{tabmax}-1}
   	for (i=0; i<{nu}; i={i+1})
       		setfield inp_fil X_B->table[{i}] 0  //0 represents unique inputs
   	end
 	for (i=0; i<{getglobal nDups_g_{net2}}; i={i+1})
       		setfield inp_fil X_B->table[{i+nu}] 1    //1 represents duplicate inputs
   	end 
   	if ({int_perc}!=1)
       		readInputdFromFile {net2} "GABAinsignal_d_" \
                    "INPUTDATA_SP/GABAinsignal_dup_" \
                    {getglobal nDups_g_{net2}}      
   	end
	*/
	/* 
   	echo "Number of Pre-synaptic spikes from SP neurons to each Post-synaptic SP neuron" >>SP.log
   	echo "Post-Synaptic Neuron" -n >>SP.log
   	echo "#Spikes" -f %20s >> SP.log 
   	echo "Number of Pre-synaptic spikes from FS neurons to each Post-synaptic SP neuron" >>FS.log
   	echo "Post-Synaptic Neuron" -n >>FS.log
   	echo "#Spikes" -f %20s >> FS.log 
   	echo "Number of spikes from Extrinsic trains to each Post-synaptic SP neuron" >>ext.log
   	echo "Post-Synaptic Neuron" -n >>ext.log
   	echo "#Spikes" -f %20s >>ext.log 
	*/  
   	//Following loops for writing distance log function
	for(ctrpre = 0; ctrpre < {getglobal numCells_{net}}; ctrpre = {ctrpre + 1})  //loops through presynaptic cells
        	xpre={getfield {network}[{ctrpre}]/soma/ x}  //get x location
		ypre={getfield {network}[{ctrpre}]/soma/ y}  //get y location
		for(ctrpost = 0; ctrpost < {getglobal numCells_{net2}}; ctrpost= {ctrpost +1})  //loops through postsynaptic cells
			if ({ctrpre}!={ctrpost}) 
                        	xpost={getfield {network2}[{ctrpost}]/soma/ x} //get x location
		   		ypost={getfield {network2}[{ctrpost}]/soma/ y} //get y location
				dist2parent={{pow {xpost-xpre} 2 } + {pow {ypost-ypre} 2}}   // calculating distance between the cells     
                   		echo {dist2parent} >> dist.log    
                  	end
		end
	end
        //Following loops for connecting neurons to GABAergic input both extrinsic and intrinsic
        //Loops through post-synaptic neuron and then decides pre-synaptic neuron for each one
 	for(ctrpost = 0; ctrpost < {getglobal numCells_{net2}}; ctrpost = {ctrpost + 1})  //loops through postsynaptic cells
        	xpost={getfield {network2}[{ctrpost}]/soma/ x}	//get x location of post-synaptic neuron
		ypost={getfield {network2}[{ctrpost}]/soma/ y}	//get y location of post-synaptic neuron		  
          	//If extrinsic input exists then read in the unique input files
		if ({int_perc}!=1)
        		readInputFromFile {net2} "GABAinsignal_u_"{ctrpost}"_" \
		            "INPUTDATA_SP/GABAinsignal_"{{ctrpost}+1}"_" \
                    	{getglobal nGABA_{net2}} {nGABA_SP}      
        	end
		call synap TABCREATE X {{tablemax}-1} 0 {{tablemax}-1}
        	for (i=0; i<{tablemax}; i={i+1})
        		setfield synap X_A->table[{i}] {i} 
        	end
                //tabchannel for indices of intrinsic presynaptic neurons
		call pre TABCREATE X {{numCells_pre}-1} 0 {{numCells_pre}-1}
        	for (i=0; i<{numCells_pre}; i={i+1})
        		setfield pre X_A->table[{i}] {i} 
        	end
		if ({getfield /SPnetwork/SPcell[{ctrpost}]/soma D1} == 1)
                        DA = "D1"
			int_GABA=136 //60%
                elif ({getfield /SPnetwork/SPcell[{ctrpost}]/soma D1} == 0) 
                        DA = "D2"
			int_GABA=181 //80%
                end
 		c_ctr = 0
                //Connect all intrinsic input by calling random number from the pre tabchannel
        	while ({c_ctr} < {int_GABA})  
                        //if random number tabchannel empty replenish it
        		if ({pre_rem}==-1)
           			call pre TABCREATE X {{numCells_pre}-1} 0 {{numCells_pre}-1}
           			for (i=0; i<{numCells_pre}; i={i+1})
             				setfield pre X_A->table[{i}] {i} 
           			end 
           			prev = {getfield pre_num X_B->table[{ctrpost}]}
           			setfield pre_num X_B->table[{ctrpost}] {prev+1}
        		end	  
        		ctrpre = {rannum_new pre}	//randomly select presynaptic neuron 
        		pre_rem = {getfield pre X_A->xmax}	//check number of elements left to make sure tabchannel not empty 
        		//if the randomly selected number is in the FS range then use FS-SP connection probabilities
                        if ({ctrpre}>{{numCells_SP}-1})
        			ctr_pre = {{ctrpre}-{numCells_SP}}
        			net="FS"
				if ({DA}=="D1")
        			 prob=0.20  // FS -55%
				elif ({DA}=="D2")
				 prob=0.20 //to double have to increase to this value //FS- 62.5%
				end
        			//echo "ctrpre FS" {ctrpre} 
			//else if either intrisic SP connections are present or extrinsic is absent and at the same time
    			//random number is in the SP range then use SP-SP presynaptic connection values
        		elif (({SP}==1 && {FS}==0)||({SP}==1 && {FS}==1 && {ctrpre}<{numCells_SP}))
        			ctr_pre={ctrpre}
        			net="SP"
        			//echo "ctrpre SP" {ctrpre} 
        			xpre={getfield ""/{net}"network/"{net}"cell"[{ctr_pre}]/soma/ x} //get x location
        			ypre={getfield ""/{net}"network/"{net}"cell"[{ctr_pre}]/soma/ y} //get y location
        			dist2parent={{pow {xpost-xpre} 2 } + {pow {ypost-ypre} 2}}   // calculating distance between the cells
        			dist_f= {-dist2parent}/{pow {fact} 2}  
        			//echo "dist_f" {dist_f}
       	 			prob = {exp {dist_f}} //probability as a function of distance, so farther it is, lower the probability of connection              
				if (({getfield /SPnetwork/SPcell[{ctrpre}]/soma D1} == 1) && ({getfield /SPnetwork/SPcell[{ctrpost}]/soma D1} == 1))
					prob=0
				end
			//else if FS are the only intrinsic connection just continue using the FS probability 
			elif ({SP}==0 && {FS}==1)
        			ctr_pre = {ctrpre}
        			net="FS"
				if ({DA}=="D1")
        			 prob=0.35
				elif ({DA}=="D2")
				 prob=0.60 //to double have to increase to this value
				end
        		end
        		//echo "ctrpost" {ctrpost} 
                        //Now after the appropriate connection probability is connected, connect it up
        		connect = {rand 0 1} 
        		if ({connect}<{prob})
				inCtr = {{rannum_net synap {net} {min_SP} {max_FS} {int_perc}} +1}
        			if ({net}=="SP")
					echo {ctrpre} {ctrpost} >> sync_conn.log
            				p = {getfield pre_spk X_A->table[{ctrpost}]}
            				setfield pre_spk X_A->table[{ctrpost}] {p+1}
        			elif ({net}=="FS")
            				p = {getfield pre_spk X_B->table[{ctrpost}]}
            				setfield pre_spk X_B->table[{ctrpost}] {p+1}
        			end
                                //if branch does not have another sub-branch connect 1 way or connect it the other way
           			//the #of synapses obtained for the 2 cases
				if ({getglobal branch2_{inCtr}}=="")
            				n_syn = {getfield {network2}[{ctrpost}]/{getglobal branch_{inCtr}}/GABA nsynapses}
           			else
            				n_syn = {getfield {network2}[{ctrpost}]/{getglobal branch_{inCtr}}/{getglobal branch2_{inCtr}}/GABA nsynapses}       
           			end
				//get synapse index
        			if ({n_syn}==0)
       					n_ind = 0
        			else
        				n_ind = {n_syn-1}
        			end
				//connecting the neurons
				if ({getglobal branch2_{inCtr}}=="")
        				addmsg ""/{net}"network/"{net}"cell"[{ctr_pre}]/soma/spike \
	        			{network2}[{ctrpost}]/{getglobal branch_{inCtr}}/GABA SPIKE
        				setfield {network2}[{ctrpost}]/{getglobal branch_{inCtr}}/GABA synapse[{n_ind}].weight {getglobal weight_{net}_{DA}}
        			else
        				addmsg ""/{net}"network/"{net}"cell"[{ctr_pre}]/soma/spike \
	        			{network2}[{ctrpost}]/{getglobal branch_{inCtr}}/{getglobal branch2_{inCtr}}/GABA SPIKE
        				setfield {network2}[{ctrpost}]/{getglobal branch_{inCtr}}/{getglobal branch2_{inCtr}}/GABA synapse[{n_ind}].weight {getglobal weight_{net}_{DA}}
        			end
        			c_ctr = {c_ctr} + 1
        		end   
        	end      
                //if the counter is less than the total GABAergic input that means extrinsic input also exists
                //in that case connect the extrinsic input to the neurons
		/*
        	while ({c_ctr} < {getglobal nGABA_{net2}})
           		inCtr = {{rannum_net synap {net} {min_SP} {max_FS} {int_perc}} +1}	//random # based on what is already filled 
           		
			if ({getfield inp_fil X_B->table[{inCtr}]}==1) //if duplicate then addmsg from duplicate filenames
           			InsignalPath = "/input2/GABAinsignal_d_"
           		else
           			InsignalPath = "/input2/GABAinsignal_u_"{ctrpost}"_"
           		end
					
			if ({getglobal branch2_{inCtr}}=="")
            			n_syn = {getfield {network2}[{ctrpost}]/{getglobal branch_{inCtr}}/GABA nsynapses}
            			if ({n_syn}==0)
            				n_ind = 0
            			else
            				n_ind = {n_syn-1}
            			end
            			addmsg "/input2/GABAinsignal_u_"{ctrpost}"_"[{inCtr-1}]/spikes \
	        		{network2}[{ctrpost}]/{getglobal branch_{inCtr}}/GABA SPIKE
            			setfield {network2}[{ctrpost}]/{getglobal branch_{inCtr}}/GABA synapse[{n_ind}].weight {getglobal weight_SP_{DA}}
           		else
            			n_syn = {getfield {network2}[{ctrpost}]/{getglobal branch_{inCtr}}/{getglobal branch2_{inCtr}}/GABA nsynapses} 
            			if ({n_syn}==0)
            				n_ind = 0
            			else
            				n_ind = {n_syn-1}
            			end
            			addmsg "/input2/GABAinsignal_u_"{ctrpost}"_"[{inCtr-1}]/spikes \
	        		{network2}[{ctrpost}]/{getglobal branch_{inCtr}}/{getglobal branch2_{inCtr}}/GABA SPIKE
            			setfield {network2}[{ctrpost}]/{getglobal branch_{inCtr}}/{getglobal branch2_{inCtr}}/GABA synapse[{n_ind}].weight {getglobal weight_SP_{DA}}    
            			p = {getfield pre_spk Y_A->table[{ctrpost}]}
            			setfield pre_spk Y_A->table[{ctrpost}] {p+1}	//get number of synapses for each presynaptic input type
           		end	   
       			c_ctr = {c_ctr} + 1
       		end 
		*/
       		setfield pre_num X_A->table[{ctrpost}] {{numCells_pre}-{pre_rem}+1}
		if ({DA}=="D1")
        		echo {{getfield pre_spk X_A->table[{ctrpost}]}/136} >> SP_D1.log 
       			echo {{getfield pre_spk X_B->table[{ctrpost}]}/136} >> FS_D1.log 
       			echo {{getfield pre_spk Y_A->table[{ctrpost}]}/227} >> ext_D1.log
		elif ({DA}=="D2")
			echo {{getfield pre_spk X_A->table[{ctrpost}]}/181} >> SP_D2.log 
       			echo {{getfield pre_spk X_B->table[{ctrpost}]}/181} >> FS_D2.log 
       			echo {{getfield pre_spk Y_A->table[{ctrpost}]}/227} >> ext_D2.log
		end 
  	end     
end 
























