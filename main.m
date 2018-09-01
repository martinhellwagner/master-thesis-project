%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%n%%%%%%%%%%%%%%%%%
%                                                  %
% MASTER'S THESIS                                  %
%                                                  %
% Student:    Martin Hellwagner                    %
% Supervisor: Prof. Stefan Weinzierl (TU Berlin)   %
% Advisor:    Prof. Anders Friberg (KTH Stockholm) %
%                                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% checking for classification parameter
prompt   = 'Which classification parameter do you want to run the program for (m = myoelastic, p = phonation, t = turbulent)? ';
decision = input(prompt,'s');
if (strcmp(decision,'m')) 
    parameter = 'myoelastic';
    fBase = 40;
elseif (strcmp(decision,'p'))
    parameter = 'phonation';
    fBase = 100;
elseif (strcmp(decision,'t'))
    parameter = 'turbulent';
    fBase = 0; % turbulent parameter exhibits no periodic frequency
end
fprintf('\n');
   
% loading audio files
fprintf('STEP 1: Loading audio files. \n \n');
paths = loadPaths('Files');
j = 1;

for i = 1:length(paths)
    [~,name,extension] = fileparts(paths{i});
    if (strcmp(extension,'.wav'))
        [y,fs] = audioread(paths{i});     
        files{j,1} = name;
        files{j,2} = y;
        files{j,3} = fs;
        j = j+1;
    end
end

% loading annotations
fprintf('STEP 2: Loading annotations. \n \n');
paths = loadPaths('Annotations');
j = 1;

for i = 1:length(paths)
    [~,name,extension] = fileparts(paths{i});
    nameParts = strsplit(name,'-');
    if (strcmp(nameParts{1},parameter) && strcmp(extension,'.txt'))
        annotations{j,1} = name;
        annotations{j,2} = loadAnnotations(paths{i});
        j = j+1;
    end
end

% potentially overwriting annotated audio fragments created earlier
execute = 0;
if (exist(['Fragments/' parameter],'dir'))
    prompt   = 'Do you want to overwrite the annotated audio fragments (y/n)? ';
    decision = input(prompt,'s');
    if (strcmp(decision,'y')) 
        rmdir(['Fragments/' parameter],'s');
        execute = 1;
    end
    fprintf('\n');
else
    execute = 1;
end

% creating annotated audio fragments
if (execute)
    fprintf('STEP 3: Creating annotated audio fragments. \n \n');
    for i = 1:length(annotations)
        test = createFragments('Fragments','.wav',files,annotations{i,1},annotations{i,2});
    end
else
    fprintf('STEP 3 skipped. \n \n');
end

% loading annotated audio fragments
fprintf('STEP 4: Loading annotated audio fragments. \n \n');
paths = loadPaths(['Fragments/' parameter]);
j = 1;
for i = 1:length(paths)
    [~,name,extension] = fileparts(paths{i});
    if (strcmp(extension,'.wav'))
    	[y,fs] = audioread(paths{i});
        partsPath = strsplit(paths{i},'/');
    	partsName = strsplit(partsPath{3},'_');
        fragments{j,1} = name; % name
        fragments{j,2} = y;    % file
        fragments{j,3} = fs;   % sampling rate
        fragments{j,4} = [partsPath{2} '-' partsName{2}]; % fragment parameter
        fragments{j,5} = partsName{3}; % gender and index of speaker
        j = j+1;
    end
end

% computing features for annotated audio fragmentsn
prompt = 'How much do you want to downsample the audio fragments (1 = no downsampling, 2 = Fs/2 etc.)? ';
factor = str2num(input(prompt,'s')); % downsampling factor (faster when bigger)
fprintf('\n');
    
fprintf('STEP 5: Computing features for annotated audio fragments. \n \n');    
fMin   = 20;   % minimum frequency in Hz
fMax   = 200;  % maximum frequency in Hz
hop    = 0.02; % hop size in seconds (faster when bigger)
block  = 0.04; % block size in seconds (faster when smaller)
    
j = 0;
for i = 1:length(fragments)
    parameter = strsplit(fragments{i,4},'-');
    minimumLength = ((hop*3+block)*fragments{i,3})+(fragments{i,3}/fMin); % files need to be longer than a certain length
    if (length(fragments{i,2}) > minimumLength)
        [data,names] = computeFeatures(fragments{i,2},fragments{i,5},factor,fragments{i,3},fBase,fMin,fMax,hop,block);
        j = j+1;
        featuresTemp(j,1:length(data)) = data;
        groundTruthTemp(j,1) = str2double(parameter{2});
    end
    if (mod(i,100) == 0)
        fprintf('Already processed %d of %d audio fragments.\n',i,length(fragments));
    end
end
fprintf('\n');

features.data     = cell2mat(featuresTemp);
features.names    = names;
groundTruth.data  = groundTruthTemp;
groundTruth.names = parameter{1};

% analysing features and classifying annotated audio fragments
fprintf('STEP 6: Analysing features and classifying annotated audio fragments. \n \n');
for i = 2:size(features.data,2)
    featuresSelected.data(:,i-1)  = features.data(:,i);
    featuresSelected.names(1,i-1) = features.names(1,i);
end
analyseFeatures(featuresSelected,groundTruth);
classifyFragments(featuresSelected,groundTruth,features.data(:,1));