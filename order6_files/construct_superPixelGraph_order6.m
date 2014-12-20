function [ Am ] = construct_superPixelGraph_order6()
%UNTITspMatrixED Summary of this function goes here
%   Detailed explanation goes here
% Taking pixel connectivity =8

superpixelfiles = dir('order6/8068.mat'); 
nfiles = length(superpixelfiles);    % Number of files found
for index=1:nfiles
    currentfilename = superpixelfiles(index).name;
    spStructure = load(strcat('order6/',currentfilename)); % get the struct from saved superpixel mat file
    spMatrix = spStructure.superpixels_o6; % get the super pixel matrix
    [rows,cols] = size(spMatrix);
    N = max(spMatrix(:)); % this will be size our undirected graph

    % Using sparse 
    i = zeros(rows*cols,1);  % row value
    j = zeros(rows*cols,1);  % col value
    s = zeros(rows*cols,1);  % value

    n = 1;
    for r = 1:rows-1
        % Handle pixels in 1st column
        i(n) = spMatrix(r,1); j(n) = spMatrix(r  ,2); s(n) = 1; n=n+1;
        i(n) = spMatrix(r,1); j(n) = spMatrix(r+1,1); s(n) = 1; n=n+1;
        i(n) = spMatrix(r,1); j(n) = spMatrix(r+1,2); s(n) = 1; n=n+1;

        % ... now the rest of the column
        for c = 2:cols-1
            i(n) = spMatrix(r,c); j(n) = spMatrix(r  ,c+1); s(n) = 1; n=n+1;
            i(n) = spMatrix(r,c); j(n) = spMatrix(r+1,c-1); s(n) = 1; n=n+1;
            i(n) = spMatrix(r,c); j(n) = spMatrix(r+1,c  ); s(n) = 1; n=n+1;
            i(n) = spMatrix(r,c); j(n) = spMatrix(r+1,c+1); s(n) = 1; n=n+1;
        end
    end

     % Form the logical sparse adjacency matrix
        Am = logical(sparse(double(i), double(j), double(s), double(N), double(N))); 

        % Zero out the diagonal 
        for r = 1:N
            Am(r,r) = 0;
        end

        % Ensure connectivity both ways for all regions.
        Am = Am | Am';
        token = strtok(currentfilename, '.');
        str1 =  strcat(token,'_spg.mat');
        matFileName = strcat('order6_graph/',str1);
        save(matFileName, 'Am');
end
end

