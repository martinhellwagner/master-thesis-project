%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                  %
% MASTER'S THESIS                                  %
%                                                  %
% Student:    Martin Hellwagner                    %
% Supervisor: Prof. Stefan Weinzierl (TU Berlin)   %
% Advisor:    Prof. Anders Friberg (KTH Stockholm) %
%                                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function fragments = createFragments(folder,extension,files,name,annotations)
    % creating annotated audio fragments
    fragments = cell(length(annotations),3);
    for i = 1:length(annotations)
        for j = 1:length(files)
            if (strncmp(annotations{i,1},files{j,1},annotations{i,2}))
                fragments{i,1} = annotations{i,1};
                startTime = str2double(annotations{i,3})*(files{j,3}/1000);
                endTime   = str2double(annotations{i,4})*(files{j,3}/1000);
                fragments{i,2} = files{j,2}(startTime:endTime);
                fragments{i,3} = files{j,3};
            end
        end
    end
        
    % initializating values
    name = strsplit(name,'-');
    folder = [folder '/' name{1}];
    index = 0;
    if ~exist(folder,'dir')
        mkdir(folder);
    else
        fileList = dir([folder '/']);
        fileList = {fileList.name};
        lastFile = fileList(end);
        lastFile = strsplit(lastFile{1},'_');
        index = str2num(lastFile{1});
    end
                
    % saving annotated audio fragments
    j = 0;
    for i = 1:length(fragments)
        if (~isempty(fragments{i,1}))
           fileName = [num2str(i+index-j) '_' name{2} '_' fragments{i,1} extension];
           if ((i+index-j) < 10)
               fragments{i,1} = [folder '/000' fileName];
           elseif ((i+index-j) >= 10 && (i+index-j) < 100)
               fragments{i,1} = [folder '/00' fileName];
           elseif ((i+index-j) >= 100 && (i+index-j) < 1000)
               fragments{i,1} = [folder '/0' fileName];
           else
               fragments{i,1} = [folder '/' fileName];
           end
           audiowrite(fragments{i,1},fragments{i,2},fragments{i,3});
        else
            j = j+1;
        end
    end
end