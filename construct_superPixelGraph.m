function [ mat ] = construct_superPixelGraph()
% Constructing superpixel graphs from superpixels generated
% These are pairwise graphs; only neighbors are taken into account
%Saves graphs for all images

superpixelfiles = dir('C:/Users/Nitish/Documents/MATLAB/Comp Vision/Project/superpixel_v3/test/*.mat'); 
nfiles = length(superpixelfiles);    % Number of files found
for index=1:nfiles
    currentfilename = superpixelfiles(index).name;
    spStructure = load(strcat('C:/Users/Nitish/Documents/MATLAB/Comp Vision/Project/superpixel_v3/test/',currentfilename)); % get the struct from saved superpixel mat file
    spMatrix = spStructure.imseg.segimage; % get the super pixel matrix
    [rows,cols] = size(spMatrix);
    N = max(spMatrix(:)); % this will be size our undirected graph
    i = 1;
    % Using sparse matrix to save space
    %rows
    x = zeros(rows*cols,1);
    
    %columns
    y = zeros(rows*cols,1);
    
    %values
    z = zeros(rows*cols,1);
    for r = 1:rows-1
        %just seeing 4 neighbor pixels around the given pixel
        x(i) = spMatrix(r,1);
        y(i) = spMatrix(r  ,2);
        z(i) = 1; 
        i=i+1;
        x(i) = spMatrix(r,1);
        y(i) = spMatrix(r+1,1);
        z(i) = 1; 
        i=i+1;
        x(i) = spMatrix(r,1);
        y(i) = spMatrix(r+1,2);
        z(i) = 1; 
        i=i+1;
        for c = 2:cols-1
            x(i) = spMatrix(r,c); 
            y(i) = spMatrix(r  ,c+1);
            z(i) = 1;
            i=i+1;
            x(i) = spMatrix(r,c);
            y(i) = spMatrix(r+1,c-1);
            z(i) = 1;
            i=i+1;
            x(i) = spMatrix(r,c);
            y(i) = spMatrix(r+1,c  );
            z(i) = 1;
            i=i+1;
            x(i) = spMatrix(r,c);
            y(i) = spMatrix(r+1,c+1);
            z(i) = 1;
            i=i+1;
        end
    end

        % logical matrix
        mat = logical(sparse(double(x), double(y), double(z), double(N), double(N))); 
        % no self loos in graph
        for j = 1:N
            mat(j,j) = 0;
        end
        % if x is connected to y, y should also be connected to y
        mat = mat | mat';
        token = strtok(currentfilename, '.');
        str1 =  strcat(token,'_spg.mat');
        matFileName = strcat('C:\Users\Nitish\Documents\MATLAB\Comp Vision\Project\superpixelgraph_v3\test\',str1);
        save(matFileName, 'mat');
end

end

