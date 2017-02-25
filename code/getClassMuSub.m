clear all; close all; clc;
subject = 'S04'

    % carga los datos si ya existen
    dataFolder = '../dataset/';

    fileToLoad = strcat(dataFolder, subject, '.mat');
    
    load(fileToLoad, 'X_input', 'y_target');
    
    filePattern = fullfile(dataFolder, strcat(subject, '*.jpeg')); 
    theFiles = dir(filePattern);
    
    muImg = zeros(size(X_input{1}));
    sign = 1;
    for k=1:length(X_input)
        if mod(k,200)==0
            fprintf(['sign ' num2str(sign) ': ']);
            sign=sign+1;
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
            
            bestIdx = sIdx(1)+(k-200);
            fprintf([num2str(bestIdx) ' -> ' theFiles(bestIdx).name '\n']);
            
            muImg = zeros(size(X_input{1}));
        else
            muImg = muImg + X_input{k};
        end
    end
    
