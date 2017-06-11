function [ weights ] = getWeights( numSamp, idxC, idxO )
%getWeights returns weights for I, to balance dataset idxC and idxO
%   Simulate replicates of the smaller class, by making linear combinations
%   of all other replicates
%   Assumptions:
%       idxC and idxO needs to contain atleast 2 samples each. Otherwise
%       no linear combination can be made.
%   Algorithm:
%       1. Find which class is smallest (need to simulate replicates)
%           (if they are equal, no simulated replicates are made)
%       2. Add identity matrix for all real replicates in the weights.
%       For smallest sample:
%       2. Sample X random numbers[0,1] (X=number of real replicates) with 
%       a sum of 1. Repeat N times, where N is the number of replicates
%       needed for a balanced dataset.
%       3. Add random distribution from 2 to the end of weights for one
%       class.
%   Input:
%       numSamp(int) - number of samples in I
%       idxC(list) - indicies for class C
%       idxO(list) - indicies for class O
%   Output:
%       weights(matrix) - weights matrix. Multiply with intensity matrix 
%                         to get balanced dataset.

%Check for valid inputs
if(2>length(idxC))
    error('idxC contains one or fewer samples, check second input argument')
elseif(2>length(idxO))
    error('idxO contains one or fewer samples, check third input argument')
end

%Calculate weights
numRepC = length(idxC);
numRepO = length(idxO);
diffRep = numRepO - numRepC;
if(diffRep==0)
    %Create C
    wC = zeros(numSamp, numRepC); %scaffold for weights for class C
    wC(idxC,:) = eye(numRepC); % add in replicates
    %Create O
    wO = zeros(numSamp, numRepO); %scaffold for weights for class C
    wO(idxO,:) = eye(numRepO); % add in replicates
elseif(diffRep>0)
    %more replicates in O than C
    %Create C
    wC = zeros(numSamp, numRepC+diffRep); %scaffold for weights for class C
    wC(idxC,1:numRepC) = eye(numRepC); % add in replicates
    seed = rand(diffRep,numRepC)';
    denom = repmat(sum(seed,1), [size(seed,1), 1]);
    weight = seed./denom; %generate weights for replicates
    wC(idxC,(numRepC+1):(numRepC+diffRep)) = weight;
    %Create O
    wO = zeros(numSamp, numRepO); %scaffold for weights for class C
    wO(idxO,:) = eye(numRepO); % add in replicates
elseif(diffRep<0)
    %less replicates in O than C
    %Create C
    wC = zeros(numSamp, numRepC); %scaffold for weights for class C
    wC(idxC,:) = eye(numRepC); % add in replicates
    %Create O
    wO = zeros(numSamp, numRepO-diffRep); %scaffold for weights for class C
    wO(idxO,1:numRepO) = eye(numRepO); % add in replicates
    seed = rand(-diffRep,numRepO)';
    denom = repmat(sum(seed,1), [size(seed,1), 1]);
    weight = seed./denom; %generate weights for replicates
    wO(idxO,(numRepO+1):(numRepO-diffRep)) = weight;
end
weights = [wC wO];


end

