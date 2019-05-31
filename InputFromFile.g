//genesis
//InputFromFile.g
/*
1. What this file does:
This file has the functions for reading in the input from the file  
into tables in genesis and for connecting these inputs to the synapses
of the cells. The connectInsignalToCell function takes as input
EACH individual cell name (SPcell(1) as oppossed to SPcell) and for that
cell loops through the different synapses in the different compartments
2. What this file does NOT do:
This file does not randomize the connection of the inputs to the synapses.
That function is performed in SimFile.g

NOTE: The files are generated in MATLAB with the ASSUMPTION that we are hooking
up every single input in the network. So at a minimum we must have enough inputs 
for the synapses described in the nsynapses file.

Please note that readInputFromFile assumes that the files are numbered
from 1 and up, whereas the input naming convention starts from 0
*/
////////////////////////////////////////////////////////////////////////////////

//Connect the files for the unique inputs from the MATLAB files to the timetables.

function readInputFromFile(net, inputName, filePath, SynNum, Unique)

    str inputName
    str filePath
    int SynNum
    int Unique
    

  if ({net}=="FS")
     str inputBasePath = "/input"
  else
  end
  if ({net}=="SP")
     str inputBasePath = "/input2" 
  else
  end
    
    int ctr
    
    str inputPath = {inputBasePath}@"/"@{inputName}

    if({tmax} == 0)
//        echo "readInputFromFile: Error, maxTime is set to 0"
        quit
    end

    if(!{exists {inputBasePath}})
        create neutral {inputBasePath}
    end

//    echo "Reading from "{filePath}" files 1 to "{SynNum}
//    echo "Connecting input to "{inputPath}[0]" to "[{{SynNum}-1}]
    
    pushe {inputBasePath}

    for(ctr = 0; ctr < {Unique}; ctr = {ctr + 1})

        create timetable {inputName}[{ctr}]
        setfield {inputName}[{ctr}] maxtime {maxTime} \
                                    method 4 \
                                    act_val 1.0 \ 
                                    fname {filePath}{{ctr}+1}".txt" //connect input from file with filename given in filepath 

        call {inputName}[{ctr}] TABFILL

        create spikegen {inputName}[{ctr}]/spikes

        setfield {inputName}[{ctr}]/spikes \
                 output_amp 1 thresh 0.5 abs_refract 0.0001

        addmsg {inputName}[{ctr}] {inputName}[{ctr}]/spikes \
               INPUT activation
        
    end
   
    pope

end

//Connect the files for the duplicate inputs

function readInputdFromFile(net,inputName, filePath_d, Dups)

    str inputName    
	str filePath_d
	int Dups
   if ({net}=="FS")
     str inputBasePath = "/input"
  else
     str inputBasePath = "/input2" 
  end

    int ctr
//input name has cell number embedded and dup vs unique
    str inputPath = {inputBasePath}@"/"@{inputName}

//echo "Connecting duplicate input to "{inputPath}[0]" to "[{{nAMPA}-1}]

   pushe {inputBasePath}

//input name (inputPath) will not have a cell number
    for(ctr = 0; ctr < {Dups}; ctr = {ctr + 1})
        
        create timetable {inputName}[{ctr}]
        setfield {inputName}[{ctr}] maxtime {maxTime} \
                                    method 4 \
                                    act_val 1.0 \ 
                                    fname {filePath_d}{{ctr}+1}".txt" //Call the files generated to provide duplicate inputs

        call {inputName}[{ctr}] TABFILL

        create spikegen {inputName}[{ctr}]/spikes

        setfield {inputName}[{ctr}]/spikes \
                 output_amp 1 thresh 0.5 abs_refract 0.0001

        addmsg {inputName}[{ctr}] {inputName}[{ctr}]/spikes \
               INPUT activation
        
    end	
  pope

end



//////////////////////////////////////////////////////////////////////////////
//
// Connects insignal objects to the synapses of the cells
//
//////////////////////////////////////////////////////////////////////////////

