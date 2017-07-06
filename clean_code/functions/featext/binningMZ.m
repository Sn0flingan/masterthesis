function [MZ, I] = binningMZ(inputfile, resolution, minI)
%mzBinMZ Bins ms rawdata file in m/z dimension
%   Input variables:
%   inputfile(string) - given as string path, should be mzXML format
%   resolution(double) - resolution in MZ of the file
%   minI(double) - smallest acceptable intensity of a signal. Increase to reduce noise.
%   Output variables:
%   MZ - output MZ vector
%   I - output matrix of intensities, with each row representing
%   corresponding row in MZ
%
%   Latest updated: 2017-07-06
%   bI: Nils Anlind

# Load file into matlab
mzXMLstruc = mzxmlread(inputfile); #Load in inputfile into Matlab XML struct
[peaklst, rt] = mzxml2peaks(mzXMLstruc); #Extract peaklist and retention times

% Create bins into "MZ" vector, modify range if needed
minMZ = 0;
maxMZ = 1000;
MZ = minMZ:resolution:maxMZ; %Create common m/z grid
MZ = MZ';

% Create intensity vector for the bins
N = length(MZ); %number of bins
I = zeros(N,1); %prepare output vector

% Go through all signals and store in correct bin
%For all scans
for scanIdx=1:length(peaklst)
    spectra = cell2mat(peaklst(scanIdx)); %Extract spectra
    
    %for each signal in the specta
    for signalIdx=1:length(spectra)
        
        #Extract signal
        signal = spectra(signalIdx,:); %extract signal
        mz = signal(1); %extract mz-value of signal
        i = signal(2); %extract I-value of signal
        
       #Store in correct bin if over threshold
        if(i>minI)
            binIdx = round((mz-minMz)/resolution); %Find correct bin index
            if((binIdx>0) && (binIdx<=N+1))
            I(binIdx) = I(binIdx) + i; #add signal to that bin
        end
    end
end

end
