% http://en.wikipedia.org/wiki/Exponential_distribution
%
% -ln(u)/lambda
%

function p = poissonMaxTime(lambda, maxTime)

p = cumsum(-log(rand(ceil(lambda*maxTime),1))/lambda);
t = p(end) - log(rand(1))/lambda;

while(t < maxTime)
    p = [p; t];
    t = t - log(rand(1))/lambda;
end

p = p(find(p < maxTime),1);
