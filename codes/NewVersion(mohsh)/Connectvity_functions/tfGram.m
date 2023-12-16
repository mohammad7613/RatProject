function tfGram(PAC_mat,tint,fint,tstep,fstep)
    
    % This function plot the comodulogram
    %   INPUTS:
    %   PAC_mat   : PAC values for required frequency
    %   high      : High frequency range for plotting the comodulogram
    %   low       : Low frequency range for plotting the comodulogram

    % plot comodulogram
    figure; xticks = tint;
    pcolor(tint,[fint(1):fstep:fint(2)],PAC_mat'); shading(gca,'interp');
    colormap(jet);
    set(gca,'FontSize',10);
    xlabel('Time trial','FontSize',10);ylabel('Amplitude Frequency (Hz)','FontSize',10);
    set(gca,'FontName','Arial');
    set(gca,'XTick',xticks);

end