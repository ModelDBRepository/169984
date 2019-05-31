//genesis

/***************************		MS Model, Version 5.12	**********************
**************************** 	     SynapticChannels.g 	**********************
Tom Sheehan tsheeha2@gmu.edu	thsheeha@vt.edu	703-538-8361
******************************************************************************/

function addSynChannel (compPath, chanpath, gbar)

  str compPath, chanpath
  float gbar

  copy /library/{chanpath} {compPath}/{chanpath}

  addmsg {compPath} {compPath}/{chanpath} VOLTAGE Vm
  addmsg {compPath}/{chanpath} {compPath} CHANNEL Gk Ek

  // Set the new conductance
  float len = {getfield {compPath} len}
  float dia = {getfield {compPath} dia}
  float pi = 3.141592653589793
  float surf = {len*dia*pi}

/*	echo "XXXXXXXXXXXXXXX addSynChannel XXXXXXXXXXXXXXXX"
	echo "compPath = "{compPath}
	echo "chanpath = "{chanpath}
	echo "gbar = "{gbar}
	echo "XXXXXXXXXXXXXXX addSynchannel XXXXXXXXXXXXXXXX"
*/

//  setfield {compPath}/{chanName} gmax {surf*gbar}
  setfield {compPath}/{chanpath} gmax {gbar}
end
 
 
