function [X_input, y_target] = prpGetData(subject)
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
end