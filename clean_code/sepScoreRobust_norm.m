function [ score ] = sepScoreRobust_norm( X, idx_classes)
%SEPSCOREROBUST Calculates sepScore on using 85% of data
%   Algorithm
%   1. Extract the full dataset to be used (only idx_classes is used, and
%      only 85% of that data is used)
%       For each idx_classes
%           a) Extract samples from that class
%           b) Calculate distances within the class (from sample to mean)
%           c) Calculate how many samples to remove
%           d) Remove the most extrem samples (as many as calc. in c)
%   2. Calculate variance between each class
%   3. Calculate variance within each class
%   4. Calculate seperation score as (between variance)/(within variance)
%   Input
%       X(matrix)  - feature as rows, examples as columns
%       idx_classes(cell array) - each cell contains indecies for one class
%   Output:
%       score(double) - the seperation score

%Parameters
maxRmFrac = 0.2; %Remove atleast one but maximum 20% of data

%Correct data
X(isnan(X)) = 0; %Set nan to 0

%Construct global data
Xglob = [];
for i=1:length(idx_classes)
    idx = idx_classes{i};
    data = X(:, idx);
    numSamp = size(data,2);
   
    %Get distance within classes
    mClass = median(data');
    dist = [];
    for j=1:numSamp
        dist(j) = norm(X(:,idx(j))-mClass');
    end
    
    %Calculate how many samples to remove
    rmSamples = round(numSamp*maxRmFrac, 0);
%     if(rmSamples<1)
%         rmSamples=1;
%     end
    
    %Remove outliers
    while(rmSamples>0)
        [~, ind] = max(dist);
        idx(ind) = [];
        dist(ind) = [];
        rmSamples = rmSamples -1;
    end
    idx_classes{i} = idx; 
    
    Xglob = [Xglob, X(:, idx_classes{i})];
end

%Calculate between variance
m = median(Xglob'); %global mean
b = 0; %initalize
for i=1:length(idx_classes)
    mClass(i,:) = median(X(:,idx_classes{i})');
    b = b + norm(mClass(i,:)-m,1)/norm(m,1);
end
b = b/length(idx_classes);


%Calculate within variance
for i=1:length(idx_classes)
    wClass(i) = 0;
    idx = idx_classes{i};
    for (j=1:length(idx)) 
        wClass(i) = wClass(i) + norm(X(:,idx(j))-mClass(i,:)',1)/norm(mClass(i,:)',1); 
    end
    wClass(i) = wClass(i)/length(idx);
end
w = mean(wClass);
    
score = b/w;

end

