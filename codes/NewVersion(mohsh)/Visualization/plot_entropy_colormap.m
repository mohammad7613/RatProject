function plot_entropy_colormap(Entropy_table_target, Entropy_table_std, configs)

    deltaLag = 0.001;
    lags = (0:deltaLag:0.1) * 1000;
    figure; xticks = lags;
    time = -configs.sig_len(1)*1000:configs.step*1000:(configs.sig_len(2)-configs.interval)*1000;
    pcolor(lags,time,Entropy_table_target'); shading(gca,'interp');
    colormap(jet);
    yline(0, '--', 'linewidth', 2)
    set(gca,'FontSize',10);
    xlabel('Lag (ms)','FontSize',10);ylabel('Tine','FontSize',10);
    set(gca,'FontName','Arial');
    set(gca,'XTick',xticks);
    set(gca,'CLim',[0 2]);
    colorbar
    title('Target: mPFC to Hippo transfer entropy')

    figure;
    pcolor(lags,time,Entropy_table_std'); shading(gca,'interp');
    colormap(jet);
    yline(0, '--', 'linewidth', 2)
    set(gca,'FontSize',10);
    xlabel('Lag (ms)','FontSize',10);ylabel('Tine','FontSize',10);
    set(gca,'FontName','Arial');
    set(gca,'XTick',xticks);
    set(gca,'CLim',[0 2]);
    colorbar
    title('Standard: mPFC to Hippo transfer entropy')

end