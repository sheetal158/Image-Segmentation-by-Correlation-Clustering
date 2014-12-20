function [ output_args ] = featureExtraction_lab( input_args )
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here

superpixelfiles = dir('order3/8068.mat'); 
FeatureVector = []; % the feature vector where nrows=nimages*nedges and ncols=6
nfiles = length(superpixelfiles);    % Number of files found
for index=1:nfiles
    currentfilename = superpixelfiles(index).name;
    spStructure = load(strcat('order3/',currentfilename)); % get the struct from saved superpixel mat file
    spMatrix = spStructure.superpixels_o3; % get the super pixel matrix
    token = strtok(currentfilename, '.');
    str1 =  strcat(token,'.jpg');
    I=imread(strcat('../BSR_bsds500/BSR/BSDS500/data/images/test/',str1));
    N = max(spMatrix(:));
    % RGB and LAB values for color feature
    labTransform=makecform('srgb2lab');
    labImage=applycform(I,labTransform);
    l1=labImage(:,:,1);
    a1=labImage(:,:,2);
    b1=labImage(:,:,3);
    [rows,cols] = size(spMatrix);
    colorFeature = struct('l',zeros(1,N),'a',zeros(1,N),'b',zeros(1,N));
    for i = 1:rows
        for j = 1:cols
            colorFeature.l(spMatrix(i,j)) = colorFeature.l(spMatrix(i,j)) + uint32(l1(i,j));
            colorFeature.a(spMatrix(i,j)) = colorFeature.a(spMatrix(i,j)) + uint32(a1(i,j));
            colorFeature.b(spMatrix(i,j)) = colorFeature.b(spMatrix(i,j)) + uint32(b1(i,j));
        end
    end
    

    npixels = zeros(1,N);
    
    for i=1:size(spMatrix,1)
        for j=1:size(spMatrix,2)
            npixels(1,spMatrix(i,j)) = npixels(1,spMatrix(i,j))+1;
        end   
    end    
    
    %Taking average
    for i=1:N
        if npixels(1,i)~=0
            colorFeature.l(i)=colorFeature.l(i)/npixels(1,i);
            colorFeature.a(i)=colorFeature.a(i)/npixels(1,i);
            colorFeature.b(i)=colorFeature.b(i)/npixels(1,i);
        end
    end

 %Pairwise Feature Vector
 token = strtok(currentfilename, '.');
 str1 =  strcat(token,'_spg.mat');
 graph = load(strcat('order3_graph/',str1));
 [x y z] = find(graph.Am);
 FeatureVector_temp=[];
 for i=1:size(x,1)
    SinglePixelVector= vertcat(abs(colorFeature.l(x(i))-colorFeature.l(y(i))), abs(colorFeature.a(x(i))-colorFeature.a(y(i))), abs(colorFeature.b(x(i))-colorFeature.b(y(i))));
    FeatureVector_temp= horzcat(FeatureVector_temp,SinglePixelVector);
    FeatureVector= horzcat(FeatureVector,SinglePixelVector);
 end
 matFileName = strcat('order3_features/',currentfilename);
 save(matFileName, 'FeatureVector_temp');
end
%saving the feature vector

save('order3_features/Features.mat','FeatureVector');
end

