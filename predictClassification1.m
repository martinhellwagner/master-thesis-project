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

function [accuracyPLS,accuracySVM] = predictClassification1(features,groundTruth,components)
    % initializating values
    numberFragments  = length(groundTruth.data); % number of fragments
    numberFolds      = 10;                       % number of folds (for cross-validation)
    numberIterations = 100;                      % number of iterations
    samplesPerFold   = round(size(features.data,1)/numberFolds);

    numberCorrectPLS = 0; % number of correctly classified PLS fragments
    numberTotalPLS   = 0; % total number of PLS fragments
    numberCorrectSVM = 0; % number of correctly classified SVM fragments
    numberTotalSVM   = 0; % total number of SVM fragments

    % computing Z-score of data array
    zX = zscore(features.data);

    % running cross-validation
    for i = 1:numberIterations 
        p  = randperm(size(zX,1));
        pX = zX(p,:);
        pY = groundTruth.data(p,:);
        
        % selecting folds for training and validation
        for j = 1:numberFolds
            trainingIndices   = [1:((j-1)*samplesPerFold) (j*samplesPerFold+1):size(features.data,1)];
            validationIndices = (j-1)*samplesPerFold+1:j*samplesPerFold;
            
            if (j == numberFolds)
                if (validationIndices(end) < numberFragments)
                    validationIndices = [validationIndices,validationIndices(end):numberFragments];
                end
                if (validationIndices(end) > numberFragments)
                    lastIndex = find(validationIndices == numberFragments);
                    validationIndices = validationIndices(1:lastIndex);
                end
            end
            
            trainingX   = pX(trainingIndices,:);
            validationX = pX(validationIndices,:);
            trainingY   = pY(trainingIndices,:);
            validationY = pY(validationIndices,:);
            
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