%plot grapes

data = dataBatch;
I = data.I;

%PCA
[~,s,~] = pca(I');

%Plot batch effects
figure();
hold on
for i=1:length(idxTissues)
    scat(i) = scatter(s(idxTissues{i},1), s(idxTissues{i},2), 'filled');
    scat(i).MarkerFaceColor = scat(i).CData;
end
xlabel('PC1')
ylabel('PC2')
legend('b','p','s')
title('Tissue clustering after batch removal Combat')

%Plot species
figure();
hold on
t = scatter(s(:,1), s(:,2));
t.MarkerEdgeColor = t.CData;
for i=1:3
    scat2(i) = scatter(s(idxOrigins{i},1), s(idxOrigins{i},2), 'filled');
    scat2(i).MarkerFaceColor = scat2(i).CData;
end
xlabel('PC1')
ylabel('PC2')
legend('all samples', '41B', 'F3P51', 'GWT')
title('Species clustering after batch removal Combat')