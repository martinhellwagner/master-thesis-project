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

function results = computeAutocorrelation(y,fs,fMin,fMax,hop,block)
    % initializating values
    tauMin  = round(fs/fMax);  % minimum value of tau
    tauMax  = round(fs/fMin);  % maximum value of tau
    hop     = round(hop*fs);   % hop size in samples
    block   = round(block*fs); % block size in samples
    results = zeros(tauMax,ceil((length(y)-(block+tauMax))/hop));
    
    % computing auto-correlation matrix and performing normalization
    k = 0;
    for i = 1:hop:(length(y)-(block+tauMax))
        window = y(i:i+(block+tauMax));
        k = k+1;
        for j = 1:block
            for tau = tauMin:tauMax;
                results(tau,k) = results(tau,k)+(power(window(j)-window(j+tau),2));
            end
        end
        
        temp = 0;
        results(1,k) = 1;
        for tau = 2:tauMax
            temp = temp+results(tau,k);
            results(tau,k) = results(tau,k)*(tau/temp);
        end
    end
end