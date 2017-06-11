%close all

dataEval = dataBatch;

%Remove blanks and pools before split and batch removal
idxRm = [findSampleIdx(dataEval.sMeta, 'QC');...
    findSampleIdx(dataEval.sMeta, 'BLANK');...
    findSampleIdx(dataEval.sMeta, 'STDMIX')];
dataEval = removeIdx(dataEval, idxRm, 'sample', dispFlag);

dataEval = cleanData(dataEval, dispFlag);
%[~,~,~,~,e,~] = pca(dataEval.I');
%figure(); plot(cumsum(e));

classNames = unique(dataEval.sMeta.class(:)); 
idxClass = cell(0);
j= 1;
for i=1:length(classNames)
    idxTemp = findSampleIdx(dataEval.sMeta, classNames{i});
    if(length(idxTemp)>1)
        idxClass{j} = idxTemp;
        j = j +1;
    end
end

score_all = sepScoreRobust_norm(dataEval.I, idxClass);
disp(['Score all is ' num2str(score_all)]);

%% Sort by tissue type

classNames = unique(dataEval.sMeta.class(:)); 
idxClass = cell(3,1);
origin = cell(length(classNames),1);
for i=1:length(classNames)
    sample_idx = findSampleIdx(dataEval.sMeta, classNames{i});
    %find out if b, p or s
    type = classNames{i}(end);
    origin{i} = classNames{i}(1:(end-1));
    if(type=='b')
        idxClass{1} = [idxClass{1}; sample_idx];
    elseif(type=='p')
        idxClass{2} = [idxClass{2}; sample_idx];
    elseif(type=='s')
        idxClass{3} = [idxClass{3}; sample_idx];
    else
        warning(['No type info found in ' classNames{i} '. Skipping assignment.'])
    end
end

%plotPCA(dataEval.I, idxClass);
%figure();imagesc(dataEval.I);colorbar();title('post');
score_tissue = sepScoreRobust_norm(dataEval.I, idxClass);
disp(['Score tissue is ' num2str(score_tissue)]);

%% Sort by origin
idxTissue = idxClass;
origin = unique(origin);
sepScore = [];
tissues = {'b', 'p', 's'};

%for each tissue
for i=1:length(idxTissue)
    samples = idxTissue{i};
    %for each origin
    idxOrigin = cell(0); %initiate
    for j=1:length(origin)
        idxTemp = findSampleIdx(dataEval.sMeta(samples,:), origin{j});
        if(~isempty(idxTemp))
            idxOrigin{end+1} = idxTemp;
        end
    end
    sepScore(i) = sepScoreRobust_norm(dataEval.I(:,samples), idxOrigin);
    %plotPCA(dataEval.I(:,samples), idxOrigin);
    %dendrograms(dataEval.I(:,samples), idxOrigin, ['tissue ' tissues{i}])
end
score_origins = mean(sepScore);
disp(['Score origins is ' num2str(score_origins)]);

%% Across tissues
origins = unique(origin);
for i=1:length(origins)
    idxOrigins{i} = findSampleIdx(dataEval.sMeta, origins{i});
end
% Calculate score
scoreSep = sepScoreRobust_norm(dataEval.I, idxOrigins);
disp(['Seperation score across tissues: ' num2str(scoreSep)]);
