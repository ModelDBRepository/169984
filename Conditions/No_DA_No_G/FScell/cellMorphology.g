// This file contains some of the constants defined for the cell
// used by correlatedCellNoise.g and inputManager.g
//
// correlatedCellNoise.g <-- responsible for the input noise to the cell
// inputManager.g        <-- responsible for the input signal to the cell

// Number of dendrites of each type, and number of compartments in each
int primNum     = 3, secNum     = 6, tertNum     = 12
int primCompNum = 2, secCompNum = 4, tertCompNum = 8

// Relative density of AMPA and GABA 
int somaGluBase  = 1, primGluBase  = 1, secGluBase   = 1, tertGluBase  = 1
int somaGABABase = 3, primGABABase = 3, secGABABase  = 3, tertGABABase = 0

// no GABA on distal dendrites, but increased
// GABA density on proximal dendrites
