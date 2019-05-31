%
% Generates input for each cell with Nampa(nSyn)columns and rows proportional to freq*maxTime
% nSyn in the number of synapses
% corr_syn is the correlation between the synapses

function noise = makeDaughterInput(corr_syn, nSyn, freq, maxTime)

	nShare = nSyn - sqrt(corr_syn)*(nSyn-1);
	pShare = 1/nShare;
  
	motherSpikes = poissonMaxTime(freq*nShare, maxTime);
  
	len = length(motherSpikes); % # rows of final array

	v = (rand(len, nSyn) < pShare).*repmat(motherSpikes,1,nSyn); %0 indicates don't assign spikes and 1 assigns
	v(find(v == 0)) = inf;
	v = sort(v,1); % sorts each column in ascending order (2nd argument is ascending or descending)
	vlen = 1+max(mod(find(v < inf) - 1, len));
	v(find(v == inf)) = 0;
	noise = v(1:vlen,:);
  
