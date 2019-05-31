
%[nid_spk,t_spk] = textread('ex_pop.spk', '%d    %f'      );

[nid_spk,t_spk] = textread('FScell.spikes', '%d    %f'      );
t_start=0.0;
t_end=3.2;
for k=1:max(nid_spk)
      spikes = t_spk(nid_spk==k & t_spk>t_start & t_spk<t_end);
      if (isempty(spikes))
        spike_times(k,1) = 0;
        spike_freq(k)    = 0;
      else
        spike_freq(k)    = length(spikes);
        spike_times(k,1:spike_freq(k)) = spikes';
      end
end
rasterplot(spike_times(1:end,:));

for t=0:0.001:max(t_spk)
      spikes = t_spk(nid_spk==k & t_spk>t_start & t_spk<t_end);
      if (isempty(spikes))
        spike_times(k,1) = 0;
        spike_freq(k)    = 0;
      else
        spike_freq(k)    = length(spikes);
        spike_times(k,1:spike_freq(k)) = spikes';
      end
end
