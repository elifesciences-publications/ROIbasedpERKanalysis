// Takes a two or three channel confocal stack and splits it 
// into individual channels.
// You need to specify below which channel is the tERK channel in order
// If stack is rotated/flipped, there is commented code on line 28-29
// that shows examples of how you can rotate the image 

tERKchannel = 1; // change accordingly
pERKchannel = 2; // change accordingly
otherchannel = 3; // only necessary if you have 3 channels

setBatchMode(true);

source_dir = getDirectory("Source Directory");
target_dir = getDirectory("Target Directory");

list = getFileList(source_dir);
list = Array.sort(list);

for (i=0; i<list.length; i++){
    
    Image = source_dir + list[i];
    open(Image);
    rename("Image");
  	
    maximum = pow(2, bitDepth())-1; 
	setMinAndMax(0, maximum);

    // run("Flip Vertically", "stack");
    // run("Rotate 90 Degrees Right", "stack");
 	
 	run("Split Channels");

    if (nImages == 3){ // three channels
    	
        tERKimage = "C" + tERKchannel + "-Image";
        pERKimage = "C" + pERKchannel + "-Image";
        otherimage = "C" + otherchannel + "-Image";
    	
        selectWindow(tERKimage); // select the tERK Channel
		saveName = target_dir + list[i] + "_01.nrrd"; // assign Y suffix number
		run("Reverse");
		run("Nrrd ... ", "nrrd=[saveName]");
		close();
		
		selectWindow(pERKimage);
		saveName = target_dir + list[i] + "_02.nrrd";
		run("Reverse");
		run("Nrrd ... ", "nrrd=[saveName]");
		close();
		
		selectWindow(otherimage);
		saveName = target_dir + list[i] + "_03.nrrd";
		run("Reverse");
		run("Nrrd ... ", "nrrd=[saveName]");
		close();
		
    }   else if (nImages == 2){

        tERKimage = "C" + tERKchannel + "-Image";
    	pERKimage = "C" + pERKchannel + "-Image";
		
		selectWindow(tERKimage);
		saveName = target_dir + list[i] + "_01.nrrd";
		run("Reverse");
		run("Nrrd ... ", "nrrd=[saveName]");
		close();
		
		selectWindow(pERKimage);
		saveName = target_dir + list[i] + "_02.nrrd";
		run("Reverse");
		run("Nrrd ... ", "nrrd=[saveName]");
		close();
		
	}   else {
		
		exit("ERROR: not a 2 or 3 channel image");
	}

    while (nImages > 0){
    close();
	}
	
	run("Collect Garbage");
}

setBatchMode(false);
