This is the README for the GENESIS model associated with the paper:

Damodaran S, Cressman JR, Jedrzejewski-Szmek Z, Blackwell KT (2015)
Desynchronization of Fast-Spiking Interneurons Reduces beta-Band
Oscillations and Imbalance in Firing in the Dopamine-Depleted
Striatum. J Neurosci 35:1149-59

This model was contributed by S Damodaran.

To run the simulations type SimNet in genesis command prompt. To run
in batch mode run the Cntl.bat file or type: 
genesis -nox -notty -batch SimNet >> Name.log

Important files:

1. Top level file: SimNet.g
This file calls net.g and the appropriate graphics functions

2. net.g
This file calls the functions that connect both the SP-SP network and
the extrinsic network of cortical and FS inputs

3. net_conn.g
This file contains the function that connects the SP-SP network

4. InputFromFile.g
This file has the functions that read and connect the MATLAB generated
input trains (cortical and FS) to the SP network
NOTE: The files are generated in MATLAB with the ASSUMPTION that we
are hooking up every single input in the network. So at a minimum we
must have enough inputs for the synapses described in the nsynapses
file.

Simulations

The default condition is the control condition. In order to change
between the different conditions:

1. Dopamine Depletion: Replace the MScell folder with the MScell
folder in the No_DA folder.
Replace netconn.g and Net_parameters.g files with netconn.g and
Net_parameters.g files from the No_DA folder.
2. Dopamine Depletion + No Gap junctions: After having it in the
Dopamine Depletion condition replace the FScell folder with the FScell
folder from the NoDA_NoG folder.
3. To change the input correlation go to Net_parameters.g and change
float percDup_SP and percDup_FS to the appropriate value.

4. To run the cases where contribution of the different circuits and
cellular properties are tested:

	(i) Only FS or Only SP changes: Replace netconn.g of control
        condition with netconn.g from OnlyFS or OnlySP folder
        (ii) Only cell: Replace MScell folder of control condition
        with MScell folder from NoDA condition
