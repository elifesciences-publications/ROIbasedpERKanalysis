// For converting registered images (nrrds) are converted into Tiffs
// For the purpose of analysis, the pERK and tERK files now have to be separated
// Only works if you have pERK and tERK channels, no others channel
// Also works for unregistered Tiff images 
// IMPORTANT: A separate folder called "Ref" will also be generated, HOWEVER
// if your images are registered, you will have to put the reference image 
// into the folder manually for subsequent code to work correctly

// All you need to do is specify the main directory within which your 
// registered images (probably in <reformatted> folder) are contained 
// All other folders will be subsequently generated and saved in the same directory

setBatchMode(true);

main_dir = getDirectory("Main Directory");

source_dir = main_dir + "/reformatted/";
File.makeDirectory(main_dir + "/RegisteredTiffs/"); 
target_dir = main_dir + "/RegisteredTiffs/";

File.makeDirectory(target_dir + "/pERK/"); 
File.makeDirectory(target_dir + "/tERK/"); 
File.makeDirectory(target_dir + "/Ref/"); 

target_dir1 = target_dir + "/tERK/";
target_dir2 = target_dir + "/pERK/";

list = getFileList(source_dir);
list = Array.sort(list);

for (i=0; i<list.length; i++) {
    Image = source_dir + list[i];
    open(Image);
 
    maximum = pow(2, bitDepth())-1; 
    setMinAndMax(0, maximum);

 	if (i%2==1){
 		saveAs("tiff", target_dir2 + "/" + list[i] + ".tiff");
 	} else {
  		saveAs("tiff", target_dir1 + "/" + list[i] + ".tiff");
 	}
 	
    close();
}