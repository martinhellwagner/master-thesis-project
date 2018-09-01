%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                  %
% MASTER'S THESIS                                  %
%                                                  %
% Student:    Martin Hellwagner                    %
% Supervisor: Prof. Stefan Weinzierl (TU Berlin)   %
% Advisor:    Prof. Anders Friberg (KTH Stockholm) %
%                                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function annotations = loadAnnotations(path)
    % reading text file into array
    i = 0;
    fileID = fopen(path);
    lineID = fgets(fileID);
    while ischar(lineID)
        if (i > 0)
            line = regexp(lineID,'\t','split');
            for j = 1:length(line)
                lines{i,j} = line{j};
            end
        end
        i = i+1;
        lineID = fgets(fileID);
    end
    fclose(fileID);

    % processing annotations from array
    annotations = cell(length(lines),3);
    for i = 1:length(lines)
        [~,path,~] = fileparts(lines{i,5});
        path = strsplit(path,'\');
        name = path{length(path)};
        size = length(path{length(path)});
        annotations{i,1} = name;       % name of annotation
        annotations{i,2} = size;       % length of annotation name
        annotations{i,3} = lines{i,3}; % start of annotation (in samples)
        annotations{i,4} = lines{i,4}; % end of annotation (in samples)
    end

    % removing duplicates from annotations
    [~,index] = unique(annotations(:,3));
    annotations = annotations(sort(index),:);
end