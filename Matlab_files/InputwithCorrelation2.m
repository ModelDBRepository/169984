%Notes for Dr. Blackwell from Sriram:
%Different from InpurwithCorrelation: downfreq:0.1 and using makeDaughterInsignal so has both down and up states
%1. What this file does:
% This file makes the input trains that would serve as the cortical and fs input
% for the SPcells. The duplicate and unique input signals are now combined in
% the genesis file SimFile.g. This file also has a variable which contains 
% unique random numbers, the function of which is described in the SimFile.g
% file. The noise and inout signals will be combined in this file for the 
% next round once the details of the input connection is finalized. 

function m = InputwithCorrelation2(numCells, corr_syn_Glu, nAMPA, nAMPA_u, ...
								  corr_syn_GABA, nGABA, nGABA_u, perc_single_repeats, upFreq, maxTime,allowVar, randSeed)
                                 
	rand('seed', randSeed);
	randSeed = rand('seed');
	downFreq = 0.1;

	disp(['Setting random seed to ' num2str(randSeed)])
	disp(['All upstate input, freq ' num2str(upFreq)])

	path = [pwd '/INPUTDATA/'];
	fprintf('%s\n',path);

	nAMPA_d = nAMPA - nAMPA_u;
	nGABA_d = nGABA - nGABA_u;


	if(allowVar)
		disp('Generating  input with varying number of duplicates within a neuron')
  
		  dupAMPAInsignal = makeDaughterInsignal(corr_syn_Glu, nAMPA_d, ...
							 upFreq,downFreq,  maxTime);

		dupGABAInsignal = makeDaughterInsignal(corr_syn_GABA, nGABA_d, ...
						       25,downFreq, maxTime);
 
		for nCtr = 1:numCells

			% Generate input to neurons that are correlated within the neuron
			% but not correlated between neurons. This input is then mixed
			% with the population shared input.
			% Neuron specific input
  
			AMPAInsignal{nCtr} = makeDaughterInsignal(corr_syn_Glu, nAMPA_u, ...
								  upFreq,downFreq, maxTime);

			GABAInsignal{nCtr} = makeDaughterInsignal(corr_syn_GABA, nGABA_u, ...
								  25, downFreq, maxTime);
		end

	else                                  
		disp('Generating input with constant number of duplicates within a neuron')  
  
		dupAMPAInsignal = makeTrainInsignal(corr_syn_Glu, nAMPA_d, ...
						    upFreq, downFreq, maxTime);

		dupGABAInsignal = makeTrainInsignal(corr_syn_GABA, nGABA_d, ...
						    25, downFreq, maxTime);

		for nCtr = 1:numCells

			% Generate input to neurons that are correlated within the neuron
			% but not correlated between neurons. This input is then mixed
			% with the population shared input.
			% Neuron specific input
  
			AMPAInsignal{nCtr} = makeTrainInsignal(corr_syn_Glu, nAMPA_u, ...
							       upFreq,downFreq, maxTime);

			GABAInsignal{nCtr} = makeTrainInsignal(corr_syn_GABA, nGABA_u, ...
							       25,downFreq, maxTime);
		end
    end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Presently both makeDaughterInput and makeTrainInput send the inputs with padded zeros. 
        % Eventually clean it up to send it as matrix.
	writeInput([path 'AMPAinsignal_dup_'], dupAMPAInsignal);
	writeInput([path 'GABAinsignal_dup_'], dupGABAInsignal);

	for nCtr = 1:numCells
         temp_AMPA = [path 'AMPAinsignal_' num2str(nCtr) '_'];
         temp_GABA = [path 'GABAinsignal_' num2str(nCtr) '_'];
	     writeInput(temp_AMPA, AMPAInsignal{nCtr});
         writeInput(temp_GABA, GABAInsignal{nCtr});
	end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

	fid = fopen([path 'inputInfo.txt'], 'w');

	fprintf(fid, '%s\n', 'Inputwithcorrelation');
	fprintf(fid, '%f\n', corr_syn_Glu);
	fprintf(fid, '%f\n', corr_syn_GABA);
	fprintf(fid, '%f\n', upFreq);
	fprintf(fid, '%f\n', downFreq);
	fprintf(fid, '%f\n', maxTime);
	fprintf(fid, '%d\n', randSeed);
	fprintf(fid, '%d\n', numCells);
	
	fclose(fid);
