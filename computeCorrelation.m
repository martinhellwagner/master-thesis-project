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

function computeCorrelation(features)
    % computing correlation coefficients for features
    [R,P] = corrcoef(features.data,'rows','pairwise');
    
    % printing names
    fprintf('%17s',' ');
    for i = 1:length(R(1,:))-1
        fprintf('%-12s',features.names{i});
    end
    fprintf('\n');
    
    % printing results (with stars for significance)
    for i = 2:length(R(:,1))
        fprintf('%14s',features.names{i});
        for j = 1:i-1
            stars = '    ';
            if (P(i,j) <= 0.05)
                stars = ' *  ';
            end
            if (P(i,j) <= 0.01)
                stars = ' ** ';
            end
            if (P(i,j) <= 0.001)
                stars = ' ***';
            end
            fprintf('%7.2f %s',R(i,j),stars);
        end
        fprintf('\n');
    end
end