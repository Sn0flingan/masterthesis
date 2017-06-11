maxLim = max([max(max(s_b_oss)) max(max(s_b_pls)) max(max(s_b_pca))]);
minLim = min([min(min(s_b_oss)) min(min(s_b_pls)) min(min(s_b_pca))]);

hfig = figure(); 
hAxis(1) = subplot(1,3,1);
imagesc(s_b_pca); 
caxis([minLim, maxLim])
colorbar()
title('PCA')
xlabel('dbatch')
ylabel('dsplit')

hAxis(2) = subplot(1,3,2);
imagesc(s_b_pls);
caxis([minLim, maxLim])
colorbar()
title('PLS-DA')
xlabel('dbatch')
ylabel('dsplit')

hAxis(3) = subplot(1,3,3);
imagesc(s_b_oss); 
caxis([minLim, maxLim])
colorbar()
title('OOS-DA')
xlabel('dbatch')
ylabel('dsplit')

for i=1:3
    pos = get( hAxis(i), 'Position' );
    pos(3) = 0.15;
    if(i==1)
        pos(1) = pos(1) - 0.05;
    elseif(i==3)
        pos(1) = pos(1)+0.05;
    end
    set( hAxis(i), 'Position', pos ) ;
end


suptitle('Binned score')