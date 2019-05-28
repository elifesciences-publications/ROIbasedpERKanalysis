// this is for use on registered images, so that you only need to define ROIs once
// Use MeasureROIintensityStack_unregistered_CW_v1 if you have unregistered images

// IMPORTANT: Reference image needs to be in <Ref> folder under Registered Tiffs
// Order of selection is how the data will be ordered 
// E.g. left cH, right cH, left mLH, right mLH, left lLH, right lLH
// Flexible Z-range over which ROIs can be measured, HOWEVER
// you will need to manually change the code depending on which ROIs correspond to which range
// Currently, I have 6 ROIs (2 left or right x 3 regions)
// Each region has the same range 

NumberofROIs = 6;

Region1_name = "cH";
Region2_name = "mLH";
Region3_name = "lLH";

minslice_Region1 =47; //curently cH
maxslice_Region1 = 50;

minslice_Region2 = 39; //curently mLH
maxslice_Region2 = 50;

minslice_Region3 =42;   //curently lLH
maxslice_Region3 = 50;

// pERK/tERK ratio, or just tERK
usetERK =0;
// After registration, some ROIs have empty values, which can skew data
minarea = 90; //this is min nonzero area for inclusion. 

print("\\Clear"); //this is to clear log window
run("Clear Results");
run("Close All"); 

run("Set Measurements...", "area mean center median area_fraction stack nan redirect=None decimal=3");
main_dir = getDirectory("Main Directory");

source_dir2 = main_dir + "/RegisteredTiffs/pERK/";
source_dir3 = main_dir + "/RegisteredTiffs/tERK/";
source_dir_ref = main_dir + "/RegisteredTiffs/Ref/";

File.makeDirectory(main_dir + "/ROIintensity_registered/"); 
target_dir = main_dir + "/ROIintensity_registered/";

list2 = getFileList(source_dir2);
list3 = getFileList(source_dir3);
list_ref = getFileList(source_dir_ref);

Image_original = source_dir_ref + list_ref[0];
open(Image_original); 
Original = getTitle();
setTool("freehand"); 

for (j=0; j< NumberofROIs; j++) {	
    selectWindow(Original);
    run("Remove Overlay");
    waitForUser("Select region","Select the area to analyze and click 'OK'");  //select mLH then lLH

   if (j==0) {
        //Add ROI to ROI manager
        run("Add Selection...");
        run("To ROI Manager");
    } else {
        roiManager("Add");
    }
}

setBatchMode(true);

for (i=0; i<list2.length+1; i++) {
    
    Image_original = source_dir2 + list2[i];
    Image_original_tERK = source_dir3 + list3[i];
  		
    open(Image_original_tERK);
    tERK = getTitle();
		
    open(Image_original); 
    Original = getTitle();
   	  
    // loop through the ROIs
    for (j=0; j< NumberofROIs; j++) {	
    		
        // IMPORTANT: Lines below need to be modified depending on your ROIs
        if (j<2) {
            minslice = minslice_Region1; // currently cH (left and right)
            maxslice = maxslice_Region1;
        } else if (j==2 || j==3)  {
            minslice = minslice_Region2; // currently mLH (left and right)
            maxslice = maxslice_Region2;
        } else if (j>3) {
            minslice = minslice_Region3; // currently lLH (left and right)
            maxslice = maxslice_Region3;
        }

        // Transfer ROI to Thresholded image
		for (k= minslice; k< maxslice ; k++) {

            // pERK channel
            selectWindow(Original);
            roiManager("Select",j);
            setSlice(k);
            run("Measure");

            if (usetERK==1){
            
                // tERK channel
                selectWindow(tERK);
                roiManager("Select",j);
                setSlice(k);
                run("Measure");

                if (getResult("%Area", 0) > minarea){
                    
                    //pERK/tERK fluorescence for frame
                    getResult("Mean", 0)/getResult("Mean", 1);
                    run("Clear Results");	
                } else {
                    print("NaN");
                }				
   						
            } else {

                if (getResult("%Area", 0) > minarea){

                    //pERK only
                    getResult("Mean");
				} else {
                    print("NaN");
                }
						
            }
        }

        //Below you may also need to modify code
        //Region 1 (left and right)
        if(j==1) {
            selectWindow("Log");
            saveAs("Text", target_dir + "/" + list2[i] + "_" + Region1_name + ".txt");
            print("\\Clear"); 
            run("Close"); 
        }
			
		//Region 2 (left and right)
        if(j==3) {
            selectWindow("Log");
            saveAs("Text", target_dir + "/" + list2[i] + "_" + Region2_name + ".txt");
            print("\\Clear"); 
            run("Close"); 
        }

        //Region 3 (left and right)
        if(j==5) {
            selectWindow("Log");
            saveAs("Text", target_dir + "/" + list2[i] + "_" + Region3_name + ".txt");
            print("\\Clear"); 
            run("Close"); 
        }
	
        run("Clear Results");	
    }

    run("Clear Results");
    run("Close All"); 	
    	
    showProgress(i, list2.length);
    run("Collect Garbage");
}

selectWindow("ROI Manager");
run("Close");
