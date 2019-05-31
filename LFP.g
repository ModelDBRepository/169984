//LFP.g

function LFP_all

	str cName, i
	create efield electrode_all
	create efield electrode_glut
	create efield electrode_gaba

	setfield electrode_all scale 0.26 x 7.5e-5 y 4.0e-4 z 0.00 //s = 0.3 S/m - Linden et al., 2012
	setfield electrode_glut scale 0.26 x 7.5e-5 y 4.0e-4 z 0.00
	setfield electrode_gaba scale 0.26 x 7.5e-5 y 4.0e-4 z 0.00

        for(i = 0; i < {getglobal numCells_SP}; i = {i + 1})
		foreach cName ({el /SPnetwork/SPcell[{i}]/##[TYPE=compartment]})
			addmsg {cName}/AMPA electrode_all CURRENT Ik 0.0
			addmsg {cName}/NR2A electrode_all CURRENT Ik 0.0
			addmsg {cName}/GABA electrode_all CURRENT Ik 0.0

			addmsg {cName}/AMPA electrode_glut CURRENT Ik 0.0
			addmsg {cName}/NR2A electrode_glut CURRENT Ik 0.0

			addmsg {cName}/GABA electrode_gaba CURRENT Ik 0.0
		end

	end
	call electrode_all RECALC
	call electrode_glut RECALC
	call electrode_gaba RECALC
	create asc_file /output/electrode_all
	create asc_file /output/electrode_glut
	create asc_file /output/electrode_gaba
	setfield /output/electrode_all   flush 1  leave_open 1 append 1 float_format %0.6g	
	setfield /output/electrode_glut   flush 1  leave_open 1 append 1 float_format %0.6g	
	setfield /output/electrode_gaba   flush 1  leave_open 1 append 1 float_format %0.6g	
	useclock /output/electrode_all 1e-3
	useclock /output/electrode_glut 1e-3
	useclock /output/electrode_gaba 1e-3
	addmsg /electrode_all /output/electrode_all SAVE field 
	addmsg /electrode_glut /output/electrode_glut SAVE field 
	addmsg /electrode_gaba /output/electrode_gaba SAVE field 

end





