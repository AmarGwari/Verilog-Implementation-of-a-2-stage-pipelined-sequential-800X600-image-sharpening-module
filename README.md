# Verilog-Implementation-of-a-sequential-800X600-image-sharpening-module
We work with a Black and White photo here. The size of it should be 800 columns and 600 rows.

### Reading Image
Image is read using MATLAB code **'WriteToTxt.m'** given above. Hexadecimal values are used.

				
### Kernel used for edge detection
|-1|-1|-1|
|--|--|--|
|-1|9 |-1|
|-1|-1|-1|

### Reconstructing the Image
The output memory is read and the values of the pixels (in hexadecimal) are arranged in an array and shown as image, using **'ReadFromHex.m'** file.
