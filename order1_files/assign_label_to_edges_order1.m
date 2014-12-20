function assign_label_to_edges_order1()

superpixelfiles = dir('../superpixel_v2/test/8068.mat');
nfiles = length(superpixelfiles);

for index=1:nfiles
    currentfilename = superpixelfiles(index).name;
    token = strtok(currentfilename, '.');
    str1 =  strcat(token,'_feature.mat');
    disp(str1);
    FeaturesMat = load(strcat('../Features_lab_v2/test/',str1));
    
    labels = zeros(1,size(FeaturesMat.FeatureVector_temp,2));
    
    w = load('../retrained_model_v2/weight.mat');
    b = load('../retrained_model_v2/bias.mat');
    
    [~,~,~, scores] = vl_svmtrain(FeaturesMat.FeatureVector_temp, labels, 0, 'model', w.w, 'bias', b.b, 'solver', 'none') ;
   
    str2 =  strcat(token,'_spg.mat');
    pathTosuperpixelGraph = strcat('../superpixelgraph_v2/test/',str2);
    superpixelGraphMat = load(pathTosuperpixelGraph);
    [x y z] = find(superpixelGraphMat.Am);

    fid = fopen(strcat('extracted_edge_labels_order1/edge_labels_extracted_o1_',strcat(token,'.txt')),'a');    
    edgeLabels = zeros(1,size(x,1));
    for i = 1:size(x,1)
        
        if scores(1,i)>1.00
            edgeLabels(1,i) = 1;
        else
            edgeLabels(1,i) = -1;
        end   
        
        fprintf(fid, '%d, %d, %d\n', edgeLabels(1,i), x(i), y(i))
    end
    
    fclose(fid);

    str1 =  strcat(token,'.mat');
    matFileName = strcat('order1_edge_labels/',str1);
    save(matFileName, 'edgeLabels');

end

end