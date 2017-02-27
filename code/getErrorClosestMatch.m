clear all; close all; clc;

file = 'S01_C04_0118';
subject = file(1:3);
class = str2num(file(6:7));
errcls = 6;

    % carga los datos si ya existen
    dataFolder = '../dataset/';

    fileToLoad = strcat(dataFolder, subject, '.mat');
    
    load(fileToLoad, 'X_input', 'y_target');
    
    filePattern = fullfile(dataFolder, strcat(subject, '*.jpeg')); 
    theFiles = dir(filePattern);

    load(['exp1-' subject '-deepnet.mat'], 'deepnet');
    
    inOut = deepnet(X_input{(1*class*200)-199+str2num(file(9:end))}(:));
    inImg = X_input{(1*class*200)-199+str2num(file(9:end))};

    bestErr = inf;
    bestSEr = inf;
    bestDiff = inf;
    bestMatchE = '';
    bestMatchSE = '';
    bestMatchD = '';
    
    sign = 1*errcls;
    muImg = zeros(size(X_input{1}));
    
    for k=(1*errcls*200)-199:1*errcls*200
        % theFiles(k).name
        out = deepnet(X_input{k}(:));
        
        if sum(abs(X_input{k}(:)-inImg(:))) < bestDiff
            bestDiff=sum(abs(X_input{k}(:)-inImg(:)))
            bestMatchD=theFiles(k).name
        end
        
        if sum(abs(out-inOut)) < bestErr
            bestErr=sum(abs(out-inOut))
            bestMatchE=theFiles(k).name
        end
        
        if mean((out-inOut).^2) < bestSEr
            bestSEr=mean((out-inOut).^2)
            bestMatchSE=theFiles(k).name
        end
    end
    