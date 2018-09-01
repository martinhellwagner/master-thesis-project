%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                  %
% MASTER'S THESIS                                  %
%                                                  %
% Student:    Martin Hellwagner                    %
% Supervisor: Prof. Stefan Weinzierl (TU Berlin)   %
% Advisor:    Prof. Anders Friberg (KTH Stockholm) %
%                                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                  %       
% INPUT                                            %
% x........input wave form                         %
% factor...downsampling factor                     %
% fs.......sampling frequency in Hz                %
% fBase....expected base frequency in Hz           %
%                                                  %
% OUTPUT                                           %
% F....structure with features across frames       %
%                                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [F,autocorrelation] = computeFeaturesSkAT(x,factor,fs,fBase)
    % initializing values
    fMin  = 20;    % minimum frequency in Hz
    fMax  = 200;   % maximum frequency in Hz
    hop   = 0.01;  % hop size in seconds (faster when bigger)
    block = 0.02;  % block size in seconds (faster when smaller)

    % downsampling signal (if factor is specified)
    if (factor > 1)
        y  = resample(x,1,factor);
        fs = fs/factor;
    else
        y = x;
    end
    
    % computing autocorrelation matrix
    autocorrelation = computeAutocorrelation(y,fs,fMin,fMax,hop,block);

    % preparing feature arrays
    columns  = size(autocorrelation,2);
    cor_freq = zeros(1,columns);
    
    % computing peak matrices 
    for i = 1:columns
        [~,tau] = min(autocorrelation(2:end,i));
        cor_freq(1,i) = fs/tau; % frequencies of highest peaks
        autocorrelation(tau,i) = max(autocorrelation(:,i));
        [~,tau] = min(autocorrelation(round(fs/fMax):round(fs/fMin),i));
        cor_freq(2,i) = fs/tau; % frequencies of second highest peaks
    end
    
    % creating features
    cor_med1 = median(cor_freq(1,:));          % median of frequencies of highest peaks
    cor_mva1 = mean(abs(diff(cor_freq(1,:)))); % mean of absolute value of variation of frequencies of highest peaks
    cor_std1 = std(cor_freq(1,:));             % standard deviation of frequencies of highest peaks
    
    cor_med2 = median(cor_freq(2,:));          % median of frequencies of highest peaks
    cor_mva2 = mean(abs(diff(cor_freq(2,:)))); % mean of absolute value of variation of frequencies of highest peaks
    cor_std2 = std(cor_freq(2,:));             % standard deviation of frequencies of highest peaks
    
    cor_diff = abs(cor_med1-cor_med2);         % absolute value of difference between median of frequencies
    
    % computing Gaussian curve
    bandwidth = 30;
    x = (-bandwidth:bandwidth/30:bandwidth);
    gaussian = normpdf(x,0,bandwidth/3);
    maximumValue = max(gaussian);
    for i = 1:length(gaussian)
        gaussian(i) = gaussian(i)/maximumValue; % normalizing amplitudes of Gaussian curve
    end

    % computing amplitude of median of frequencies under Gaussian curve
    difference = abs(fBase-cor_med1);
    if (difference == 0)
        cor_gaus = 1;
    elseif (difference >= bandwidth)
        cor_gaus = 0;
    else
        cor_gaus = gaussian(bandwidth-round(difference));
    end
    
    % adding features to data structures   
    F.data  = [ cor_med1,  cor_mva1,  cor_std1,  cor_med2,  cor_mva2,  cor_std2,  cor_diff,  cor_gaus];
    F.names = {'cor_med1','cor_mva1','cor_std1','cor_med2','cor_mva2','cor_std2','cor_diff','cor_gaus'};
end