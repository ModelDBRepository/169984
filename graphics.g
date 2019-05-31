/*======================================================================
  A GENESIS GUI for network models, with a  control panel, a graph with
  axis scaling, and a network view to visualize Vm in each cell
  ======================================================================*/

//=========================================
//      Function definitions used by GUI
//=========================================

function overlaytoggle(widget)
    str widget
    setfield /##[TYPE=xgraph] overlay {getfield {widget} state}
end

function change_stepsize(dialog)
   str dialog
   dt =  {getfield {dialog} value}
   setclock 0 {dt}
   echo "Changing step size to "{dt}
end
/*
function inj_toggle // toggles current injection ON/OFF
    if ({getfield /control/injtoggle state} == 1)
        setfield /injectpulse level1 1.0        // ON
    else
        setfield /injectpulse level1 0.0        // OFF
    end
end

function add_injection
   int cell_no
   cell_no = ({getfield /control/cell_no value})
   if (cell_no > {NX*NY-1})
      echo "There are only "{NX*NY}" cells - numbering begins with 0"
      return
   end
   InjCell = cell_no
   if (({getmsg /injectpulse/injcurr -outgoing -count}) > 0)
      deletemsg /injectpulse/injcurr  0 -outgoing      // only outgoing message
   end
  addmsg /injectpulse/injcurr /SPnetwork/cell[{cell_no}]/soma INJECT output
   echo "Current injection is to cell number "{cell_no}
end

function set_injection
   str dialog = "/control"
   set_inj_timing {getfield {dialog}/injectdelay value}  \
       {getfield {dialog}/width value} {getfield {dialog}/interval value}
   setfield /injectpulse/injcurr gain {getfield {dialog}/inject value}
   echo "Injection current = "{getfield {dialog}/inject value}
   echo "Injection pulse delay = "{getfield {dialog}/injectdelay value}" sec"
   echo "Injection pulse width = "{getfield {dialog}/width value}" sec"
   echo "Injection pulse interval = "{getfield {dialog}/interval value}" sec"
end
*/

/*  A subset of the functions defined in genesis/startup/xtools.g
    These are used to provide a "scale" button to graphs.
    "makegraphscale path_to_graph" creates the button and the popup
     menu to change the graph scale.
*/

function setgraphscale(graph)
    str graph
    str form = graph @ "_scaleform"
    str xmin = {getfield {form}/xmin value}
    str xmax = {getfield {form}/xmax value}
    str ymin = {getfield {form}/ymin value}
    str ymax = {getfield {form}/ymax value}
    setfield {graph} xmin {xmin} xmax {xmax} ymin {ymin} ymax {ymax}
    xhide {form}
end

function showgraphscale(form)
    str form
    str x, y
    // find the parent form
    str parent = {el {form}/..}
    while (!{isa xform {parent}})
        parent = {el {parent}/..}
    end
    x = {getfield {parent} xgeom}
    y = {getfield {parent} ygeom}
    setfield {form} xgeom {x} ygeom {y}
    xshow {form}
end

function makegraphscale(graph)
    if ({argc} < 1)
        echo usage: makegraphscale graph
        return
    end
    str graph
    str graphName = {getpath {graph} -tail}
    float x, y
    str form = graph @ "_scaleform"
    str parent = {el {graph}/..}
    while (!{isa xform {parent}})
        parent = {el {parent}/..}
    end

    x = {getfield {graph} x}
    y = {getfield {graph} y}

    create xbutton {graph}_scalebutton  \
        [{getfield {graph} xgeom},{getfield {graph} ygeom},50,25] \
           -title scale -script "showgraphscale "{form}
    create xform {form} [{x},{y},180,170] -nolabel

    disable {form}
    pushe {form}
    create xbutton DONE [10,5,55,25] -script "setgraphscale "{graph}
    create xbutton CANCEL [70,5,55,25] -script "xhide "{form}
    create xdialog xmin [10,35,160,25] -value {getfield {graph} xmin}
    create xdialog xmax [10,65,160,25] -value {getfield {graph} xmax}
    create xdialog ymin [10,95,160,25] -value {getfield {graph} ymin}
    create xdialog ymax [10,125,160,25] -value {getfield {graph} ymax}
    pope
