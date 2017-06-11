figure();
hold on;
plot(s_oss)
plot(s_pls)
plot(s_pca)
legend('OOS-DA','PLS-DA','PCA')
title('Parameter Optimization Grape')
xlabel('Dimensions')
ylabel('Seperation score')
hold off