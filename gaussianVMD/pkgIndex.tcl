# PKG Index - Gaussian for VMD

package ifneeded gaussianVMD        	                    1.0 [list source [file join $dir/gaussianVMD.tcl]]

#GUI
package ifneeded gui        	                            1.0 [list source [file join $dir/routines/gui.tcl]]
package ifneeded guiBondModif  	                            1.0 [list source [file join $dir/routines/guiBondModif.tcl]]
package ifneeded guiAngleModif  	                        1.0 [list source [file join $dir/routines/guiAngleModif.tcl]]
package ifneeded guiDihedModif  	                        1.0 [list source [file join $dir/routines/guiDihedModif.tcl]]
package ifneeded guiOpenFile      	                        1.0 [list source [file join $dir/routines/guiOpenFile.tcl]]
package ifneeded guiSaveFile      	                        1.0 [list source [file join $dir/routines/guiSaveFile.tcl]]
package ifneeded guiError         	                        1.0 [list source [file join $dir/routines/guiError.tcl]]
package ifneeded guiChargeMulti    	                        1.0 [list source [file join $dir/routines/guiChargeMulti.tcl]]
package ifneeded guiCalcSetup    	                        1.0 [list source [file join $dir/routines/guiCalcSetup.tcl]]
package ifneeded guiCredits     	                        1.0 [list source [file join $dir/routines/guiCredits.tcl]]


#lib
package ifneeded inputFile   	                            1.0 [list source [file join $dir/lib/inputFile.tcl]]
package ifneeded getStructure  	                            1.0 [list source [file join $dir/lib/getStructure.tcl]]
package ifneeded quit		  	                            1.0 [list source [file join $dir/lib/quit.tcl]]
package ifneeded loadMoleculeVMD 	                        1.0 [list source [file join $dir/lib/loadMoleculeVMD.tcl]]
package ifneeded timeControl     	                        1.0 [list source [file join $dir/lib/timeControl.tcl]]
package ifneeded loadGaussianInputFile     	                1.0 [list source [file join $dir/lib/loadGaussianInputFile.tcl]]
package ifneeded loadGaussianOutputFile     	            1.0 [list source [file join $dir/lib/loadGaussianOutputFile.tcl]]
package ifneeded editStructure                          	1.0 [list source [file join $dir/lib/editStructure.tcl]]
package ifneeded modify                                   	1.0 [list source [file join $dir/lib/modify.tcl]]
package ifneeded saveFiles                                 	1.0 [list source [file join $dir/lib/saveFiles.tcl]]
package ifneeded readFreq                                 	1.0 [list source [file join $dir/lib/readFreq.tcl]]
package ifneeded energy                                 	1.0 [list source [file join $dir/lib/energy.tcl]]

#Theme
package ifneeded ttk::theme::clearlooks                     0.1 [list source [file join $dir/lib/theme/clearlooks.tcl]]
