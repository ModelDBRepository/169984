//genesis
//connect_utility_pre

//Pre-synaptic

//str Netpath="/network/SPcell[]", comp_name

function pre (Net1, Net2)
echo "in pre"
str Net1, Net2, comp_name

int cnt, i, tot_cnt=0

foreach comp_name ({el {Net1}/soma}) 
  cnt = {getmsg {comp_name}/spike -out -count} 
  if ({cnt}>1)
    ce {comp_name}
    ce ..
    echo "" >> connect_pre.log   
    echo "Pre-synaptic location" >> connect_pre.log
    pwe >> connect_pre.log  
    echo "Post-synaptic SP connections" >> connect_pre.log
    for (i = 0; i < {cnt}; i= {i +1})
        echo {getmsg {comp_name}/spike -out -destination {i}} >> connect_pre.log  
    end       
  else
  end 
end

end
