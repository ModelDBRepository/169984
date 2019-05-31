//////////////////////////////////////////////////////////////////////////
//
// Johannes Hjorth, june 2005
// hjorth@nada.kth.se
// Sriraman Damodaran, september 2010
// FScell.g - Creates a fast spiking neuron in the library
//
//////////////////////////////////////////////////////////////////////////
//
// make_FS_cell -- Creates the library template for a FS-neuron 
//
//////////////////////////////////////////////////////////////////////////
include FScell/proto.g

//************************ Begin function set_position *********************
//**************************************************************************
function set_position (cellpath)
//********************* Begin Local Variables ************************
str compt, cellpath
float dist2soma,x,y,z
//********************* End Local Variables *****************************
 		
if (!{exists {cellpath}})
  echo The current input {cellpath} does not exist (set_position) 
  return
end
 
  foreach compt ({el {cellpath}/##[TYPE=compartment]})
     	 x={getfield {compt} x}
     	 y={getfield {compt} y}
     	 z={getfield {compt} z}
     	dist2soma={sqrt {({pow {x} 2 }) + ({pow {y} 2}) + ({pow {z} 2})} }  
     	setfield {compt} position {dist2soma}
   end
end
	//************************ End function set_position ***********************
	//**************************************************************************


function make_FS_cell (cellpath,pfile)
  str cellpath,pfile

  make_prototypes		// see proto.g
  readcell {pfile} {cellpath}
  set_position {cellpath}	// local call
// Number of inputs to each compartmenttype

  addfield {cellpath} somaDensityAMPA
  addfield {cellpath} somaDensityNMDA
  addfield {cellpath} somaDensityGABA

  addfield {cellpath} primDensityAMPA
  addfield {cellpath} primDensityNMDA
  addfield {cellpath} primDensityGABA

  addfield {cellpath} secDensityAMPA
  addfield {cellpath} secDensityNMDA
  addfield {cellpath} secDensityGABA

  addfield {cellpath} tertDensityAMPA
  addfield {cellpath} tertDensityNMDA
  addfield {cellpath} tertDensityGABA

// Weights of each input

  addfield {cellpath} somaWeightAMPA
  addfield {cellpath} somaWeightNMDA
  addfield {cellpath} somaWeightGABA

  addfield {cellpath} primWeightAMPA
  addfield {cellpath} primWeightNMDA
  addfield {cellpath} primWeightGABA

  addfield {cellpath} secWeightAMPA
  addfield {cellpath} secWeightNMDA
  addfield {cellpath} secWeightGABA

  addfield {cellpath} tertWeightAMPA
  addfield {cellpath} tertWeightNMDA
  addfield {cellpath} tertWeightGABA


// Set default values for densities

  setfield {cellpath} somaDensityAMPA 1
  setfield {cellpath} somaDensityNMDA 1
  setfield {cellpath} somaDensityGABA 3

  setfield {cellpath} primDensityAMPA 1
  setfield {cellpath} primDensityNMDA 1
  setfield {cellpath} primDensityGABA 3

  setfield {cellpath} secDensityAMPA  1
  setfield {cellpath} secDensityNMDA  1
  setfield {cellpath} secDensityGABA  3

  setfield {cellpath} tertDensityAMPA 1
  setfield {cellpath} tertDensityNMDA 1
  setfield {cellpath} tertDensityGABA 0


// Set default values for synapse weights

  setfield {cellpath} somaWeightAMPA 1.0
  setfield {cellpath} somaWeightNMDA 1.0
  setfield {cellpath} somaWeightGABA 1.0

  setfield {cellpath} primWeightAMPA 1.0
  setfield {cellpath} primWeightNMDA 1.0
  setfield {cellpath} primWeightGABA 1.0

  setfield {cellpath} secWeightAMPA  1.0
  setfield {cellpath} secWeightNMDA  1.0
  setfield {cellpath} secWeightGABA  1.0

  setfield {cellpath} tertWeightAMPA 1.0
  setfield {cellpath} tertWeightNMDA 1.0
  setfield {cellpath} tertWeightGABA 1.0

end

//////////////////////////////////////////////////////////////////////////

