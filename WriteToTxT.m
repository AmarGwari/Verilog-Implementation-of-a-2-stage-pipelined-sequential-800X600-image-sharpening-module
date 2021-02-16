I = imread('AwkwardDoge.PNG');
I1 = imresize(I,[600,800]);
I2 = rgb2gray(I1);
% imshow(I2);

row = size(I2, 1);
col = size(I2, 2);

PaddedArr = zeros([602 802]);

for k=1:600
    for l=1:800
        PaddedArr(k+1,l+1) = I2(k,l);
    end
end

size = 602*802;
BW = zeros([1 size]);

ptr = 1;
for k = 1:602
    for l = 1:802
        BW(ptr) = PaddedArr(k,l);
        ptr = ptr+1;
    end
end

fid = fopen('BWPaddedPic.hex','wt');
fprintf(fid,'%x\n',BW);
fclose(fid);