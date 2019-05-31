//genesis
//connect_utility_post

//Post-synaptic

function post (Net1, Net2)
str Net1, Net2, comp_name
int cnt, i

foreach comp_name ({el {Net2}/##[TYPE=compartment]}) 
  cnt = {getmsg {comp_name}/GABA -in -count} 
  if ({cnt}>1)
    ce {comp_name}
    echo "" >> connect_post.log   
    echo "Post-synaptic location" >> connect_post.log
    pwe >> connect_post.log  
    echo "Pre-synaptic SP connections" >> connect_post.log
    for (i = 1; i < {cnt}; i= {i +1})
        echo {getmsg {comp_name}/GABA -in -source {i}} >> connect_post.log  
    end       
  else
  end 
end

end
