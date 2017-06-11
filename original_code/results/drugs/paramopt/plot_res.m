%plot grapes

data = dataSplit;
I = data.I;

%PCA
[~,s,~] = pca(I');

%Plot batch effects
figure();
hold on
for i=1:length(idxBatches)
    scat(i) = scatter(s(idxBatches{i},1), s(idxBatches{i},2), 'filled');
    scat(i).MarkerFaceColor = scat(i).CData;
end
xlabel('PC1')
ylabel('PC2')
legend('B1','B2','B3', 'B4')
title('Batches clustering after batch removal OOS-DA')

%Plot species
figure();
hold on

t = scatter(s(:,1), s(:,2));
t.MarkerEdgeColor = t.CData;

scat2(1) = scatter(s(idxC,1), s(idxC,2), 'filled');
scat2(1).MarkerFaceColor = scat2(1).CData;

scat2(2) = scatter(s(idxO,1), s(idxO,2), 'filled');
scat2(2).MarkerFaceColor = scat2(2).CData;
xlabel('PC1')
ylabel('PC2')
legend('all samples', 'Control', 'Mebendazole')
title('Mebendazole clustering after batch removal OOS-DA')