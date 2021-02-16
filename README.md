# Verilog-Implementation-of-a-2-stage-pipelined-sequential-800X600-image-sharpening-module
We work with a Black and White photo here. The size of it should be 800 columns and 600 rows.

###Reading Image
Image is read using MATLAB code given above. Hexadecimal values are used.

###Processing the Data

####There are 2 stages
Fetch stage : We take the addresses stored in Fetch Register and read input values at those addresses.
Update stage :  We take input values and output address in the Update Register, and input address in Fetch Register and put them in Maths modules.Sharper (to sharpen the image) and address updaters to update addresses. The updated addresses are given to Fetch Register and sharpened value is written to output memory at address in Update Register.
				
####Kernel used for edge detection
|-1|-1|-1|
|-1|9|-1|
|-1|-1|-1|

####Current problem?
The output of the module sharpens the image but also halves the brightness. This can be easily fixed in MATLAB, during image reconstruction we can multiply the image array by 2 to fix it. (It is shown here in the given images)

###Reconstructing the Image
The output memory is read and the values of the pixels (in hexadecimal) are arranged in an array and shown as image.

###Running Simulations
The BWPaddedPic.hex file has the 8bit pixel values for a 800columns and 600row , black and white version of the "AwkwardDoge.PNG' image file. (Its screenshot is given, named 'original_BW_pic.png') 
The BWOP.hex file has the 8bit pixel values of the sharpened image which is the output of our module. (Its screenshot is given, here named 'Sharp.png')
The intensity fixed (using MATLAB) sharped image's screenshot is given here named 'Sharp_times2.png'.
The Side by Side comparison of the SharpedandFixed image and original image is shown in picture, 'SidebySide.png'.

###Planning for circuit
I had made 3 plans, each one better than last and the last plan is given in image 'Plan for Circuit.png'.
