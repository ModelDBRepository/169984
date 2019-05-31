%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This simple function receives a matrix 'spike_times' where each line represents a neuron
% index and each column represents one discrete time step where a spike might have occurred
% or not. If it has a line will be drawn otherwise nothing is done.
%
% Developed by Rodrigo F. Oliveira 2004-2006
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function rasterplot(spike_times)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[n_neurons, t_spk]=size(spike_times);
cla;
hold on;
        I=1;
        for i=1:n_neurons
            s=1;
            for t_spk=1:t_spk
                %plot([stimes(i,r,s)],[i],'.','MarkerSize',3)    % use for very heavy rasterplots
                line([spike_times(i,t_spk) spike_times(i,t_spk)],[I I+0.95],'LineWidth',0.7,'Color','k')
                s=s+1;
            end
            I=I+1;
        end
set(gca,'XLim',[0 max(max(spike_times))]);
set(gca,'YLim',[1 n_neurons+1]);
title('FS new');
xlabel('Time (s)');
ylabel('Neuron index');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
