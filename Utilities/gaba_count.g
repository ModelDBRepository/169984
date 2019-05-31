//genesis
//gaba_count
int count, tot_cnt
str comp_name

foreach comp_name ({el /SPnetwork/SPcell[]/##[TYPE=compartment]}) 
        count = {getmsg {comp_name}/GABA -in -count}
        count = {count} -1
        tot_cnt = {tot_cnt} + {count}   
end

echo "GABA messages to SP connections" >> gaba_count.log
echo {tot_cnt} >> gaba_count.log
