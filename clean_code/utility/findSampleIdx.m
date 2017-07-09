function [ idx ] = findSampleIdx( sampleMeta, pattern )
%FINDSAMPLE Find idx of sample fufilling a certain pattern
%   Implemented by AA 2017

idxCell = strfind(sampleMeta{:,1}, pattern);
idx = find(not(cellfun('isempty',idxCell)));
end

