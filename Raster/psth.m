
[nid_spk,t_spk] = textread('SPcell.spikes', '%d    %f'      );
t_count=1;
t_hist=0:0.025:0.25;
for w=1:(length(t_hist)-1)
    for i=1:max(nid_spk)
        count=0;
        for j=1:length(nid_spk)
            if (t_spk(j)>t_hist(w) & t_spk(j)<t_hist(w+1))
                if (nid_spk(j)==i)
                count=count+1;
                spikes(t_count,i) = count;
                else     
                end
%             elseif (t_spk(j)>t_hist(w) & t_spk(j)>t_hist(w+1))
%                 if (nid_spk(j)==i)
%                 count=0;
%                 spikes(t_count,i) = count;
%                 else
%                 end
            end
        end
    end
t_count=t_count+1;
end

t_hist1=0.5:0.025:0.75;
for w=1:(length(t_hist1)-1)
    for i=1:max(nid_spk)
        count=0;
        for j=1:length(nid_spk)
            if (t_spk(j)>t_hist1(w) & t_spk(j)<t_hist1(w+1))
                if (nid_spk(j)==i)
                count=count+1;
                spikes(t_count,i) = count;
                else     
                end
%             elseif (t_spk(j)>t_hist1(w) & t_spk(j)>t_hist1(w+1))
%                 if (nid_spk(j)==i)
%                 count=0;
%                 spikes(t_count,i) = count;
%                 else 
%                 end
            end
        end
    end
t_count=t_count+1;
end
for i=1:(t_count-2)
temp_m=spikes(i,:);    
mean_spk(i)=mean(temp_m);
std_spk(i)=std(temp_m);
end
x=[0.125,0.175,0.225,0.6,0.65,0.7,0.75];
latency=min(t_spk)
