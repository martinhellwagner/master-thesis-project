%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                  %
% MASTER'S THESIS                                  %
%                                                  %
% Student:    Martin Hellwagner                    %
% Supervisor: Prof. Stefan Weinzierl (TU Berlin)   %
% Advisor:    Prof. Anders Friberg (KTH Stockholm) %
%                                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function paths = loadPaths(folder)
    data = dir(folder);
    index = [data.isdir];
    paths = {data(~index).name}';
    if ~isempty(paths)
        paths = cellfun(@(x) fullfile(folder,x),paths,'UniformOutput',false);
    end
    
    subFolders = {data(index).name};
    validIndex = ~ismember(subFolders,{'.','..'});
    for subFolder = find(validIndex)
        nextFolder = fullfile(folder,subFolders{subFolder});
        paths = [paths; loadPaths(nextFolder)];
    end
end