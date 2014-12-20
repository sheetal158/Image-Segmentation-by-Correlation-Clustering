function ground_truth_by_maximum_consesus()


groundTruthSegmentsfiles = dir('BSR_bsds500/BSR/BSDS500/data/groundTruth/train/*.mat'); 
nfiles = length(groundTruthSegmentsfiles); 

for index=1:nfiles
    currentfilename = groundTruthSegmentsfiles(index).name;
    allGroundTruths = load(strcat('BSR_bsds500/BSR/BSDS500/data/groundTruth/train/',currentfilename));

finalSegments = zeros(size(allGroundTruths.groundTruth{1,1}.Segmentation,1),size(allGroundTruths.groundTruth{1,1}.Segmentation,2));
allDecisions = zeros(1,size((allGroundTruths.groundTruth),2));
for i=1:size(finalSegments,1)
    for j=1:size(finalSegments,2)
        for k=1:size(allDecisions,2)
            allDecisions(k)=allGroundTruths.groundTruth{1,k}.Segmentation(i,j);
        end
        finalSegments(i,j) = mode(allDecisions);
    end
end

matFileName = strcat('groundtruth_segments/',currentfilename);
save(matFileName, 'finalSegments');

end

end