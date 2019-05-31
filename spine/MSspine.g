// This code creates a MS spine that can be added on any dendrite
//
// The initial purpose is to test if GABA synapses on the neck of the spine
// can block a bAP depolarisation from reaching the spine head.
//
//
// There are reconstructed MS spines in the DATA/ccdb.ucsd.edu directory.

function createSpine(spineName, spineLoc, \
                     neckLen, neckDia, nNeck, \
                     HeadLen, HeadDia, nHead)

str spineName // Name of spine
str spineLoc  // Location of spine (compartment it is attached to)
float neckLen // Length of the spine neck
float neckDia // Diameter of spine neck
int nNeck     // Number of neck compartments (1 or more)
float HeadLen // Length of spine head
float HeadDia // Diameter of spine head
int nHead     // Number of compartments in spine head (2 or more),
              // ie submembrane shell + rest of head

pushe {spineLoc}

  int i

  str parentComp = {spineLoc}

  for(i = 0; i < {nNeck}; i = i + 1)
    create compartment spineNeck[{i}]

    addmsg spineNeck[{i}] {parentComp} RAXIAL Ra previous_state
    addmsg {parentComp} spineNeck[{i}] AXIAL previous_state

    makeCaBuffer CaTbuf {spineLoc}/spineNeck[{i}]

    parentComp = spineNeck[{i}]
  end

  // One compartment is dedicated to submembrane, has separate name
  int nHeadRest = {{nHead}-1}

  for(i = 0; i < {nHeadRest}; i = i + 1)
    create compartment spineHead[{i}]

    addmsg spineHead[{i}] {parentComp} RAXIAL Ra previous_state
    addmsg {parentComp} spineHead[{i}] AXIAL previous_state

    makeCaBuffer CaNQRbuf {spineLoc}/spineHead[{i}]

    createCaChannelsFromList "CaN CaNNOINACT CaQ" \
                             {spineLoc}/spineHead[{i}] \
                             CaNQRbuf   

    float SKcond = 0.145e4
    copyAndConnectSKKchannels {spineLoc}/spineHead[{i}] CaNQRbuf {SKcond}

    parentComp = spineHead[{i}]
  end

  // Submembrane compartment added seperately
  create compartment spineHeadEnd
  addmsg spineHeadEnd {parentComp} RAXIAL Ra previous_state
  addmsg {parentComp} spineHeadEnd AXIAL previous_state

  makeCaBuffer CaTbuf {spineLoc}/spineHeadEnd

  float AMPAcond = 80e-12
  float NMDAcond = 220e-12

  addAMPAchannelGHKCa {spineLoc}/spineHeadEnd {AMPAcond}
  addNMDAchannelGHKCa {spineLoc}/spineHeadEnd {NMDAcond}

  createCaChannelsFromList "CaL13 CaL12 CaL12NOINACT" \
                           {spineLoc}/spineHeadEnd \
                           CaTbuf

pope {spineLoc}

end

function addGabaToSpine(spineName, spineLoc, neckIdx)

str spineName
str spineLoc
int neckIdx

float GABAcond = 750e-12

addGABAchannel {spineLoc}/spineNeck[{neckIdx}] {GABAcond}
 
end
