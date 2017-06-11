function [ score ] = sepScoreRobust_norm_OSS( X, idx_classes)
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

%Set nan to 0
X(isnan(X)) = 0;

%Transform data to 3 dimension by OSS-LDA
%Store indecies in OSS-LDA friendly format
classId = ones(1,size(X,2));
for i=1:length(idx_classes)
    classId(idx_classes{i}) = i;
end
%reduce dimensionality with PCA to prevent singularity of within/between
%matrix
[loadings, ~, ~, ~, ~, ~] = pca(X','Centered','off');
noSamp = size(X,2);
Xmean = mean(X')';

%Parameters for OSSLDA
displayFlag=0;
d=3;

%OSS-LDA + PCA reduction
s = warning('error', 'MATLAB:nearlySingularMatrix'); %Convert singularity warning to error to be able to catch it
ignoreDim=-1; %Start by ignoring no dimensio (-1 due to order of code in try)
cond=true;
while(cond)
    %Remove 1 dim at a time until singularity no longer thrown.
    try
        ignoreDim = ignoreDim +1;
        %Since different num of loading vectors are used, X will change dim
        clear Xpca
        for i=1:noSamp
            Xpca(:,i)=loadings(:,1:noSamp-ignoreDim)'*(X(:,i)-Xmean);
        end
        [BasisVectorsAsColumns,ScoreValuesAsColumns] = osslda(Xpca,classId,d,displayFlag);
        cond=false;
    end
end
Xred = Xpca-(BasisVectorsAsColumns*ScoreValuesAsColumns);
X = Xred;

%Construct global data
Xglob = [];
for i=1:length(idx_classes)
    idx = idx_classes{i};
    data = X(:, idx);
    numSamp = size(data,2);
    
    %Get distance within classes
    mClass = median(data');
    for j=1:numSamp
        dist(j) = norm(X(:,idx(j))-mClass');
    end
    
    %Calculate how many samples to remove
    rmSamples = round(numSamp*maxRmFrac, 0);
    if(rmSamples<1)
        rmSamples=1;
    end
    
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
    b = b + norm(mClass(i,:)-m,1)/norm(mClass(i,:),1);
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

