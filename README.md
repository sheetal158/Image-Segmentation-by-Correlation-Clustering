Image-Segmentation-by-Correlation-Clustering
============================================

1. Libraries used
VLFeat's SLIC superpixels, SVM training

2. Structure of the code 

2.1 Files for Training
superPixel.m ­ Initial Superpixel generation code
construct_superPixelGraph.m ­ Constructing pairwise superpixel graphs from superpixels.
featureExtraction.m ­ Extracting pairwise features between adjacent superpixels in the graphs.
ground_truth_by_maximum_consesus.m ­ As BSD (Berkeley data) gives the ground truth segmentation by multiple subjects for each image, we form a single ground truth image by taking the maximum consensus over each segmentation of the image.
assign_label_to_edges.m ­ Using the ground truth, the edges of the constructed graph are labeled +1 or ­1
train_classifier.m ­ For the features extracted and the labels assigned to the edges, the SVM is trained
retrain_classifier.m ­ Retrained with Hard Negative samples color_segments.m ­ used to color the segments in the image for displaying

2.2 Files for Multiple iterations Approach
The folders: order1_files, order2_files, order3_files, order4_files, order5_files, order6_files, order7_files, order8_files, contain the files for each iteration respectively.
For each iteration, we have,
construct_superPixelGraph.m featureExtraction.m assign_label_to_edges.m
superpixels_order.m ­ Generates the superpixels for the next iteration 2.2 Files for Correlation Clustering:
correlation_clustering.py ­ (Source ­ https://github.com/filkry/py­correlation­clustering)
It takes in the input of the edge labeled graph in the form of a text file. The file is parsed to construct the graph using network library. Correlation clustering is performed on the graph and the output of clusters formed is given in a text file.

2.3 Files for Evaluation
compare_segmentations.m ­ To calculate performance measures like Probabilistic Rand Index and Variation of Information. (Source ­ https://code.google.com/p/phd­workspace/source/browse/trunk/Berkeley_Segmentation/segb ench/SegmentationBenchmark/?r=5)
compare_image_boundary_error.m ­ To calculate performance measures like Boundary Displacement Error (Source ­ https://code.google.com/p/phd­workspace/source/browse/trunk/Berkeley_Segmentation/segb ench/SegmentationBenchmark/?r=5)
