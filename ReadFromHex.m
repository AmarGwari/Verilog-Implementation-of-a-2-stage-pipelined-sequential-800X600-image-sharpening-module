filename = 'BWOP.hex';
q = quantizer('fixed', 'nearest', 'saturate', [8 0]);% quantizer object for num2hex function  
FID = fopen(filename);
dataFromfile = textscan(FID, '%s');% %s for reading string values (hexadecimal numbers)
dataFromfile = dataFromfile{1}; %First Column
decData = hex2num(q, dataFromfile);
BW = cell2mat(decData);
fclose(FID);


BWMask = zeros([600 800]);
ptr=1;

for k = 1:600
    for l = 1:800
        BWMask(k,l) = BW(ptr);
        ptr = ptr+1;
    end
end

figure,imshow(uint8(BWMask));