end

/* Add some interesting colors to any widgets that have been created */
function colorize
    setfield /##[ISA=xlabel] fg white bg blue3
    setfield /##[ISA=xbutton] offbg rosybrown1 onbg rosybrown1
    setfield /##[ISA=xtoggle] onfg red offbg cadetblue1 onbg cadetblue1
    setfield /##[ISA=xdialog] bg palegoldenrod
    setfield /##[ISA=xgraph] bg ivory
end


//==================================
//    Functions to set up the GUI
//==================================
//str graphlabel = "Network of Spiny Projection neurons with Fast Spiking interneuronal input"
str graphlabel = "Control w/ 20Hz GABA"

float tmax = 3		// simulation time
float dt = 50e-6		// simulation time step
float SEP_X = 500e-6 // 500 um
float SEP_Y = 500e-6
float syn_weight = 6 // synaptic weight, effectively multiplies gmax
float cond_vel = 0.5 // m/sec - GABA and the Basal Ganglia by Tepper et al
float syn_weight2 = 4 // synaptic weight, effectively multiplies gmax
float cond_vel2 = 1.4 // m/sec - GABA and the Basal Ganglia by Tepper et al
int NI_X = 3
int NI_Y = 3
int NI_Z = 3
int NX = 3  //{sqrt {getglobal numCells_{net}}}   number of cells = NX*NY
int NY = NX
int NZ = NX
float CI_X = 25e-6
float CI_Y = 25e-6
float prop_delay = {CI_X}/{cond_vel}
float prop_delay2 = {SEP_X}/{cond_vel2}
float gmax = 4e-9 // 1 nS - possibly a little small for this cell
float gmax2 = 4e-9
int num_inter_connections = 100

function make_control
    create xform /control [10,50,250,460]
    pushe /control
    create xlabel label -hgeom 25 -bg cyan -label "CONTROL PANEL"
    create xbutton RESET -wgeom 25%       -script reset
    create xbutton RUN  -xgeom 0:RESET -ygeom 0:label -wgeom 25% \
         -script step_tmax
    create xbutton STOP  -xgeom 0:RUN -ygeom 0:label -wgeom 25% \
         -script stop
    create xbutton QUIT -xgeom 0:STOP -ygeom 0:label -wgeom 25% -script quit
    create xdialog stepsize -title "dt (sec)" -value {dt} \
                -script "change_stepsize <widget>"
    create xtoggle overlay   -script "overlaytoggle <widget>"
    setfield overlay offlabel "Overlay OFF" onlabel "Overlay ON" state 0
    create xlabel connlabel -label "Connection Parameters"
	create xdialog Inter_connection -label "Number of interconnections per neuron" -value {num_inter_connections}
    create xdialog gmax -label "Inhchan gmax (S)" -value {gmax} \
        -script "setfield /network/cell[]/soma/Inh_channel gmax <v>"
    create xdialog gmax2 -label "Exchan gmax (S)" -value {gmax2} \	
	-script "setfield /network/cell[]/soma/Ex_channel gmax <v>"
    create xdialog weight -label " Cortical input Weight" -wgeom 50% \
	-value {syn_weight} -script "set_weights <v>"
    create xdialog weight2 -label "SP network Weight" -wgeom 50% \
	-value {syn_weight} -script "set_weights2 <v>"
    create xdialog propdelay -label "Cortical input Delay" -wgeom 50% -xgeom 0:weight \
	-ygeom 0:gmax -value {prop_delay}  -script "set_delays <v>"
    create xdialog propdelay2 -label "SP network Delay" -wgeom 50% -xgeom 0:weight \
	-ygeom 0:gmax -value {prop_delay}  -script "set_delays2 <v>"
   /* create xlabel stimlabel -label "Stimulation Parameters"
    create xtoggle injtoggle -label "" -script inj_toggle
    setfield injtoggle offlabel "Current Injection OFF"
    setfield injtoggle onlabel "Current Injection ON" state 1 
    inj_toggle     // initialize
    create xlabel numbering -label "Lower Left = 0; Center = "{middlecell}
    create xdialog cell_no -label "Inject Cell:" -value {InjCell}  \
        -script "add_injection"
    create xdialog inject -label "Injection (Amp)" -value {injcurrent}  \
        -script "set_injection"
    create xdialog injectdelay -label "Delay (sec)" -value {injdelay}  \
        -script "set_injection"
    create xdialog width -label "Width (sec)" -value {injwidth}  \
        -script "set_injection"
    create xdialog interval -label "Interval (sec)" -value {injinterval}  \
        -script "set_injection"
	*/	
    create xlabel randact -label "Random background activation"
    create xdialog randfreq -label "Frequency (Hz)" -value 0 \
	-script "set_frequency <v>"
    pope
    xshow /control
