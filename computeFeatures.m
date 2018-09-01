%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                  %
% MASTER'S THESIS                                  %
%                                                  %
% Student:    Martin Hellwagner                    %
% Supervisor: Prof. Stefan Weinzierl (TU Berlin)   %
% Advisor:    Prof. Anders Friberg (KTH Stockholm) %
%                                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [data,names] = computeFeatures(x,speaker,factor,fs,fBase,fMin,fMax,hop,block)
    % specifying speaker indices
    if (strcmp(speaker,'F01'))
        speakerIndex = 1;
    elseif (strcmp(speaker,'F02'))
        speakerIndex = 2; 
    elseif (strcmp(speaker,'M01'))
        speakerIndex = 3; 
    elseif (strcmp(speaker,'M02'))
        speakerIndex = 4;
    end
    
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
    frames      = size(autocorrelation,2);
    frequencies = zeros(6,frames);
    amplitudes  = zeros(6,frames);
    
    % computing peak matrices
    for i = 1:frames
        data = autocorrelation(2:end,i);
        dataInverse = 1.01*max(data)-data;
        [~,tau1] = findpeaks(dataInverse);
        [~,tau2] = findpeaks(data);
        
        frequencies(3,i) = median(tau1);             % median of frequencies based on local minima
        frequencies(4,i) = mean(tau1);               % mean of frequencies based on local minima    
        frequencies(5,i) = median(tau2);             % median of frequencies based on local maxima
        frequencies(6,i) = mean(tau2);               % mean of frequencies based on local maxima
        
        amplitudes(3,i)  = median(data(tau1));       % median of amplitudes based on local minima
        amplitudes(4,i)  = mean(data(tau1));         % mean of amplitudes based on local minima
        amplitudes(5,i)  = median(data(tau2));       % median of amplitudes based on local maxima
        amplitudes(6,i)  = mean(data(tau2));         % mean of amplitudes based on local maxima
    
        [~,tau] = min(autocorrelation(2:end,i));
        frequencies(1,i) = fs/(tau+1);               % frequencies based on smallest value
        amplitudes(1,i)  = autocorrelation(tau+1,i); % amplitudes based on smallest value
        autocorrelation(tau+1,i) = max(autocorrelation(:,i));
        
        [~,tau] = min(autocorrelation(2:end,i));
        frequencies(2,i) = fs/(tau+1);               % frequencies based on second smallest value
        amplitudes(2,i)  = autocorrelation(tau+1,i); % amplitudes based on second smallest value
        autocorrelation(tau+1,i) = max(autocorrelation(:,i));
    end
            
    % computing statistical measures
    [medianF1,meanF1,meanDiffF1,varF1,iqrF1] = computeStatistics(frequencies(1,:));
    [medianF2,meanF2,meanDiffF2,varF2,iqrF2] = computeStatistics(frequencies(2,:));
    [medianF3,meanF3,meanDiffF3,varF3,iqrF3] = computeStatistics(frequencies(3,:));
    [medianF4,meanF4,meanDiffF4,varF4,iqrF4] = computeStatistics(frequencies(4,:));
    [medianF5,meanF5,meanDiffF5,varF5,iqrF5] = computeStatistics(frequencies(5,:));
    [medianF6,meanF6,meanDiffF6,varF6,iqrF6] = computeStatistics(frequencies(6,:));
    
    [medianA1,meanA1,meanDiffA1,varA1,iqrA1] = computeStatistics(amplitudes(1,:));
    [medianA2,meanA2,meanDiffA2,varA2,iqrA2] = computeStatistics(amplitudes(2,:));
    [medianA3,meanA3,meanDiffA3,varA3,iqrA3] = computeStatistics(amplitudes(3,:));
    [medianA4,meanA4,meanDiffA4,varA4,iqrA4] = computeStatistics(amplitudes(4,:));
    [medianA5,meanA5,meanDiffA5,varA5,iqrA5] = computeStatistics(amplitudes(5,:));
    [medianA6,meanA6,meanDiffA6,varA6,iqrA6] = computeStatistics(amplitudes(6,:));
    
    % computing Gaussian curve
    bandwidth = 30;
    x = (-bandwidth:bandwidth/30:bandwidth);
    curve = normpdf(x,0,bandwidth/3);
    maximumValue = max(curve);
    for i = 1:length(curve)
       curve(i) = curve(i)/maximumValue; % normalizing amplitudes of Gaussian curve
    end

    % computing amplitude of median of frequencies under Gaussian curve
    difference1 = abs(fBase-medianF1);
    if (round(difference1) == 0)
       gaussianF1 = 1;
    elseif (round(difference1) > bandwidth)
       gaussianF1 = 0;
    else
       gaussianF1 = curve(bandwidth-round(difference1)+1);
    end
    
    difference2 = abs(fBase-medianF2);
    if (round(difference2) == 0)
       gaussianF2 = 1;
    elseif (round(difference2) > bandwidth)
       gaussianF2 = 0;
    else
       gaussianF2 = curve(bandwidth-round(difference2)+1);
    end
    
    % preparing features
    data  = {speakerIndex,...
             medianF1,meanF1,meanDiffF1,varF1,iqrF1,...
             medianF2,meanF2,meanDiffF2,varF2,iqrF2,...
             medianF3,meanF3,meanDiffF3,varF3,iqrF3,...
             medianF4,meanF4,meanDiffF4,varF4,iqrF4,...        
             medianF5,meanF5,meanDiffF5,varF5,iqrF5,...
             medianF6,meanF6,meanDiffF6,varF6,iqrF6,...           
             medianA1,meanA1,meanDiffA1,varA1,iqrA1,...
             medianA2,meanA2,meanDiffA2,varA2,iqrA2,...
             medianA3,meanA3,meanDiffA3,varA3,iqrA3,...
             medianA4,meanA4,meanDiffA4,varA4,iqrA4,...           
             medianA5,meanA5,meanDiffA5,varA5,iqrA5,...
             medianA6,meanA6,meanDiffA6,varA6,iqrA6};
    names = {'speakerIndex',...
             'medianF1','meanF1','meanDiffF1','varF1','iqrF1',...
             'medianF2','meanF2','meanDiffF2','varF2','iqrF2',...
             'medianF3','meanF3','meanDiffF3','varF3','iqrF3',...
             'medianF4','meanF4','meanDiffF4','varF4','iqrF4',...           
             'medianF5','meanF5','meanDiffF5','varF5','iqrF5',...
             'medianF6','meanF6','meanDiffF6','varF6','iqrF6',...            
             'medianA1','meanA1','meanDiffA1','varA1','iqrA1',...
             'medianA2','meanA2','meanDiffA2','varA2','iqrA2',...
             'medianA3','meanA3','meanDiffA3','varA3','iqrA3',...
             'medianA4','meanA4','meanDiffA4','varA4','iqrA4',...           
             'medianA5','meanA5','meanDiffA5','varA5','iqrA5',...
             'medianA6','meanA6','meanDiffA6','varA6','iqrA6'};
    
    if (fBase > 0)
        data  = [data gaussianF1,gaussianF2];
        names = [names 'gaussianF1','gaussianF2'];
    end
         
    % resetting erroneously calculated values
    for i = 1:length(data)
        if (isnan(data{i}) || data{i} < 0)
            data{i} = 0;
        end
    end
end