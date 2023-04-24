function syn_sig = generate_syn_signal(fp, fA, datalength, sampRate, SNR, PACstrength)
% Generate synthetic example of phase-amplitude coupled oscillations
%
% INPUTS:
%    - fp:                 Phase Frequency (in Hz)
%    - fA:                 Amplitude Frequency (in Hz)
%    - datalength:         Signal length (in seconds)
%    - sampRate:           Sampling rate (in Hz)
%    - SNR:                Signal to noise ration (dB)(default: 6 dB)
%    - PACstrength:        Strength of coupling [0-1] (default: 1)
%
% Author: Soheila Samiee, 2013
% Modified by Tamanna T. K. Munia, February 2019
% These scripts have been optimised for the Windows operating systm  
% MATLAB version used 2018a.

DutyCycle=0.5;
couplingPhase=90;

    % Default: coupling in peaks of nesting signal
    
    if (nargin < 5) || isempty(SNR)
        SNR = 6;
    end
    if (nargin < 6) || isempty(PACstrength)
        PACstrength = 1;
    end
    
    % Parameters
    chi = 1-PACstrength;
    methodT = 'nHan';%'Han';            % Type of adding nested signal to nested signal
    NestedAmp = 0.1;            % Amplitude of nested signal
    
    % Generate time vector
    if strcmp(methodT,'Han') && DutyCycle~=.5
        lag = fix(couplingPhase/360*sampRate);
    else
        lag = 0;
    end
    T = 1/sampRate;
    t = 0:T:datalength+lag*T;
    
    % ===== NOISE ======
    % Generating the noise
    [tmp,noise] = phase_noise(length(t),1,-1,100);       % applying 1/f distribution to noise
%     noise = randn(1,length(t));
    signal_power = (1/sqrt(2))^2;
    noise_power = (std(noise))^2;
    noiseLev = (signal_power/10^(SNR/10));  % SNR is in dB = 20 log S/N = 10 log P(S)/P(N)
    noise = .66* noiseLev/noise_power * noise + noiseLev/3 *randn(1,length(t));
    
    % ===== NESTING SIGNAL =====
    % Generating the nesting signal
    if (DutyCycle ~= 0.5)
        k = DutyCycle;
        T = 1/fp;
        b = (1-2*k^2)/(2*k*T*(1-k));
        a = (1-b*T)/T^2;
        ynesting = sin(2*pi*(a*mod(t,T)+b).*mod(t,T)-pi/2);
    else
        ynesting = sin(2*pi*fp*t - pi/2);
    end

    % ===== NESTED SIGNAL =====
    % Estimation of phase of nesting signal 
    if strcmp(methodT,'Han')
        
        [ymax,imax,ymin,imin] = extrema(ynesting);
        imax = imax(abs(ymax) > .95);
        imin = imin(abs(ymin) > .95);
        iZeros = find(diff([0 sign(ynesting)])==2 | diff([0 sign(ynesting)])==-2 | sign(ynesting)==0);
        if iZeros(end)==length(ynesting)
            iZeros = iZeros(1:end-1);
        end
        AscZeros = iZeros(ynesting(iZeros+1)-ynesting(iZeros) > 0);
        DescZeros = iZeros(ynesting(iZeros+1)-ynesting(iZeros) < 0);
        endpoints = AscZeros(AscZeros > 1) - 1;
        
        % Linear estimation of phase:
        % estimatedphase(imax) => 90
        % estimatedphase(imin) => 270
        % estimatedphase(AscZeros) => 0
        % estimatedphase(DescZeros) => 180
        % estimatedphase(endpoints) => 360
        estimatedphase = interp1(t([imax,imin,AscZeros,DescZeros,endpoints]), ...
            [repmat(90,1,length(imax)),repmat(270,1,length(imin)), ...
            repmat(0,1,length(AscZeros)),repmat(180,1,length(DescZeros)), ...
            repmat(360,1,length(endpoints))],t,'linear');
        
        % Generating the nested signal
        nested_duration = 1/(fp); % duration of nested bursts %%%%% can be changed
        tt = 0:1/sampRate:nested_duration;
        ll = fix(length(tt)/2);
        
        % Find the corresponding samples to "coupling phase"
        iphase = find(diff([0 sign(estimatedphase-couplingPhase)])==2 | sign(estimatedphase-couplingPhase)==0);
        iphase = iphase + round(rand(size(iphase))*sampRate/fA/4);  % shifting the peak of nested signal randomly
        
        baselineR = NestedAmp * 1/(1+strInd);    % baseline ratio of nested frequency
        mainR = NestedAmp * strInd/(1+strInd);
        ynested = baselineR * sin(2*pi*(fA*t + 3*pi/7));
        % Loop on each desired phase of nesting cycle
        for k = 1:length(iphase)
            % Time indices where to add the nested bursts
            idx = round(max([iphase(k)-ll+1, 1]):min([iphase(k)+ll, length(t)]));
            % Generate nested signal
            % FIRST METHOD: Hanning window
            % Use hanning window on nested signal, and not change the amplitude
            % of nesting signal with amplitude of nested signal as envelope. This
            % is important especially when we want to add nesting signal in
            % ascending or descending phase instead of peaks or troughs
            % NOTE: If we apply hanning window, usually the coupling power extends
            % in nested frequency if we estimate the PAC using PACestimate.
            ynestedMain = mainR * hann(length(idx))' .* sin(2*pi*(fA*t(idx) + 3*pi/7));
            % Adding: main + baseline
            ynested(idx) = ynested(idx) + ynestedMain;
        end
    else
        % SECOND METHOD: Nesting signal amplitude modulation
        % Use nesting signal amplitude instead of Hanning window to modulate
        % the amplitude of nested signal (Same as nestingnested function).
        % It can just be used for "coupling phase = 90"
        if DutyCycle == .5
            ynested = (NestedAmp*((1-chi)* sin(2*pi*fp*t - pi/2+couplingPhase/180*pi)+1+chi)/2).*sin(2*pi*fA*t);
        else
            ynesting2 = ynesting(lag+1:end);
            ynested = (NestedAmp*((1-chi)* ynesting2 +1+chi)/2).*sin(2*pi*fA*t(1:end-lag));
        end   
    end
    
    % ===== OUTPUT SIGNAL =====
    % Adding: nesting + nested + noise
    noise = noise(1:end-lag);
    ynesting = ynesting(1:end-lag);
    syn_sig = ynesting + ynested + noise;
    