end


function make_Vmgraph
    float vmin = -0.1
    float vmax = 0.15
    create xform /data [265,50,400,460]
    create xlabel /data/label -hgeom 5% -label {graphlabel}
    create xgraph /data/voltage -hgeom 80% -title "Membrane Potential" -bg white
    setfield ^ XUnits sec YUnits V
    setfield ^ xmax {tmax} ymin {vmin} ymax {vmax}
    makegraphscale /data/voltage
    create xgraph /data/spike -hgeom 15% -ygeom 0:voltage \
	-title "Spike" -bg white
    setfield ^ XUnits sec YUnits A
    setfield ^ xmax {tmax} ymin {0} ymax {1e-9}
    makegraphscale /data/spike
    /* Set up plotting messages, with offsets */
    // middlecell is a middle point (exactly, if NX and NY are odd)
    /*
      addmsg /SPnetwork/SPcell[0]/soma /data/voltage PLOTSCALE \
	Vm *"0" *black 1 0
      addmsg /SPnetwork/SPcell[1]/soma /data/voltage PLOTSCALE \
	Vm *"1" *blue 1 0
       addmsg /SPnetwork/SPcell[2]/soma /data/voltage PLOTSCALE \
	Vm *"2" *red 1 0
      addmsg /SPnetwork/SPcell[3]/soma /data/voltage PLOTSCALE \
	Vm *"3" *black 1 0.05 
        addmsg /SPnetwork/SPcell[4]/soma /data/voltage PLOTSCALE \
	Vm *"4" *blue 1 0.05
        addmsg /SPnetwork/SPcell[5]/soma /data/voltage PLOTSCALE \
	Vm *"5" *red 1 0.05
       addmsg /SPnetwork/SPcell[6]/soma /data/voltage PLOTSCALE \
	Vm *"6" *black 1 0.1
        addmsg /SPnetwork/SPcell[7]/soma /data/voltage PLOTSCALE \
	Vm *"7" *blue 1 0.1
         addmsg /SPnetwork/SPcell[8]/soma /data/voltage PLOTSCALE \
	Vm *"8" *red 1 0.1
    */
   
    addmsg /SPnetwork/SPcell[0]/soma /data/voltage PLOTSCALE \
	Vm *"L corner 0 " *black 1 0
    //addmsg /SPnetwork/SPcell[{{round {(NY-1)/2}}*NX}]/soma  /data/voltage \
    //    PLOTSCALE Vm *"R edge "{{round {(NY-1)/2}}*NX} *blue  1 0
    addmsg /SPnetwork/SPcell[49]/soma /data/voltage PLOTSCALE \
	Vm *"center 49" *blue 1 0.05
    addmsg /SPnetwork/SPcell[99]/soma /data/voltage PLOTSCALE \
	Vm *"R corner 99" *red 1 0.1

