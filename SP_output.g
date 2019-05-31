//genesis
//SP_output.g



function makeOutput(cellPath, outputName, plotDt)

    str cellPath
    str outputName
    float plotDt
    str description
    int index

    str fileBasePath = "OUTDATA/"

   str filenameDATA = {fileBasePath}@{outputName}@".data"
// str filenameDATA = "output.data"
//    str outputPath = "/output/"@{outputName}
  str outputPath = {outputName}
    str filenameINFO = {fileBasePath}@{outputName}@".info"
    str cellSoma
/*
    if(!{exists /output})
        echo "Creating /output/"
        create neutral /output/        
    end 
*/
    // Open the file in overwrite mode and write the simulation parameters

    echo "Writing simulation parameters to "{filenameINFO}
/*
    openfile {filenameINFO} w
    
    writefile {filenameINFO} "nParams     2 0" // 2 numbers, 0 strings
    writefile {filenameINFO} "numCells     "{numCells}
    writefile {filenameINFO} "maxTime     "{maxTime}


    // Add info about noise level etc

    closefile {filenameINFO}
*/
    echo "Setting clock 1 (output to file) to "{plotDt}"s"
    setclock 1 {plotDt}

    // Close file and reopen it as an asc_file object (append mode)
    // to add simulation data.
/*
    if(!{exists {outputPath}})
      echo "Creating new asc_file object: "{outputPath}
      create asc_file {outputPath}
    end
*/
    create asc_file {outputPath}
  
    setfield {outputPath} leave_open 1 flush 1 append 1 notime 0 filename "out.data"
    useclock {outputPath} 1
//    addmsg {cellPath}/soma {outputPath} SAVE Vm

    foreach cellSoma ({el {cellPath}[]})
        echo "Directing voltage of "{cellSoma}" to "{outputPath}
        addmsg {cellSoma}/soma {outputPath} SAVE Vm
    end

end

//////////////////////////////////////////////////////////////////////////////

function addCompartmentOutput(compartment, outputName)

  str compartment
  str outputName
  str outputPath = "/output/"@{outputName}

  echo "Directing voltage of "{compartment}" to "{getfield {outputPath} filename}

  addmsg {compartment} {outputPath} SAVE Vm

end

//////////////////////////////////////////////////////////////////////////////

function clearOutput(outputName)
  str outputName

  str outputPath = "/output/"@{outputName}

  int ctr
  int nMsg = {getmsg {outputPath} -incoming -count}
  
  echo "Clearing output "{outputName}

  for(ctr = 0; ctr < nMsg; ctr = ctr + 1)
    deletemsg {outputPath} 0 -incoming
  end

  // HERE THE asc_file should be closed!!
end
