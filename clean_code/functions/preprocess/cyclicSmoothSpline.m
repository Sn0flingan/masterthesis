function [ I ] = cyclicSmoothSpline(I, minA, smoothingParam, dispFlag )
%CYCLICSMOOTHSPLINE Cyclic apply smoothing spline to rm technical variation
%   Detailed description:
%   Inspired by normalizeCyclicLoess in limma package for R. "Fast" 
%   algoritm is implemented as in Ballman et al 2004 but with smoothing 
%   spline instead of LOESS.
%   Algorithm:
%       1. Calculate mean of each feature
%       2. Select a reference sample (i)
%       3. For each other sample j:
%           a) Calculate M and A like in MA plots
%               i) A is (mean + I(sample))/2
%               ii) M is (mean-I(sample))
%           b) Fit a curve via smoothing spline to the MA plot. The curve
%              will become the new baseline
%           c) Correct M by extracting residuals.
%           d) Use the corrected M to restore I for sample
%   Input:
%       I(matrix) - Intensity values as doubles in matrix
%                   features as rows, samples as columns. Must have been
%                   logtransformed prior to sending in.
%       minA(double) - Threshold for minimum value of A to be used in for
%                      baseline correction. Typically around 10-15 for MS
%                      data. Check MA plot for one sample to determine size
%       smoothingParam - smoothing factor for smoothing spline. Lower value
%                        means more smoothing.
%       span(double) - Proportion of data to use in local regression of 
%                      spline 
%   Output:
%       I(matrix) - like input but with removed technical variation.
%
%   Implemented by NA 2017-03-06

cSS_tic = tic;
Ipre = I; %save original data for comparison

meanI = mean(I')'; %mean sample
%For each sample
for j=1:size(I,2)
    clear fit1 f
    A = meanI;
    idx = find(A>minA);
    %Avoid error by skipping if <2 points are to be used
    if(length(idx)<2)
        break
    end
    M =  I(:,j) - meanI;
    xdata = A(idx);
    ydata = M(idx);
    %prefit
    fit1 = fit(xdata, ydata, 'smoothingspline',...
        'SmoothingParam', smoothingParam);
    fdata = feval(fit1, xdata); %data points in fited curve
    residuals = fdata-ydata;
    ind = abs(residuals) > 1.5*std(residuals); %index without outliers
    outliers = excludedata(xdata, ydata, 'indices', ind); %outliers
    %true fit
    [f, ~, ~] = fit(xdata, ydata, 'smoothingspline',...
        'SmoothingParam', smoothingParam, 'exclude', outliers);
    yTrend = feval(f, xdata);
    I(idx,j) = I(idx,j) - yTrend; %correct data
    if(mod(j,10)==0 && dispFlag>1)
        disp(['Sample ' num2str(j) ' normalized of ' num2str(size(I,2))])
    end
end

cSS_toc = toc(cSS_tic);
%Display results
if(dispFlag>0)
    disp(['---'])
    disp(['Cyclic smoothing spline normalization completed.'])
    disp(['Elapsed time was: ' num2str(cSS_toc) ' s'])
    disp(['---'])
    if(dispFlag>1)
        maxLim = max(max([Ipre I]));
        minLim = min(min([Ipre I]));
        cLim = [minLim maxLim];
        figure();
        subplot(1,2,1)
        imagesc(Ipre, cLim)
        colorbar()
        title('Before normalization')
        subplot(1,2,2)
        imagesc(I, cLim)
        colorbar()
        title('After normalization')
        suptitle('Intensity matrix')
        figure();
        subplot(1,2,1)
        hold on
        for i=1:size(Ipre,2)
            histogram(Ipre(:,i))
        end
        hold off
        title('Before normalization')
        subplot(1,2,2)
        hold on
        for i=1:size(I,2)
            histogram(I(:,i))
        end
        hold off
        title('After normalization')
        suptitle('Distributions of intensities')
    end
end

end