/*
 addmsg /FSnetwork/FScell[0]/soma /data/voltage PLOTSCALE \
	Vm *"L corner 0 " *black 1 0
    //addmsg /SPnetwork/SPcell[{{round {(NY-1)/2}}*NX}]/soma  /data/voltage \
    //    PLOTSCALE Vm *"R edge "{{round {(NY-1)/2}}*NX} *blue  1 0
    addmsg /FSnetwork/FScell[12]/soma /data/voltage PLOTSCALE \
	Vm *"center 49" *blue 1 0.05
    addmsg /FSnetwork/FScell[24]/soma /data/voltage PLOTSCALE \
	Vm *"R corner 99" *red 1 0.1
*/
/*
addmsg /SPnetwork/SPcell[1]/soma /data/voltage PLOTSCALE \
	Vm *"L corner 1 " *black 1 0
    //addmsg /SPnetwork/SPcell[{{round {(NY-1)/2}}*NX}]/soma  /data/voltage \
    //    PLOTSCALE Vm *"R edge "{{round {(NY-1)/2}}*NX} *blue  1 0
    addmsg /SPnetwork/SPcell[4]/soma /data/voltage PLOTSCALE \
	Vm *"center 4" *blue 1 0.05
 addmsg /SPnetwork/SPcell[3]/soma /data/voltage PLOTSCALE \
	Vm *"center 3" *green 1 0.05
    addmsg /SPnetwork/SPcell[5]/soma /data/voltage PLOTSCALE \
	Vm *"center 5" *black 1 0.05
    addmsg /SPnetwork/SPcell[8]/soma /data/voltage PLOTSCALE \
	Vm *"R corner 8" *red 1 0.1
*/   
    //addmsg /injectpulse/injcurr /data/injection PLOT output *injection *black
    xshow /data
end


function make_Cagraph
    float vmin = -0.1
    float vmax = 0.15
    create xform /Cadata [265,50,400,460]
    create xlabel /Cadata/label -hgeom 5% -label {graphlabel}
    create xgraph /Cadata/Calevel -hgeom 80% -title "Ca2+ level" -bg white
    setfield ^ XUnits sec YUnits M
    //setfield ^ xmax {tmax} ymin {vmin} ymax {vmax}
    makegraphscale /Cadata/Calevel
    //create xgraph /data/spike -hgeom 15% -ygeom 0:voltage \
//	-title "Spike" -bg white
  //  setfield ^ XUnits sec YUnits A
   // setfield ^ xmax {tmax} ymin {0} ymax {1e-9}
   // makegraphscale /data/spike
    /* Set up plotting messages, with offsets */
    // middlecell is a middle point (exactly, if NX and NY are odd)
    /*
      addmsg /SPnetwork/SPcell[0]/soma /data/voltage PLOTSCALE \
	Vm *"0" *black 1 0
      addmsg /SPnetwork/SPcell[1]/soma /data/voltage PLOTSCALE \
	Vm *"1" *blue 1 0
       addmsg /SPnetwork/SPcell[2]/soma /data/voltage PLOTSCALE \
	Vm *"2" *red 1 0
      addmsg /SPnetwork/SPcell[3]/soma /data/voltage PLOTSCALE \
	Vm *"3" *black 1 0.05 
        addmsg /SPnetwork/SPcell[4]/soma /data/voltage PLOTSCALE \
	Vm *"4" *blue 1 0.05
        addmsg /SPnetwork/SPcell[5]/soma /data/voltage PLOTSCALE \
	Vm *"5" *red 1 0.05
       addmsg /SPnetwork/SPcell[6]/soma /data/voltage PLOTSCALE \
	Vm *"6" *black 1 0.1
        addmsg /SPnetwork/SPcell[7]/soma /data/voltage PLOTSCALE \
	Vm *"7" *blue 1 0.1
         addmsg /SPnetwork/SPcell[8]/soma /data/voltage PLOTSCALE \
	Vm *"8" *red 1 0.1
    */
   
    addmsg /SPnetwork/SPcell[0]/soma /data/voltage PLOTSCALE \
	Vm *"L corner 0 " *black 1 0
    //addmsg /SPnetwork/SPcell[{{round {(NY-1)/2}}*NX}]/soma  /data/voltage \
    //    PLOTSCALE Vm *"R edge "{{round {(NY-1)/2}}*NX} *blue  1 0
    addmsg /SPnetwork/SPcell[49]/soma /data/voltage PLOTSCALE \
	Vm *"center 49" *blue 1 0.05
    addmsg /SPnetwork/SPcell[99]/soma /data/voltage PLOTSCALE \
	Vm *"R corner 99" *red 1 0.1

