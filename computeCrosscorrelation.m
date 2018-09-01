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

function computeCrosscorrelation(features,groundTruth)
    % computing cross-correlation coefficients between features and ground truth
    data  = [features.data groundTruth.data];
    size  = length(features.data(1,:));
    [R,P] = corrcoef(data,'rows','pairwise');
    
    % printing names
    fprintf('%17s',' ');
    fprintf('%-10s',groundTruth.names);
    fprintf('\n');

    % printing results (with stars for significance)
    for i = 1:size
        fprintf('%14s',features.names{i});
        n = 1;
        m = n+i;
        stars = '    ';
        if (P(n,m) <= 0.05)
            stars = ' *  ';
        end
        if (P(n,m) <= 0.01)
            stars = ' ** ';
        end
        if (P(n,m) <= 0.001)
            stars = ' ***';
        end
        fprintf('%7.2f %s',R(n,m),stars);
        fprintf('\n');
    end
end