function plot_Entropy_diff(T_std_1, T_std_2, T_target_1, T_target_2, sig_Labels, savePath, configs, is_saving)

    time = (-configs.sig_len(1)+configs.interval/2)*1000:configs.step*1000:(configs.sig_len(2)-configs.interval/2)*1000;
    
    plot(time, T_target_2 - T_target_1, 'linewidth', 2); hold on;
    plot(time, T_std_2 - T_std_1, 'linewidth', 2);
    xline(0, '--', 'linewidth', 2)
    yline(0, '--', 'linewidth', 2)
    
    title(strcat('Transfer Entropy : ', sig_Labels(2), ' - ', ' ', sig_Labels(1)))
    xlabel('time')
    ylabel('Transfer Entropy')
    legend('Target', 'Standard')
            
    % Save the figure
    if is_saving
        saveas(gcf, fullfile(savePath, ...
               strcat('TransferEntropy_', sig_Labels(2), '_minus_', sig_Labels(1), '.png')));
    end

end