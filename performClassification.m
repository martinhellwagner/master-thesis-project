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
% Based on the code by Prof. Anders Friberg        %
% Re-written and modified by Martin Hellwagner     %
%                                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [accuracy,result] = performClassification(features,groundTruth)
    % initializating values
    numberFeatures    = length(features.data(1,:)); % number of features
    numberFragments   = length(groundTruth.data);   % number of fragments

    % computing Z-scores of data arrays
    [zX,~,~]        = zscore(features.data);
    [zY,muY,sigmaY] = zscore(groundTruth.data);

    % running test regression
    [~,~,~,~,~,PCTVAR,~,~] = plsregress(zX,zY,numberFeatures);
    
    % computing ideal number of predictors
    cumulativeSum = cumsum(PCTVAR(2,:));
    for i = 1:numberFeatures
        temp(i) = 1-(1-cumulativeSum(i))*(numberFragments-1)/(numberFragments-i-1);
    end
    [~,numberPredictors] = max(temp);

    % computing results for PLS
    [~,~,~,~,BETA,~,~,~] = plsregress(zX,zY,numberPredictors+1);
    result   = ([ones(size(zX,1),1) zX]*BETA*sigmaY)+muY;
    accuracy = sum(groundTruth.data == round(result))/length(groundTruth.data);
end