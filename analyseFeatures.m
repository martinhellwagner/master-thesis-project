%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                  %
% MASTER'S THESIS                                  %
%                                                  %
% Student:    Martin Hellwagner                    %
% Supervisor: Prof. Stefan Weinzierl (TU Berlin)   %
% Advisor:    Prof. Anders Friberg (KTH Stockholm) %
%                                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function analyseFeatures(features,groundTruth)
    % computing cross-correlation between features and ground truth
    fprintf('CROSS-CORRELATION \n');
    computeCrosscorrelation(features,groundTruth);
    fprintf('\n');
        
    % computing correlation for features
    fprintf('CORRELATION \n');
    computeCorrelation(features);
    fprintf('\n');
end