end

function [xmax,imax,xmin,imin] = extrema(x)
    xmax = [];
    imax = [];
    xmin = [];
    imin = [];
    
    % Vector input?
    Nt = numel(x);
    if Nt ~= length(x)
        error('Entry must be a vector.')
    end
    
    % NaN's:
    inan = find(isnan(x));
    indx = 1:Nt;
    if ~isempty(inan)
        indx(inan) = [];
        x(inan) = [];
        Nt = length(x);
    end
    
    % Difference between subsequent elements:
    dx = diff(x);
    
    % Is an horizontal line?
    if ~any(dx)
        return
    end
    
    % Flat peaks? Put the middle element:
    a = find(dx~=0);              % Indexes where x changes
    lm = find(diff(a)~=1) + 1;    % Indexes where a do not changes
    d = a(lm) - a(lm-1);          % Number of elements in the flat peak
    a(lm) = a(lm) - floor(d/2);   % Save middle elements
    a(end+1) = Nt;
    
    % Peaks?
    xa  = x(a);             % Serie without flat peaks
    b = (diff(xa) > 0);     % 1  =>  positive slopes (minima begin)
    % 0  =>  negative slopes (maxima begin)
    xb  = diff(b);          % -1 =>  maxima indexes (but one)
    % +1 =>  minima indexes (but one)
    imax = find(xb == -1) + 1; % maxima indexes
    imin = find(xb == +1) + 1; % minima indexes
    imax = a(imax);
    imin = a(imin);
    
    nmaxi = length(imax);
    nmini = length(imin);
    
    % Maximum or minumim on a flat peak at the ends?
    if (nmaxi==0) && (nmini==0)
        if x(1) > x(Nt)
            xmax = x(1);
            imax = indx(1);
            xmin = x(Nt);
            imin = indx(Nt);
        elseif x(1) < x(Nt)
            xmax = x(Nt);
            imax = indx(Nt);
            xmin = x(1);
            imin = indx(1);
        end
        return
    end
    
    % Maximum or minumim at the ends?
    if (nmaxi==0)
        imax(1:2) = [1 Nt];
    elseif (nmini==0)
        imin(1:2) = [1 Nt];
    else
        if imax(1) < imin(1)
            imin(2:nmini+1) = imin;
            imin(1) = 1;
        else
            imax(2:nmaxi+1) = imax;
            imax(1) = 1;
        end
        if imax(end) > imin(end)
            imin(end+1) = Nt;
        else
            imax(end+1) = Nt;
        end
    end
    xmax = x(imax);
    xmin = x(imin);
    
    % NaN's:
    if ~isempty(inan)
        imax = indx(imax);
        imin = indx(imin);
    end
    
    % Same size as x:
    imax = reshape(imax,size(xmax));
    imin = reshape(imin,size(xmin));
    
    % Descending order:
    [temp,inmax] = sort(-xmax);
    xmax = xmax(inmax);
    imax = imax(inmax);
    [xmin,inmin] = sort(xmin);
    imin = imin(inmin);
