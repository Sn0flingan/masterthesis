function [ Ilog ] = logIntensities( I, dispFlag )
%LOGINTENSITIES Transform intensities by natural logarithm
%   Input:
%       I(matrix) - Intensities
%       dispFlag(int) - Show how much to display
%                           0 - output no information
%                           1 - output short summary
%   Output:
%       Ilog(matrix) - Intensities log transformed.
%   
%   Implemented by AA 2017-04-10

tic_li = tic;

I(I<=0) = 1; %set all values of 0 to 1 to avoid nan 
Ilog = log(I);

toc_li = toc(tic_li);

if(dispFlag>0)
    disp(['---'])
    disp(['Log transformation of data completed'])
    disp(['Elapsed time was: ' num2str(toc_li) 's'])
    disp(['---'])
end

end

