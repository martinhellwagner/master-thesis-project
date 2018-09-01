%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                  %
% MASTER'S THESIS                                  %
%                                                  %
% Student:    Martin Hellwagner                    %
% Supervisor: Prof. Stefan Weinzierl (TU Berlin)   %
% Advisor:    Prof. Anders Friberg (KTH Stockholm) %
%                                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function classifyFragments(features,groundTruth,speakerIndices)
    % selecting number of PLS components for each parameter
    if (strcmp(groundTruth.names,'myoelastic'))
        components1 = 5;
        components2 = 5;
    elseif (strcmp(groundTruth.names,'phonation'))
        components1 = 5;
        components2 = 10;
    elseif (strcmp(groundTruth.names,'turbulent'))
        components1 = 3;
        components2 = 3;
    end
    
    % predicting classification results using PLS regression and SVM and performing classification
    fprintf('CLASSIFICATION \n');
    [accuracyPLS1,accuracySVM1] = predictClassification1(features,groundTruth,components1);
    if (var(speakerIndices) ~= 0)
        [accuracyPLS2,accuracySVM2] = predictClassification2(features,groundTruth,components2,speakerIndices);
    end
    [accuracy,result] = performClassification(features,groundTruth);
    fprintf('\n');
    
    % printing classification results
    fprintf('PLS classification accuracy (10-fold cross-validation):       %.2f %% \n',accuracyPLS1*100);
    fprintf('SVM classification accuracy (10-fold cross-validation):       %.2f %% \n',accuracySVM1*100);
    fprintf('\n');
    if (var(speakerIndices) ~= 0)
        fprintf('PLS classification accuracy (leave-one-out cross-validation): %.2f %% \n',accuracyPLS2*100);
        fprintf('SVM classification accuracy (leave-one-out cross-validation): %.2f %% \n',accuracySVM2*100);
        fprintf('\n');
    end
    fprintf('PLS classification accuracy (no cross-validation):            %.2f %% \n',accuracy*100);
        
    % plotting classification results
    x = [0.5 0.5];
    y = [0 1];
    figure;
    plot(x,y,'r',result,groundTruth.data,'o');
    title(groundTruth.names);
    xlabel('Prediction');
    ylabel('Ground truth');
    fprintf('\n');
end