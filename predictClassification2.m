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

function [accuracyPLS,accuracySVM] = predictClassification2(features,groundTruth,components,speakerIndices)
    % initializating values
    numberSpeakers   = max(speakerIndices); % number of speakers (for cross-validation)
    numberIterations = 100;                 % number of iterations
    
    numberCorrectPLS = 0; % number of correctly classified PLS fragments
    numberTotalPLS   = 0; % total number of PLS fragments
    numberCorrectSVM = 0; % number of correctly classified SVM fragments
    numberTotalSVM   = 0; % total number of SVM fragments

    % computing Z-scores of data arrays
    zX = zscore(features.data);

    % running cross-validation
    for i = 1:numberIterations
        for j = 1:numberSpeakers
            trainingIndices = [];
            validationIndices = [];
            index1 = 1;
            index2 = 1;

            for k = 1:length(speakerIndices)
                if (speakerIndices(k) == j)
                    validationIndices(index1) = k;
                    index1 = index1+1;
                else
                    trainingIndices(index2) = k;
                    index2 = index2+1;
                end
            end
            
            trainingX   = zX(trainingIndices,:);
            validationX = zX(validationIndices,:);
            trainingY   = groundTruth.data(trainingIndices,:);
            validationY = groundTruth.data(validationIndices,:);
            
            % computing results for PLS
            [~,~,~,~,BETA,~,~,~] = plsregress(trainingX,trainingY,components);
            resultPLS            = [ones(size(validationX,1),1) validationX]*BETA;                   
            numberCorrectPLS     = numberCorrectPLS+sum(validationY == round(resultPLS));
            numberTotalPLS       = numberTotalPLS+length(validationY);

            % computing results for SVM
            model            = fitcsvm(trainingX,trainingY); % MATLAB's internal SVM classification is used because
            resultSVM        = predict(model,validationX);   % of the large overhead using the LIBSVM library
            numberCorrectSVM = numberCorrectSVM+sum(validationY == resultSVM);
            numberTotalSVM   = numberTotalSVM+length(validationY);
        end
    end
    
    % calculating overall accuracy of prediction
    accuracyPLS = numberCorrectPLS/numberTotalPLS;
    accuracySVM = numberCorrectSVM/numberTotalSVM;
end