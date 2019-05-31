
//addinput.g
//these two functions used to provide random spike synaptic input to neuron

function makeinputpre(rate, path)
    str rate
	str path
    create randomspike {path}/randomspike
    setfield ^ min_amp 1.0 max_amp 1.0 rate {rate} reset 1 reset_value 0	
 end
	
function makeinputpost(pathspike, path) 
	str path
	int msgnum
	addmsg {pathspike} {path} SPIKE
    msgnum = {getfield {path} nsynapses} - 1
    setfield {path} \
    synapse[{msgnum}].weight 1 synapse[{msgnum}].delay 0
end


function stopinput(path)
str path
deletemsg {path} 2 -incoming
end


