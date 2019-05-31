[nid_spk,t_spk] = textread('FScell.spikes', '%d    %f'      );
t_start=0;
t_end=3.0;
for i=1:max(nid_spk)
  count=0;
  for j=1:length(nid_spk)
    if (nid_spk(j)==i)
      count=count+1;
      spikes(i) = count;
    else     
    end
  end
end
%mean_spk(i)=spikes(i);
total_mean=mean(spikes)
std_spk=std(spikes)
