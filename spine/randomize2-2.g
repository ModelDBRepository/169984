//randomize2-2.g
//both AMPA and GABA synaptic inputs to fs cell

function rannum_unique (tablename)
  str tablename

  int i

  int last={getfield inputs X_A->xmax}
  int index={trunc {rand 0 {n{channelType}}} }
  int filenum={getfield {tablename} X_A->table[{index}]}
  setfield {tablename} X_A->table[{index}] {getfield {tablename} X_A->table[{last}]}
  setfield {tablename} X_A->xmax {last-1}

  return {filenum}

end

/*This function is used when there are fewer input files than synapses.
All synapses get inputs, but some are duplicates, introducing correlation. */
function randomize2 (fileroot, GABAtert, GABAsec, GABAprim, Gluprim, Glusec, Glutert, type, corr)
  str fileroot, type
  int GABAtert, GABAsec, GABAprim
  int Gluprim, Glusec, Glutert
  float corr

  int loop1, loop2
  int rannum, i, last, j, k
  int numfiles

  // initialize total number of inputs and files
  int totalinputs
  totalinputs=(Gluprim+GABAprim)*7+(Glusec+GABAsec)*24+(Glutert+GABAtert)*96
  numfiles=totalinputs*(1-corr) +corr
  int loops=totalinputs/numfiles
  echo "totalinputs=" {totalinputs} "corr=" {corr} "numfiles=" {numfiles} "loops=" {loops}

  //create table to store filenumbers
  if ({exists inputs})
      delete inputs
  end
  create tabchannel inputs
  disable inputs
  call inputs TABCREATE X {totalinputs-1} 0 {totalinputs-1}
  j=0
  for (k=0; k<loops; k=k+1)
    for (i=0; i<numfiles; i=i+1)
        setfield inputs X_A->table[{j}] {i}
        j=j+1
    end
  end
  int remaining=totalinputs-j
  echo "j=" {j} "remaining=" {remaining} 
  if (remaining>0)
    int startfile={round {rand -0.499 {numfiles-remaining}} }
    for (i=startfile; i<(startfile+remaining); i=i+1)
      setfield inputs X_A->table[{j}] {i}
      j=j+1
    end
    echo "startfile=" {startfile} "endfile=" {i-1} "last j" {j-1}
  end

  //Choose input files randomly for each compartment 2
  if ({Gluprim} == 1)
    rannum={rannum_unique inputs }
    make_input /fs/soma/AMPA_channel soma_ampa_{type} {fileroot}{rannum}
  end
  for (j=1; j<={GABAprim}; j=j+1)
      rannum = {rannum_unique inputs }
	  make_input /fs/soma/GABA_channel soma_gaba{j}_{type} {fileroot}{rannum} 
  end
 
  //making synaptic inputs to primary dendrites
  for (loop1=1; loop1 < 4 ; loop1 = loop1+1) 
    if ({Gluprim} == 1)
      rannum={rannum_unique inputs }
      make_input /fs/primdend{loop1}/AMPA_channel primdend{loop1}_ampa_{type} {fileroot}{rannum}
      rannum={rannum_unique inputs }
      make_input /fs/primdend{loop1}/prim_dend2/AMPA_channel primdend{loop1}s2_ampa_{type} {fileroot}{rannum}
    end
    for (j=1; j<={GABAprim}; j=j+1)
      rannum={rannum_unique inputs }
      make_input /fs/primdend{loop1}/GABA_channel primdend{loop1}_gaba{j}_{type} {fileroot}{rannum}
      rannum={rannum_unique inputs }
      make_input /fs/primdend{loop1}/prim_dend2/GABA_channel primdend{loop1}s2_gaba{j}_{type} {fileroot}{rannum} 
    end
  end
 
//making inputs to secondary  dendrites.
for (loop1 = 1; loop1 < 7; loop1= loop1+1)  
    for (j=1; j<={Glusec}; j=j+1)
        rannum={rannum_unique inputs }
        make_input /fs/secdend{loop1}/AMPA_channel secdend{loop1}_ampa{j}_{type} {fileroot}{rannum} 
    end

  for (j=1; j<={GABAsec}; j=j+1)
    rannum={rannum_unique inputs }
    make_input /fs/secdend{loop1}/GABA_channel secdend{loop1}_gaba{j}_{type} {fileroot}{rannum} 
  end

  for (loop2 = 2; loop2 < 5; loop2 = loop2+1)
    for (j=1; j<={Glusec}; j=j+1)
        rannum={rannum_unique inputs }
        make_input /fs/secdend{loop1}/sec_dend{loop2}/AMPA_channel secdend{loop1}s{loop2}_ampa{j}_{type} {fileroot}{rannum}
    end

    for (j=1; j<={GABAsec}; j=j+1)
        rannum={rannum_unique inputs }
        make_input /fs/secdend{loop1}/sec_dend{loop2}/GABA_channel secdend{loop1}s{loop2}_gaba{j}_{type} {fileroot}{rannum}
    end
  end
end

//making synaptic inputs to tertiary dendrites
for (loop1 = 1; loop1 < 13; loop1= loop1+1)
    for (j=1; j<={Glutert}; j=j+1)
        rannum={rannum_unique inputs }
        make_input /fs/tertdend{loop1}/AMPA_channel tertdend{loop1}_ampa{j}_{type} {fileroot}{rannum}
    end
    if ({GABAtert} == 1)
      rannum={rannum_unique inputs }
      make_input /fs/tertdend{loop1}/GABA_channel tertdend{loop1}_gaba_{type} {fileroot}{rannum}
    end

  for (loop2 = 2; loop2 < 9; loop2 = loop2+1)
    for (j=1; j<={Glutert}; j=j+1)
      rannum={rannum_unique inputs }
      make_input /fs/tertdend{loop1}/tert_dend{loop2}/AMPA_channel tertdend{loop1}s{loop2}_ampa{j}_{type} {fileroot}{rannum}
    end

    if ({GABAtert} == 1)
      rannum={rannum_unique inputs }
      make_input /fs/tertdend{loop1}/tert_dend{loop2}/GABA_channel tertdend{loop1}s{loop2}_gaba_{type} {fileroot}{rannum}
    end
  end
end

echo "last=" {getfield inputs X_A->xmax}
end























