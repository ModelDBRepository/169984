//IF.g
/*
step 0.10 -time
setfield {cellpath}/soma inject 0.5e-9 
step 0.25 -time
setfield {cellpath}/soma inject 0
step 0.1 -time
*/
//setfield /data/soma overlay 1
reset
int i = 0
float inj = 400e-12

for (i=0; i<1; i=i+1)
	echo {inj} = "I inject"
	//step 0.1  -time
	setfield /FSnetwork/FScell[0]/soma inject {inj}
	step 0.5    -time
	setfield /FSnetwork/FScell[0]/soma inject 0.0e-9
	//step 0.2 -time
	inj= {inj}+50.0e-12
	//reset
end
