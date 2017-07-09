function [ dataOut ] = removeIdx(data, idx, type, dispFlag)
%REMOVEIDX Remove idx from the data
%   Input
%       data(struct) - data with I, sMeta and fMeta
%       idx(list)   - list of indecies(integers) that are to be removed
%       type(string) - specifies if it is idx of feature or sample that 
%               should be removed
%   Ouput
%       dataOut(struct) - data with the specified indicies removed
%
%   Implemented by NA 2017-03-05

rI_tic = tic;

%Extract data into local variables
I = data.I;
sMeta = data.sMeta;
fMeta = data.fMeta;

%Check if feature or sample
if(strcmp(type,'feature'))
    %Extract features to keep (both fMeta and I)
    numFeat = size(I,1);
    idxKeep = setdiff(1:numFeat, idx);
    if(not(isempty(idxKeep)))
        fMeta = fMeta(idxKeep,:);
        I = I(idxKeep,:);
    else
        warning(['No features are keept. Keeping all features instead.'])
    end
    msg = 'temp'; %Removed ' num2str(length(idx)) ' features
elseif(strcmp(type,'sample'))
    msg = 'Removed sample: ';
    for i=1:length(idx)
        msg = [msg '\n' data.sMeta.name(idx(i))];
    end
    %Extract samples to keep (both sMeta and I)
    numSamp = size(I,2);
    idxKeep = setdiff(1:numSamp, idx);
    if(not(isempty(idxKeep)))
        sMeta = sMeta(idxKeep,:);
        I = I(:,idxKeep);
    else
        warning(['No samples are keept. Keeping all samples instead.'])
    end
else
    error('Incorrect format of "type" argument.')
end
%Omitt new data to output variables
dataOut = struct('I', I, 'sMeta', sMeta, 'fMeta', fMeta);

rI_toc = toc(rI_tic);
if(dispFlag>0)
    disp(['---'])
    disp(['Finnished removing ' type])
    disp(['Elapsed time was %0.3f secs\n', rI_toc'])
    disp(msg)
    disp(['---'])
end
end

