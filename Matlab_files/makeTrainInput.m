%
% Generates 2Hz square waves with 0.5 dutycycle.
%

function noise = makeTrainInput(corr_syn, percSingleRepeats, nSyn, freq, maxTime)

	nShare = nSyn - sqrt(corr_syn)*(nSyn-1);
	allSpikes = poissonMaxTime(freq*nShare, maxTime);
  
	for i=1:nSyn
		finalSpikes{i} = [];
	end
  
	for i=1:length(allSpikes)
		repeats = nSyn*percSingleRepeats;
		repeats = floor(repeats) + (rand(1) < mod(repeats,1));
		freeTrains = 1:nSyn;
     
		for j=1:repeats
			idx = ceil(length(freeTrains)*rand(1));
			trainIdx = freeTrains(idx);
			freeTrains(idx) = [];
			finalSpikes{trainIdx} = [finalSpikes{trainIdx}; allSpikes(i)];
		end     
	end

	for i=1:nSyn
		trainLen(i) = length(finalSpikes{i}); 
	end

	maxLen = max(trainLen); 
	noise = 0*ones(maxLen,nSyn);

	for i=1:nSyn
		noise(1:length(finalSpikes{i}),i) = finalSpikes{i}; 
	end
  
