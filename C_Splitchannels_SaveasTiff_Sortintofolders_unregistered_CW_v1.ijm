// Takes a two or three channel confocal stack and splits it 
// into individual channels and sorts into pERK or tERK folders
// You need to specify below which channel is the tERK channel in order
// If stack is rotated/flipped, there is commented code on line 35-36
// that shows examples of how you can rotate the image 
// You only need to specify the main directory containing the images
// NOT the image folder itself
// any 3rd channel is ignored as it won't be used for further analysis 
tERKchannel = 2;
pERKchannel = 3;

setBatchMode(true);

main_dir = getDirectory("Main Directory");

source_dir = main_dir + "/Tiffs/";
File.makeDirectory(main_dir + "/SplitTiffs/"); 
target_dir = main_dir + "/SplitTiffs/";

File.makeDirectory(target_dir + "/pERK/"); 
File.makeDirectory(target_dir + "/tERK/"); 

target_dir1 = target_dir + "/tERK/";
target_dir2 = target_dir + "/pERK/";

list = getFileList(source_dir);
list = Array.sort(list);

for (i=0; i<list.length + 1; i++) {

  	Image = source_dir + list[i];
  	
  	// run("Bio-Formats Importer", "open='"+ Image +"' color_mode=Default view=Hyperstack stack_order=XYCZT");
  	open(Image);

  	// run("Flip Vertically", "stack");
    // run("Rotate 90 Degrees Right", "stack");
  	
	run("Split Channels");

	selectWindow("C" + tERKchannel + "-" + list[i]);
   	saveAs("tiff", target_dir1 + "/" + list[i] + "-C" + tERKchannel + ".tiff");
    close();

    selectWindow("C" + pERKchannel + "-" + list[i]);
   	saveAs("tiff", target_dir2 + "/" + list[i] + "-C" + pERKchannel + ".tiff");
    close();

	while (nImages > 0){
		close();
	}
	run("Collect Garbage");

}

setBatchMode(false);