end


% function [pn, theta] = phase_noise(num_samp, f0, dbc_per_hz, num_taps)
%
% This function creates noise with a 1/f spectrum. The noise is then
% phase modulated so that it can be mixed with a signal to simulate
% phase noise in the original signal. The noise is specified in power
% per hertz at frequency f0, relative to the power in the carrier.
%
% References:
% N. J. Kasdin, "Discrete Simulation of Colored Noise and Stochastic
% Processes and 1/f^a Power Law Noise Generation," _Proceedings of
% the IEEE_, May, 1995.
% Roger L. Freeman, _Reference Manual for Telecommunications
% Engineering_.
% M. Schroeder, _Fractals, Chaos, and Power Laws_.
%
% Input/Output parameters:
% num_samp desired number of output samples
% f0 reference frequency (must be in Hz.)
% dbc_per_hz power per hertz relative to carrier at ref. freq.
% num_taps number of filter taps in AR 1/f filter
% (optional; default = 100)
%
% pn phase-modulated 1/f process
% theta 1/f process (before phase modulation)
%
% Jeff Schenck 11/21/95
%
% 1/f noise is produced by passing white noise through a filter. The
% resulting spectrum has the form
%
% Sx(w) = g^2 / w, (pretend that w is an omega)
%
% where g is the gain applied to the white noise before filtering. If P
% is the desired power in the 1 Hz. band at w0 = 2pi*f0/fs, and W is the
% 1 Hz. bandwidth in radians, we can write
%
% Notice that the result is *independent* of fs!! Look at it this way:
% if the sampling rate is doubled for a given spectrum, the new w0 is
% half the old w0. For 1/f noise, this means that Sx(w0_new) =
% 2*Sx(w0_old). But a 1 Hz. band is half as large (in radians) than it
% was previously, so the product P is the same, and fs drops out of the
% picture.
%
% The independence with respect to fs is also an indication of the
% fractal nature of pink noise.
%
% Note that the phase-modulated noise is itself 1/f if the narrowband
% assumption is valid.
function [pn, theta] = phase_noise(num_samp, f0, dbc_per_hz, num_taps)

    % Check input.
    if dbc_per_hz >= 0
        error('Power per Hz. must be negative.');
    elseif f0 <= 0
        error('Reference frequency must be positive.');
    end
    if nargin < 4
        num_taps = 100;
    end

    % Generate white noise. Apply gain for desired dBc/Hz. Warn user
    % if gain is too large (gain thresholds have been chosen somewhat
    % arbitrarily -- needs work).
    gain = sqrt(2*pi * f0 * 10^(dbc_per_hz/10));
    wn = gain * randn(1,num_samp);

    % Generate 1/f AR filter and apply to white noise to produce 1/f
    % noise.
    a = zeros(1,num_taps);
    a(1) = 1;
    for ii = 2:num_taps
        a(ii) = (ii - 2.5) * a(ii-1) / (ii-1);
    end
    theta = filter(1,a,wn);

    % Phase modulate.
    pn = exp(i*theta);
end




