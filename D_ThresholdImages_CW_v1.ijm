// This script runs a thresholding algorithm over your pERK images
// Works for both registered and unregistered images
// The output is a binary image where active cells are black

// THRESHOLDING INSTRUCTIONS
// Manually decide what threshold you want to set for entire folder and specify it here
// You can manually estimate the correct threshold using Image > Adjust > Threshold
// Usually a few iterations are necessary 
// A good threshold will lead to segmentation of individual cells/small clusters
// It also depends on bit depth of your images
// IMPORTANT: Some parameters may need to be optimized based on your image resolution/quality.
// Particularly for background subtraction (Line 37) and contrast saturation (Line 38)

// Specify threshold below
threshold = 2500;  //2500 for test dataset 

// Specify the range in your Z-stack over which you would like to count the active cells
// If these are not registered images, then it might be best to first 
// ensure your images solely comprise the relevant frames.
// You can use the CropandSubstack_CW_v1.ijm to do this
minslice =41;
maxslice = 52;

setBatchMode(true);

main_dir = getDirectory("Main Directory");
source_dir = main_dir + "/RegisteredTiffs/pERK/";

target_dir = main_dir + "/Thresholded/";
File.makeDirectory(target_dir); 

list = getFileList(source_dir);

for (i=0; i<list.length+1; i++) {
    Image = source_dir + list[i];
    open(Image); 

   // So that thresholding only occurs within specified z range (substack)
    run("Make Substack...", " delete slices=" + minslice + "-" + maxslice); //need to change slice number here to one less than stack size
    setSlice(round((maxslice-minslice)/2));
    resetMinAndMax();

    // These parameters may need be optimized for your images
    run("Subtract Background...", "rolling = 100 stack");
    run("Enhance Contrast", "saturated=0.2"); //up to 0.4
    run("Smooth", "stack");
    run("Gaussian Blur...", "sigma=0.2 stack");

    //Thresholding and Masking
    setThreshold(0, threshold);
    run("Convert to Mask", "method=Default background=Default");
    run("Make Binary", "method=Default background=Default");

    // The following functions are used to further segment particles into individual units 
    // You don't necessarily need to perform these operations, but they seem to work well 
    // Open
    run("Open", "stack");
    // Erode
    run("Erode", "stack");
	// Watershed
    run("Watershed", "stack");

    // save
    saveAs("tiff", target_dir + "/" + list[i] + "_thresholdedmask.tiff");
    close();

}