/*
 addmsg /FSnetwork/FScell[0]/soma /data/voltage PLOTSCALE \
	Vm *"L corner 0 " *black 1 0
    //addmsg /SPnetwork/SPcell[{{round {(NY-1)/2}}*NX}]/soma  /data/voltage \
    //    PLOTSCALE Vm *"R edge "{{round {(NY-1)/2}}*NX} *blue  1 0
    addmsg /FSnetwork/FScell[12]/soma /data/voltage PLOTSCALE \
	Vm *"center 49" *blue 1 0.05
    addmsg /FSnetwork/FScell[24]/soma /data/voltage PLOTSCALE \
	Vm *"R corner 99" *red 1 0.1
*/
/*
addmsg /SPnetwork/SPcell[1]/soma /data/voltage PLOTSCALE \
	Vm *"L corner 1 " *black 1 0
    //addmsg /SPnetwork/SPcell[{{round {(NY-1)/2}}*NX}]/soma  /data/voltage \
    //    PLOTSCALE Vm *"R edge "{{round {(NY-1)/2}}*NX} *blue  1 0
    addmsg /SPnetwork/SPcell[4]/soma /data/voltage PLOTSCALE \
	Vm *"center 4" *blue 1 0.05
 addmsg /SPnetwork/SPcell[3]/soma /data/voltage PLOTSCALE \
	Vm *"center 3" *green 1 0.05
    addmsg /SPnetwork/SPcell[5]/soma /data/voltage PLOTSCALE \
	Vm *"center 5" *black 1 0.05
    addmsg /SPnetwork/SPcell[8]/soma /data/voltage PLOTSCALE \
	Vm *"R corner 8" *red 1 0.1
*/   
    //addmsg /injectpulse/injcurr /data/injection PLOT output *injection *black
    xshow /data
end

function make_netview  // sets up xview widget to display Vm of each cell
    create xform /netview [670,50,300,300]
    create xdraw /netview/draw [0%,0%,100%, 100%]
    // Make the display region a little larger than the cell array
    setfield /netview/draw xmin {-SEP_X} xmax {NX*SEP_X} \
	ymin {-SEP_Y} ymax {NY*SEP_Y}
    create xview /netview/draw/view
    setfield /netview/draw/view path /SPnetwork/SPcell[]/soma field Vm \
	value_min -0.08 value_max 0.03 viewmode colorview sizescale {SEP_X}
    xshow /netview
end


function make_inview  // sets up xview widget to display Vm of each cell
    create xform /inview [1070,50,300,300]
    create xdraw /inview/draw [0%,0%,100%, 100%]
    // Make the display region a little larger than the cell array
    setfield /inview/draw xmin {-CI_X} xmax {NI_X*CI_X} \
	ymin {-CI_Y} ymax {NI_Y*CI_Y}
    create xview /inview/draw/view
    setfield /inview/draw/view path /in/input[] field state \
	value_min -0.08 value_max 0.03 viewmode colorview sizescale {CI_X}
    xshow /inview
end
