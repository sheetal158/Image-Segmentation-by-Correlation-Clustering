function [ ] = superPixel()
% Superpixel generation code
% Uses VLFEAT slic function to compute initial superpixels
% Stores superpixels for each image with extra information like image name,
% number of superpixels, number of pixels in each superpixel and image size.
imagefiles = dir('BSR_bsds500\BSR\BSDS500\data\images\test\*.jpg');            
nfiles = length(imagefiles);    % Number of files found
for i=1:nfiles
    currentfilename = imagefiles(i).name;
    currentimage = imread(strcat('BSR_bsds500/BSR/BSDS500/data/images/test/',currentfilename));
    imlab = vl_xyz2lab(vl_rgb2xyz(currentimage)) ;
    superPixelMatrix = vl_slic(single(imlab),40,1); %Using variable sizes to use superpixels of different sizes
    superPixelMatrix = superPixelMatrix+1; %because of 0 label in superpixel matrix
    maxPixelId = max(max(superPixelMatrix(:)));
    field1 = 'imname';  value1 = currentfilename;
    field2 = 'segimage';  value2 = superPixelMatrix;
    field3 = 'nseg';  value3 = maxPixelId;
    field4 = 'npixels';  value4 = count_pixels_superpixels(superPixelMatrix,maxPixelId);
    field5 = 'imsize'; value5 = size(currentimage);
    imseg = struct(field1,value1,field2,value2,field3,value3,field4,value4,field5,value5);
    token = strtok(currentfilename, '.');
    str1 =  strcat(token,'.mat');
    matFileName = strcat('C:\Users\Nitish\Documents\MATLAB\Comp Vision\Project\superpixel_v3\test\',str1);
    save(matFileName,'imseg');
end
end

% returns a vector with number of pixels in each superpixel
function [ countPixels ] = count_pixels_superpixels( superPixelMatrix,maxPixelId )
countPixels= zeros(maxPixelId,1);
[width height]=size(superPixelMatrix);

for i=1:width
    for j=1:height
        countPixels(superPixelMatrix(i,j))=countPixels(superPixelMatrix(i,j))+1;
    end
end

end
