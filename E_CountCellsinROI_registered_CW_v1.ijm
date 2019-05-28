// this is for use on registered images, so that you only need to define ROIs once
// Use CountCellsinROI_unregistered_CW_v1 if you have unregistered images

// IMPORTANT: Reference image needs to be in <Ref> folder under Registered Tiffs
// Order of selection is how the data will be ordered 
// E.g. left mLH, right mLH, left lLH, right lLH

NumberofROIs = 4;

// specify min and max object size
minObjsize = 5;
maxObjsize = 100;

print("\\Clear");
run("Clear Results");
run("Close All"); 

main_dir = getDirectory("Main Directory");
source_dir = main_dir + "/Thresholded/";
source_dir_ref = main_dir + "/RegisteredTiffs/Ref/";

// automatically generates this folder
File.makeDirectory(main_dir + "/CellCount_registered/"); 
target_dir = main_dir + "/CellCount_registered/";

list = getFileList(source_dir);
list_ref = getFileList(source_dir_ref);

Image_original = source_dir_ref + list_ref[0];
open(Image_original); 
Original = getTitle();
setTool("freehand"); 

// First define ROIs for all regions you want to count cells for 
for (j=0; j<NumberofROIs; j++) {	

    selectWindow(Original);
    run("Remove Overlay");
    waitForUser("Select region","Select the area to analyze and click 'OK'");  //select mLH then lLH

    if (j==0) {
        // Add ROIs to ROI manager
        run("Add Selection...");
        run("To ROI Manager");
    } else {
        roiManager("Add");
    }
}

// Now the automated cell counting begins
// Using thresholded images in "Thresholded" folder
setBatchMode(true);

for (i=0; i<list.length+1; i++) {
    
    Image_threshold = source_dir + list[i]; 
	
    open(Image_threshold);
    Threshold = getTitle(); 
   	  
    // loop through the ROIs and Count Cells 
    for (j=0; j<NumberofROIs; j++) {	
    
        // Transfer ROI to Thresholded image
        selectWindow(Threshold);
        roiManager("Select",j);	
        run("Analyze Particles...", "size=" + minObjsize + "-" + "maxObjsize" + " display stack");
        print(nResults); 
 
        run("Select None"); 
        run("Clear Results");
    }

    selectWindow("Log");
    saveAs("Text", target_dir + "/" + list[i] + ".txt");
    run("Close"); 
    run("Clear Results");
    run("Close All"); 	
    	
    showProgress(i, list.length);
    run("Collect Garbage");
}

selectWindow("ROI Manager");
run("Close");
