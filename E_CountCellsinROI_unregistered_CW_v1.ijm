// this is for use on unregistered images that were previously split by channel
// D_ThresholdImages_unregistered_CW_v1 must have been performed.
// You will need to define ROI for EACH image
// hence no reference image needed

// You can change startnum, i.e. file at which you want to begin the loop
// as you might make a mistake in between and need to kill the script
// Remember that the way the list is sorted by imageJ may be different from what you visualize in the folder

startnum = 0; // default = 0

// Order of ROI selection is how the data will be ordered 
// E.g. left mLH, right mLH, left lLH, right lLH

NumberofROIs = 4;

// specify min and max object size
minObjsize = 5;
maxObjsize = 100;

print("\\Clear");
run("Clear Results");
run("Close All"); 

setBatchMode(false);

main_dir = getDirectory("Main Directory");

source_dir = main_dir + "/Thresholded/";
source_dir2 = main_dir + "/SplitTiffs/pERK/";

File.makeDirectory(main_dir + "/CellCount/"); 
target_dir = main_dir + "/CellCount/";

list = getFileList(source_dir);
list2 = getFileList(source_dir2);
  
for (i=startnum; i<list.length+1; i++) {

    Image_threshold = source_dir + list[i];
    Image_original = source_dir2 + list2[i];

    open(Image_original); 
    Original = getTitle();
    open(Image_threshold);
    Threshold = getTitle();

    setTool("freehand"); 
        
    for (j=0; j<NumberofROIs; j++) {
        // First define ROIs for all regions you want to count cells for lobes
        // for this particular image 
        selectWindow(Original);
        run("Remove Overlay");
        waitForUser("Select region","Select the area to analyze and click 'OK'");  //select mLH then lLH
    	
        // Add ROI to ROI manager
        run("Add Selection...");
        run("To ROI Manager");

        // Transfer ROI to Thresholded image
        selectWindow(Threshold);
        roiManager("Select",0);
        run("Analyze Particles...", "size=" + minObjsize + "-" + "maxObjsize" + " display stack");
    	
        run("Select None");
        print(nResults); 
        run("Clear Results");
    	
        selectWindow("ROI Manager");
        run("Close");
    }
    
    selectWindow("Log");
    saveAs("Text", target_dir + "/" + list[i] + ".txt");
    selectWindow("Log");
    run("Close"); 

    run("Clear Results");
    run("Close All"); 

    showProgress(i, list.length);
    run("Collect Garbage");
  }