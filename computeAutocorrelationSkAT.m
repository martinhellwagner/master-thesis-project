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
% INPUT                                            %
% x.........input wave form                        %
% fs........sampling frequency in Hz               %
% fMin......minimum frequency in Hz                %
% fMax......maximum frequency in Hz                %
% hop.......hop size in seconds                    %
% block.....block size in seconds                  %
%                                                  %
% OUTPUT                                           %
% results...autocorrelation matrix                 %
%                                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function results = computeAutocorrelationSkAT(x,fs,fMin,fMax,hop,block)    
    % initializating values
    tauMin  = round(fs/fMax);  % minimum value of tau
    tauMax  = round(fs/fMin);  % maximum value of tau
    hop     = round(hop*fs);   % hop size in samples
    block   = round(block*fs); % block size in samples
    results = zeros(tauMax,ceil((length(x)-(block+tauMax))/hop));
    
    % computing auto-correlation matrix and performing normalization
    k = 0;
    for i = 1:hop:(length(x)-(block+tauMax))
        frame = x(i:i+(block+tauMax));
        k = k+1;
        tau = tauMin:tauMax;
        for j = 1:block
            results(tau,k) = results(tau,k)+(power(frame(j)-frame(j+tau),2));
        end
        
        temp = 0;
        results(1,k) = 1;
        for tau = 2:tauMax
            temp = temp+results(tau,k);
            results(tau,k) = results(tau,k)*(tau/temp);
        end
    end
end