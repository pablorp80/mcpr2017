function [X_input, y_target] = prpGetDataExp3(subject, outRate)
    % subject debe ser * para obtener todos los sujetos
    % subject debe ser S01 para el primer sujeto por ejemplo

    % carga los datos si ya existen
    dataFolder = '../dataset/';

    if strcmp(subject, '*')
        fileToLoad = strcat(dataFolder, 'all.mat');
    else
        fileToLoad = strcat(dataFolder, subject, '.mat');
    end
    if exist(fileToLoad, 'file') == 2
        load(fileToLoad, 'X_input', 'y_target');
    else

        filePattern = fullfile(dataFolder, strcat(subject, '*.jpeg')); 
        theFiles = dir(filePattern);
        l = length(theFiles);
        % Hay 31 targets (alfabeto en ingles mas numeros)
        y_target = zeros(31,l);
        X_input = cell(1,length(theFiles));

        for k = 1 : length(theFiles)
          baseFileName = theFiles(k).name;
          fullFileName = fullfile(dataFolder, baseFileName);
          fprintf(1, 'Loading %s\n', fullFileName);
          X_input{k} = im2double(imread(fullFileName));
          y_target(str2num(baseFileName(6:7)), k) = 1;

        end

        if strcmp(subject, '*')
          fileToSave = 'all.mat';
        else
          fileToSave = strcat(subject, '.mat');
        end
        save(fileToSave, 'X_input', 'y_target', '-v7.3');
    end
    
    muImg = zeros(size(X_input{1}));
    for k=1:length(X_input)    
        if mod(k,200)==0
            muImg = muImg + X_input{k};
            muImg = muImg./200;
            
            muDist = zeros(200, 1);
            for j=199:-1:0
                diff = abs(X_input{k-j}-muImg);
                if mod(k-j,200) == 0
                    muDist(200)=mean(diff(:));
                else
                    muDist(mod(k-j,200))=mean(diff(:));
                end
            end
            [sVal, sIdx] = sort(muDist);
            
            total = 0;
            while total < round(200 * outRate)
                if exist('idx', 'var')
                    idx = cat(1,idx,sIdx(total+1)+(k-200));
                    idx = cat(1,idx,sIdx(200-total)+(k-200));
                else
                    idx = sIdx(total+1);
                    idx = cat(1,idx, sIdx(200-total));
                end
                total=total+2;
            end
            muImg = zeros(size(X_input{1}));
        else
            muImg = muImg + X_input{k};
        end
    end
    idxTrain = idx;
    idxTest = setdiff(1:length(X_input),idx)';
    X_input = X_input(idxTrain);
    y_target = y_target(:,idxTrain);
end

