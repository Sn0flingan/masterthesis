function [ peaklst_out ] = zeroPeakRemoval(peaklst )
%ZEROPEAKREMOVAL Remove 0 values in peaklist arrays
%   Input:
%       peaklst - a array of spectras with each spectra being a Nx2 matrix
%               with 1st col as MZ value and 2nd col being intensity.
%               Function looks for columns with 0 intensity and removes
%               them from the spectra. 
%   Output:
%       peaklst_out -  an array of spectras with no redundant values (0
%       intensity peaks)

for i=1:length(peaklst)
    spectra = peaklst{i}; %extract spectra
    [r,c] = find(spectra(2,:)>0); %find non-zero peaks
    peaklst_out{i} = spectra(r,2); %save only non-zero peaks
end

end

