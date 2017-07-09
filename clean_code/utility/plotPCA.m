function [ ] = plotPCA( I, idxGroups)
%PLOTPCA Function to visualize data according to classes
%   PCA only provides good visualization on log-data. Will convert if not
%   log. 
%   Input:
%       I(matrix) - features as rows, columns
%       idxGroups(cell array) - each cell is a list of indicies to be colored
%       in one color.

%Check if logged
maxI = max(max(I));
if(maxI>100)
    disp('WARN: Assuming data has not been log transformed, will automatically log transform before PCA')
    I(I<1) = 1;
    I = log(I);
end

%Perform PCA
[c, s, l] = pca(I');

%Plot first 2 score of groups in seperate colors
figure()
for i=1:length(idxGroups)
    hold on
    scatter(s(idxGroups{i},1), s(idxGroups{i},2),'filled')
end
hold off
title('PCA of Intensities')

end

