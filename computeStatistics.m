%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                  %
% MASTER'S THESIS                                  %
%                                                  %
% Student:    Martin Hellwagner                    %
% Supervisor: Prof. Stefan Weinzierl (TU Berlin)   %
% Advisor:    Prof. Anders Friberg (KTH Stockholm) %
%                                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [medianX,meanX,meanDiffX,varX,iqrY] = computeStatistics(x)
    % initializing values
    y = sort(x);
    
    % computing basic statistical measures
    medianX   = median(x);          % median
    meanX     = mean(x);            % mean
    meanDiffX = mean(abs(diff(x))); % mean of the absolute value of variation
    varX      = var(x);             % variance
    
    % computing advanced statistical measures
    Q1Y = median(y(find(y<median(y)))); % first quartile
    Q3Y = median(y(find(y>median(y)))); % third quartile
    iqrY = Q3Y-Q1Y;                     % interquartile range
end