[~,s,~] = pca(dataBatch.I');
figure(); scatter3(s(idxTissues{1},1),s(idxTissues{1},2),s(idxTissues{1},3),'filled')
hold on
scatter3(s(idxTissues{2},1),s(idxTissues{2},2),s(idxTissues{2},3),'filled')
scatter3(s(idxTissues{3},1),s(idxTissues{3},2),s(idxTissues{3},3),'filled')

figure(); scatter(s(idxTissues{1},1),s(idxTissues{1},2),'filled')
hold on
scatter(s(idxTissues{2},1),s(idxTissues{2},2),'filled')
scatter(s(idxTissues{3},1),s(idxTissues{3},2),'filled')
xlabel('PC1')
ylabel('PC2')
title('Tissue clustering after batch removal OOS-LDA(d=27)')
legend('b','p','s')

figure(); 
scatter(s(:,1),s(:,2))
hold on
scatter(s(idxOrigins{1},1),s(idxOrigins{1},2),'filled')
scatter(s(idxOrigins{2},1),s(idxOrigins{2},2),'filled')
scatter(s(idxOrigins{3},1),s(idxOrigins{3},2),'filled')
xlabel('PC1')
ylabel('PC2')
title('Species clustering after batch removal OOS-LDA(d=27)')
legend('All samples','41B','F3P51','GWT')