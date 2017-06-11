function [] = dendrograms( I, idxClasses, name)
% idxClasses = cell with classes 

%Perform hierarchical clustring
D = pdist(I');
Z = linkage(D);

%Plot
figure()
[H, T, outperm] = dendrogram(Z, size(I,2)); %
title(['Dendrogram of ' name])
%Color according to class
numClasses = length(idxClasses);
col = distinguishable_colors(numClasses);
for k=1:numClasses
    class = unique(T(idxClasses{k}));
    Xdata = vec2mat([H.XData],4);
    for i=1:length(class)
        idx = find(outperm==class(i));
        [r, c] = find(Xdata==idx);
        for j=1:length(r)
            if(H(r(j)).YData(c(j))==0)
                hIdx = r(j);
                break
            end
        end        
        H(hIdx).Color = col(k,:);
        H(hIdx).LineWidth = 2;
    end
end

end
%