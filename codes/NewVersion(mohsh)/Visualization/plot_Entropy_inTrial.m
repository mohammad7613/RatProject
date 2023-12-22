function plot_Entropy_inTrial(T_std, T_target, sig_Labels, savePath, configs)

    time = -configs.sig_len(1)*1000:configs.step*1000:(configs.sig_len(2)-configs.interval)*1000;
    
    plot(time, T_std, 'linewidth', 2); hold on;
    plot(time, T_target, 'linewidth', 2);
    xline(0, '--', 'linewidth', 2)
    
    title(strcat('Transfer Entropy : ', sig_Labels(1), ' to ', ' ', sig_Labels(2)))
    legend('Standard', 'Target', 'stimulus onset')
    xlabel('time')
    ylabel('Transfer Entropy')
            
    % Save the figure
    saveas(gcf, fullfile(savePath, ...
           strcat('TransferEntropy_', sig_Labels(1), '_to_', sig_Labels(2), '.png')));

end