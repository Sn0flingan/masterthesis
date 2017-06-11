data = dataSplit;
I = data.I;

%Get index of classes to compare
idxC = findSampleIdx(dataBatch.sMeta, 'Control');
idxO = findSampleIdx(dataBatch.sMeta, 'Mebendazole');
%Make sure each class has more than 3 samples
if(or(length(idxC)<=3,length(idxO)<=3))
    warning(['Too small control or other samples, setting sepscore to nan'])
    scoreSep = nan;
else
    %Iterate score for stability
    for k=1:100
        % Balance classes with weights
        weights = getWeights(size(I,2), idxC, idxO);
        Ib = I*weights; %create balanced I
        % Set up class info
        classSize = size(weights,2)/2;
        idxClasses = {[1:classSize], [(classSize+1):classSize*2]};
        % Calculate score
        scoreSepPerm(k) = sepScoreRobust_norm(Ib, idxClasses);
    end
    scoreSep = mean(scoreSepPerm);
    stdScore = std(scoreSepPerm)
    disp(['Seperation score is ' num2str(scoreSep)]);
end