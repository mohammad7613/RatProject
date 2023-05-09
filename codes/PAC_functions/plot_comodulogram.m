function plot_comodulogram(PAC_mat,high,low)
% This function plot the comodulogram
%   INPUTS:
%   PAC_mat   : PAC values for required frequency
%   high      : High frequency range for plotting the comodulogram
%   low       : Low frequency range for plotting the comodulogram

%% plot comodulogram
figure; xticks = [low(1):1:low(2)]; yticks=[high(1):2:high(2)];
pcolor([low(1):1:low(2)],[high(1):2:high(2)],PAC_mat); shading(gca,'interp'); 
colormap(jet);
set(gca,'FontSize',10);
xlabel('Phase Frequency (Hz)','FontSize',10);ylabel('Amplitude Frequency (Hz)','FontSize',10);
set(gca,'FontName','Arial');
set(gca,'XTick',xticks);

end