//Function to randomly select the input file names from the tabchannels

function rannum_unique (tablename)
  
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

//connects the timetable input to the SP network

function connectInsignalToCell(net,NetworkName,InsignaluName,InsignaldName,channelType,nu,nd,f_weight,s_weight)
  
    str NetworkName, InsignaluName, InsignaldName, channelType, compName, compN
    int insignalCtr = 0, dCtr, nsyn, nu, nd, i, tablemax, nsyn_allowed, f_weight, s_weight, nu_syn
    if ({net}=="FS")
    str inputBasePath = "/input"
    else
    str inputBasePath = "/input2"
    end
    // str networkBasePath = "/{net}network" 
    //input name has cell number embedded and dup vs unique
    str InsignaluPath = {inputBasePath}@"/"@{InsignaluName}
    str InsignaldPath = {inputBasePath}@"/"@{InsignaldName}
    //str NetworkPath =  {networkBasePath}@"/"@{NetworkName}
    str NetworkPath =  {NetworkName}   

//      echo "The function connectInsignal has been called"
//      echo "Networkname=" {NetworkName} {InsignaluName} {InsignaldName}
 
   create tabchannel inp  //create a table to contain the indices of the filenames
   disable inp
   if ({channelType}=="NR2A")
      tablemax = {getglobal nAMPA_{net}}
   else
      tablemax = {getglobal n{channelType}_{net}}  //set tablemax to be number of synaptic inputs
   end
   call inp TABCREATE X {{tablemax}-1} 0 {{tablemax}-1}
   for (i=0; i<{nu}; i={i+1})
       setfield inp X_A->table[{i}] {i} //indices of unique filenames
       setfield inp X_B->table[{i}] 0  //0 represents unique indices
   end
 
   for (i=0; i<{nd}; i={i+1})
       setfield inp X_A->table[{i+nu}] {i}  //indices of duplicate filenames
       setfield inp X_B->table[{i+nu}] 1    //1 represents duplicate indices
   end 
  
    // Connect to all compartments till we reach synapse number
                 int c=0
                 foreach compName ({el {NetworkPath}/##[TYPE=compartment]}) 
                      
                        c = {c}+1
                        compN = {getpath {compName} -tail}
                        nsyn = {getfield {compName}/{channelType} nsynapses}
                        if ({channelType}=="AMPA" || {channelType}=="NR2A")
                           nsyn_allowed = {getfield {compName} nsynallowed_a} 
                        elif ({channelType}=="GABA")
                           nsyn_allowed = {getfield {compName} nsynallowed_g}
                        else
                        end
                       // echo "compartment="{compN}
                        while ({nsyn}<{nsyn_allowed})
                                //echo "nsyn="{nsyn}
                               // echo "nsyn_allowed="{nsyn_allowed} 
                                insignalCtr = {rannum_unique inp}  //select index randomly using function above
				if ({getfield inp X_B->table[{insignalCtr}]}==1) //if duplicate then addmsg from duplicate filenames
                                     addmsg {InsignaldPath}[{insignalCtr}]/spikes {compName}/{channelType} SPIKE
				else
                                     addmsg {InsignaluPath}[{insignalCtr}]/spikes {compName}/{channelType}  SPIKE //or unique
                                end  
                                nsyn = {getfield {compName}/{channelType} nsynapses}  //update nsyn for while check
                                nu_syn={nsyn}-1
                                if ({channelType}=="GABA")   
                                    setfield {compName}/{channelType} synapse[{nu_syn}].weight {f_weight}
                                else
                                    setfield {compName}/{channelType} synapse[{nu_syn}].weight {getglobal weight_C_{net}}
                                end
			end
                if ({c}==(1+{getglobal prim_dend_num_{net}}+{getglobal sec_dend_num_{net}}+{getglobal tert_dend_num_{net}}))
                  c=0
                else
                end
                end
call inp TABDELETE
delete inp
//reclaim    //reclaim occupied space
end                    

function connectInsignalToCell_SP(net,NetworkName,InsignaluName,InsignaldName, channelType,nu,nd,f_weight,s_weight)
  
     str NetworkName, InsignaluName, InsignaldName, channelType, compName, compN
    int insignalCtr = 0, dCtr, nsyn, nu, nd, i, tablemax, nsyn_allowed, f_weight, s_weight, nu_syn
    if ({net}=="FS")
    str inputBasePath = "/input"
    else
    str inputBasePath = "/input2"
    end
    // str networkBasePath = "/{net}network" 
    //input name has cell number embedded and dup vs unique
    str InsignaluPath = {inputBasePath}@"/"@{InsignaluName}
    str InsignaldPath = {inputBasePath}@"/"@{InsignaldName}
    //str NetworkPath =  {networkBasePath}@"/"@{NetworkName}
    str NetworkPath =  {NetworkName}   

//      echo "The function connectInsignal has been called"
//      echo "Networkname=" {NetworkName} {InsignaluName} {InsignaldName}
 
   create tabchannel inp  //create a table to contain the indices of the filenames
   disable inp
   if ({channelType}=="NR2A")
      tablemax = {getglobal nAMPA_{net}}
   else
      tablemax = {getglobal n{channelType}_{net}}  //set tablemax to be number of synaptic inputs
   end
   call inp TABCREATE X {{tablemax}-1} 0 {{tablemax}-1}
   for (i=0; i<{nu}; i={i+1})
       setfield inp X_A->table[{i}] {i} //indices of unique filenames
       setfield inp X_B->table[{i}] 0  //0 represents unique indices
   end
 
   for (i=0; i<{nd}; i={i+1})
       setfield inp X_A->table[{i+nu}] {i}  //indices of duplicate filenames
       setfield inp X_B->table[{i+nu}] 1    //1 represents duplicate indices
   end 
  
    // Connect to all compartments till we reach synapse number
                 int c=0
                 foreach compName ({el {NetworkPath}/##[TYPE=compartment]}) 
                      
                        c = {c}+1
                        compN = {getpath {compName} -tail}
                        nsyn = {getfield {compName}/{channelType} nsynapses}
                        if ({channelType}=="AMPA" || {channelType}=="NR2A")
                           nsyn_allowed = {getfield {compName} nsynallowed_a} 
                        elif ({channelType}=="GABA")
                           nsyn_allowed = {getfield {compName} nsynallowed_g}
                        else
                        end
                       // echo "compartment="{compN}
                        while ({nsyn}<{nsyn_allowed})
                                //echo "nsyn="{nsyn}
                               // echo "nsyn_allowed="{nsyn_allowed} 
                                insignalCtr = {rannum_unique inp}  //select index randomly using function above
				if ({getfield inp X_B->table[{insignalCtr}]}==1) //if duplicate then addmsg from duplicate filenames
                                     addmsg {InsignaldPath}[{insignalCtr}]/spikes {compName}/{channelType} SPIKE
				else
                                     addmsg {InsignaluPath}[{insignalCtr}]/spikes {compName}/{channelType}  SPIKE //or unique
                                end  
                                nsyn = {getfield {compName}/{channelType} nsynapses}  //update nsyn for while check
                                nu_syn={nsyn}-1
                                if ({channelType}=="GABA")   
                                    setfield {compName}/{channelType} synapse[{nu_syn}].weight {f_weight}
                                else
                                    setfield {compName}/{channelType} synapse[{nu_syn}].weight {getglobal weight_C_{net}}
                                end
			end
                if ({c}==(1+{getglobal prim_dend_num_{net}}+{getglobal sec_dend_num_{net}}+{getglobal tert_dend_num_{net}}))
                  c=0
                else
                end
                end
call inp TABDELETE
delete inp
//reclaim    //reclaim occupied space
end          

//////////////////////////////////////////////////////////////////////////////
