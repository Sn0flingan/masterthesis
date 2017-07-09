function [MZ, I] = binMZnoRT(peaklst)
%mzBinMZ Bins ms rawdata file in m/z dimension
%   inputfile - given as string path, should be mzXML format
%   minMZ - lowest m/z value for a peak
%   maxMZ - highest m/z value for a peak
%   dMZ - the distance between two points in the graph. Should be smaller
%   than the thinnest expected true/biological peak.
%   threshold - threshold to filter out noise data.
%   MZ - output MZ vector
%   I - output matrix of intensities, with each row representing
%   corresponding row in MZ
%
%   Latest updated: 2016-11-16
%   bI: Nils Anlind

%Initalize parameters
minMZ = 0;
maxMZ = 1000;
dMZ = 0.05;
threshold = 100;

%Initalize variables
MZ = minMZ:dMZ:maxMZ; %Create common m/z grid
MZ = MZ';
N = length(MZ); %number of points
I = zeros(N,1); %prepare output matrix

%Store intensities into I
for time_t=1:length(peaklst)
    mz_spectra = cell2mat(peaklst(time_t)); %Extract spectra
    MZi = 1; %initalize first bin
    
    %for each peak p
    for peak_p=1:length(mz_spectra)
        peak = mz_spectra(peak_p,:); %extract peak
        mz = peak(1); %extract mz-value of peak
        i = peak(2); %extract I-value of peak
        
        %Remove data below threshold
        if(i<threshold)
            i = 0;
        end
       
        
        %Find right bin to put data
        if(mz<(minMZ-dMZ) || mz>(maxMZ+dMZ))    
                                                %Out of bounds
                                                %do nothing
        elseif(abs(mz-MZ(MZi))<(dMZ/2))       
                                                %this bin close enough
            I(MZi) = I(MZi) + i;  %Add in the new intensities
        else
                                               %Search for correct bin
            while(mz>(MZ(MZi)+(dMZ/2)) && MZi<N)   %while peak beyond bin
                MZi = MZi+1;                    %move to next bin
            end
            I(MZi) = I(MZi) + i;  %Add in the new intensities
        end
    end
end
end

