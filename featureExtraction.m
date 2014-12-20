function [ output_args ] = featureExtraction( input_args )
% Extraction of pairwise features from pairwise superpixel graphs.
% Saves feature vectors for all the images.

superpixelfiles = dir('C:/Users/Nitish/Documents/MATLAB/Comp Vision/Project/superpixel_v2/train/*.mat'); 
FeatureVector = []; % the feature vector where nrows=nimages*nedges and ncols=6
nfiles = length(superpixelfiles);    % Number of files found
for index=1:nfiles
    currentfilename = superpixelfiles(index).name;
    spStructure = load(strcat('C:/Users/Nitish/Documents/MATLAB/Comp Vision/Project/superpixel_v2/train/',currentfilename)); % get the struct from saved superpixel mat file
    spMatrix = spStructure.imseg.segimage; % get the super pixel matrix
    I=imread(strcat('C:/Users/Nitish/Documents/MATLAB/Comp Vision/Project/BSR_bsds500/BSR/BSDS500/data/images/train/',spStructure.imseg.imname));
    N = max(spMatrix(:));
    % RGB and LAB values for color feature
    labTransform=makecform('srgb2lab');
    labImage=applycform(I,labTransform);
    l1=labImage(:,:,1);
    a1=labImage(:,:,2);
    b1=labImage(:,:,3);
    R1=I(:,:,1);
    G1=I(:,:,2);
    B1=I(:,:,3);
    [rows,cols] = size(spMatrix);
    colorFeature = struct('l',zeros(1,N),'a',zeros(1,N),'b',zeros(1,N),'R',zeros(1,N),'G',zeros(1,N),'B',zeros(1,N));
    for i = 1:rows
        for j = 1:cols
            colorFeature.l(spMatrix(i,j)) = colorFeature.l(spMatrix(i,j)) + uint32(l1(i,j));
            colorFeature.a(spMatrix(i,j)) = colorFeature.a(spMatrix(i,j)) + uint32(a1(i,j));
            colorFeature.b(spMatrix(i,j)) = colorFeature.b(spMatrix(i,j)) + uint32(b1(i,j));
            colorFeature.R(spMatrix(i,j)) = colorFeature.R(spMatrix(i,j)) + uint32(R1(i,j));
            colorFeature.G(spMatrix(i,j)) = colorFeature.G(spMatrix(i,j)) + uint32(G1(i,j));
            colorFeature.B(spMatrix(i,j)) = colorFeature.B(spMatrix(i,j)) + uint32(B1(i,j));
        end
    end
    
    %Taking average
    for i=1:N
        if spStructure.imseg.npixels(i)~=0
            colorFeature.l(i)=colorFeature.l(i)/spStructure.imseg.npixels(i);
            colorFeature.a(i)=colorFeature.a(i)/spStructure.imseg.npixels(i);
            colorFeature.b(i)=colorFeature.b(i)/spStructure.imseg.npixels(i);
            colorFeature.R(i)=colorFeature.R(i)/spStructure.imseg.npixels(i);
            colorFeature.G(i)=colorFeature.G(i)/spStructure.imseg.npixels(i);
            colorFeature.B(i)=colorFeature.B(i)/spStructure.imseg.npixels(i);
        end
    end

 %Pairwise Feature Vector
 token = strtok(currentfilename, '.');
 str1 =  strcat(token,'_spg.mat');
 graph = load(strcat('C:/Users/Nitish/Documents/MATLAB/Comp Vision/Project/superpixelgraph_v2/train/',str1));
 [x y z] = find(graph.Am);
 FeatureVector_temp=[];
 for i=1:size(x,1)
    SinglePixelVector= vertcat(abs(colorFeature.l(x(i))-colorFeature.l(y(i))), abs(colorFeature.a(x(i))-colorFeature.a(y(i))), abs(colorFeature.b(x(i))-colorFeature.b(y(i))), abs(colorFeature.R(x(i))-colorFeature.R(y(i))), abs(colorFeature.G(x(i))-colorFeature.G(y(i))), abs(colorFeature.B(x(i))-colorFeature.B(y(i))));
    FeatureVector_temp= horzcat(FeatureVector_temp,SinglePixelVector);
    FeatureVector= horzcat(FeatureVector,SinglePixelVector);
 end
 token = strtok(currentfilename, '.');
 str1 =  strcat(token,'_feature.mat');
 matFileName = strcat('C:/Users/Nitish/Documents/MATLAB/Comp Vision/Project/Features_v2/train/',str1);
 save(matFileName, 'FeatureVector_temp');
end
%saving the feature vector

save('C:/Users/Nitish/Documents/MATLAB/Comp Vision/Project/Features_v2/train/Features.mat','FeatureVector');
end

