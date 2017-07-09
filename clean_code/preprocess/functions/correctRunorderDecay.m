function [ Icor ] = correctRunorderDecay( I, runorder, dispFlag)
%CORRECTRUNORDERDECAY Corrects decay by runorder using smoothing splines
%   Algorithm:
%       1. for each feature:
%           a) get reference I for feature as median of 50% first values
%           b) fit a curve to intensity values/runorder using smoothing 
%              splines
%           c) set I corrected to reference I + residuals to curve
%   Input:
%       I(matrix) - samples as columns, features as rows. 
%       runorder   - runorder for each sample in I. Must match up with
%                    sample order of I.
%   Output:
%       Icor(matrix) - Intensity values corrected for runorder decay. Same
%                      order of samples as input. Samples as columns, 
%                      features as rows.
%   
%   Implemented by NA 2017-03-13

cRD_Tic = tic; %start clock

%Parameters
smoothingParam = 1e-6; %Potentially add this as a variable

numFeat = size(I,1);
numSamp = size(I,2);
for i=1:numFeat
    Icor(i,:) = I(i,:);
    clear fit1
    %First pre fit
    xdata = runorder;
    ydata = I(i,:)';
    idxNonZero = find(ydata>0);
    xdata = xdata(idxNonZero);
    ydata = ydata(idxNonZero);
    if(length(ydata)>2)
        fit1 = fit(xdata, ydata, 'smoothingspline','SmoothingParam', smoothingParam);
        %fit1 = fit(xdata, ydata, 'poly2');
        fdata = feval(fit1, xdata); %data points in fited curve
        residuals = fdata-ydata;
        idx = abs(residuals) > 1.5*std(residuals); %index without outliers
        outliers{i} = excludedata(xdata, ydata, 'indices', idx);
        %real fit
        if(length(ydata(~outliers{i}))>2)
            [f{i}, ~, out] = fit(xdata, ydata, 'smoothingspline',...
                'SmoothingParam', smoothingParam, 'exclude', outliers{i});
            %[f{i}, ~, out] = fit(xdata, ydata, 'poly2',...
            %    'exclude', outliers{i});
            ydata_ref = ydata(~outliers{i});
            Iref = mean(ydata_ref); %get middle 40-60% as ref
            ydata(~outliers{i}) = Iref + out.residuals; %correct non outliers
            ydata(outliers{i}) = ydata(outliers{i}) + Iref - feval(fit1, xdata(outliers{i})); %keep outlier values
            Icor(i,idxNonZero) = ydata;
        end
    end
    if(mod(i,100)==0 && dispFlag>1)
        disp(['Corrected feature ' num2str(i) 'out of ' num2str(numFeat)])
    end
end

cRD_Toc = toc(cRD_Tic);

if(dispFlag>0)
    Ichange = (I - Icor); %get difference
    disp(['---'])
    disp(['Correcting runorder decay completed'])
    disp(['Elapsed time was: ' num2str(cRD_Toc) 's'])
    disp(['---'])
    if(dispFlag>1)
        %Find features that changed the most
        [~,idxFeatMaxChange] = max(mean(abs(Ichange)')); %find feature with max mean change
        idxNonZero = find(I(idxFeatMaxChange,:)'>0);
        figure();
        hold on;
        plot(f{idxFeatMaxChange}, runorder,I(idxFeatMaxChange,:)','o')
        plot(runorder(idxNonZero(outliers{idxFeatMaxChange})),I(idxFeatMaxChange,idxNonZero(outliers{idxFeatMaxChange})),'o')
        legend('Original data', 'Trend runorder','outliers') %'Corrected data' 
        title(['Correction of feature ' num2str(idxFeatMaxChange)...
            'based on runorder']);
        hold off;
        figure();
        plot(runorder, sum(Ichange)/size(I,1),'o')
        xlabel('runorder')
        ylabel('average change')
        title('Changes in all samples')
        figure();
        subplot(1,2,1);
        plot(runorder,I(idxFeatMaxChange,:)','o')
        xlabel('runorder')
        ylabel('Corrected intensity(I)')
        title(['Before correction']);
        subplot(1,2,2);
        plot(runorder,Icor(idxFeatMaxChange,:)','o')
        xlabel('runorder')
        ylabel('Corrected intensity(I)')
        title(['After correction']);
        suptitle(['Correction of feature ' num2str(idxFeatMaxChange)]);
    end
end


end

