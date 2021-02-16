I = imread('AwkwardDoge.PNG');
I2 = rgb2gray(I);
I3 = imresize(I2,[600 800]);
figure,imshow(I3)
