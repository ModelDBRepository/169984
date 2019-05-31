%
% Generates 2Hz square waves with 0.5 dutycycle.
%

function insignal = makeTrainInsignal(corr_syn, nSyn, ...
                                      upFreq, downFreq, maxTime)

  nShare = nSyn - sqrt(corr_syn)*(nSyn-1);

  baseFreq = 2.5;
  dutyCycle = 0.5;
  
  stateTime = dutyCycle/baseFreq;
  
  
  for i=1:nShare

    isUpstate = 1; % Start with upstate
    startTime = 0;

    trainSpikes{i} = [];
    
    for startTime = 0:stateTime:(maxTime-stateTime)

      if(isUpstate)
          curFreq = upFreq;          
      else
          curFreq = downFreq;          
      end
      
      trainSpikes{i} = [trainSpikes{i}; ...
                        startTime + poissonMaxTime(curFreq, stateTime)];
      
      isUpstate = ~isUpstate;
      
    end          
         
  end
  
  allSpikes = [];
  
  for i=1:nShare
      allSpikes = [allSpikes; trainSpikes{i}];
  end
  
  % Sortera spikarna!
  allSpikes = sort(allSpikes);
  
 % disp('total antal spikar     unika')
 % [length(allSpikes) length(unique(allSpikes))]

  for i=1:nSyn
    finalSpikes{i} = [];
  end
  
  for i=1:length(allSpikes)
     repeats = nSyn / nShare;
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
  insignal = inf*ones(maxLen,nSyn);

  for i=1:nSyn
     insignal(1:length(finalSpikes{i}),i) = finalSpikes{i}; 
      
  end
  
