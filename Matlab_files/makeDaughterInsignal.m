%
% Generates 2Hz square waves with 0.5 dutycycle.
%

function insignal = makeDaughterInsignal(corr_syn, nSyn, ...
                                      upFreq, downFreq, maxTime)

  nShare = nSyn - sqrt(corr_syn)*(nSyn-1);
  pShare = 1/nShare;
  
  baseFreq = 2.5;
  dutyCycle = 0.5;
  
  stateTime = dutyCycle/baseFreq;
  isUpstate = 1; % Start with upstate
  startTime = 0;
  
  motherSpikes = [];
  
  for startTime = 0:stateTime:(maxTime-stateTime)
      if(isUpstate)
          curFreq = upFreq*nShare;          
      else
          curFreq = downFreq*nShare;          
      end
      
      motherSpikes = [motherSpikes; ...
                      startTime + poissonMaxTime(curFreq, stateTime)];
      
      isUpstate = ~isUpstate;
  end
  
  len = length(motherSpikes);

  v = (rand(len, nSyn) < pShare).*repmat(motherSpikes,1,nSyn);
  v(find(v == 0)) = inf;
  v = sort(v);
  vlen = 1+max(mod(find(v < inf) - 1, len));
  insignal = v(1:vlen,:);
  
  
