function color_segments()

%used to color the segments in the image for displaying
r = randi([1 255],1,1000);
g = randi([1 255],1,1000);
b = randi([1 255],1,1000);

segmentFileMat = load(strcat('BSR_bsds500/BSR/BSDS500/data/groundTruth/test/163062.mat'));

[m, n] = size(segmentFileMat.finalSegments);
I = zeros(m,n,3);

for i=1:m
    for j=1:n
        color_index=segmentFileMat.finalSegments(i,j);
        I(i,j,1)=r(color_index);
        I(i,j,2)=g(color_index);
        I(i,j,3)=b(color_index);
    end    
end

imshow(I/256);

end