function retrain_classifier()

feature_matrix = load('Features_lab_v2/train/Features.mat');
label_vector= load('edge_labels/train/labelsMatrix.mat');
w = load('trained_model_v2/weight.mat');
b = load('trained_model_v2/bias.mat');

hard_negatives_1 = [];
hard_negatives_2 = [];
hard_negatives_3 = [];
hard_negatives=[];
hard_negatives_labels =[];

labels = zeros(1,size(feature_matrix.FeatureVector,2));
[~,~,~, scores] = vl_svmtrain(feature_matrix.FeatureVector, labels, 0, 'model', w.w, 'bias', b.b, 'solver', 'none') ;

for i=1:size(scores,2)
    if and(label_vector.labelsMatrix(1,i)==-1, scores(1,i)>1.1)
        hard_negatives_1 = horzcat(hard_negatives_1,feature_matrix.FeatureVector(1,i));
        hard_negatives_2 = horzcat(hard_negatives_2,feature_matrix.FeatureVector(2,i));
        hard_negatives_3 = horzcat(hard_negatives_3,feature_matrix.FeatureVector(3,i));
        hard_negatives = vertcat(hard_negatives_1, hard_negatives_2);
        hard_negatives = vertcat(hard_negatives, hard_negatives_3);
        hard_negatives_labels = horzcat(hard_negatives_labels,[-1]);
    end    
end    

disp(size(feature_matrix.FeatureVector));
feature_matrix.FeatureVector = horzcat(feature_matrix.FeatureVector,hard_negatives);
label_vector.labelsMatrix = horzcat(label_vector.labelsMatrix, hard_negatives_labels);

[w, b, info, scores] = vl_svmtrain(feature_matrix.FeatureVector, label_vector.labelsMatrix, 0.01) ;
disp(min(scores));
disp(max(scores));
disp(size(feature_matrix.FeatureVector));
save('retrained_model_v2/weight.mat', 'w');
save('retrained_model_v2/bias.mat', 'b');

end