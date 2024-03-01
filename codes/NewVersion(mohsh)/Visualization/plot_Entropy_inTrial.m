function plot_Entropy_inTrial(T_std, T_target, title, savePath, configs, is_saving)

    time = (-configs.sig_len(1)+configs.interval/2)*1000:configs.step*1000:(configs.sig_len(2)-configs.interval/2)*1000;
    
    plot(time, T_target, 'linewidth', 2); hold on;
    plot(time, T_std, 'linewidth', 2);
    xline(0, '--', 'linewidth', 2)
    
    legend('Target', 'Standard', 'stimulus onset')
    xlabel('time')
    ylabel('Transfer Entropy')
            
    % Save the figure
    if is_saving
        saveas(gcf, fullfile(savePath, ...
               strcat('TransferEntropy_', title, '.png')));
    end
        
end