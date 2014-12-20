function train_classifier()

feature_matrix = load('Features_lab_v2/train/Features.mat');
label_vector= load('edge_labels/train/labelsMatrix.mat');
[w, b, info, scores] = vl_svmtrain(feature_matrix.FeatureVector, label_vector.labelsMatrix, 0.01) ;

disp(max(scores));
disp(min(scores));


save('trained_model_v2/weight.mat', 'w');
save('trained_model_v2/bias.mat', 'b');

end