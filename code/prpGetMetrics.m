function [Parameters]=prpGetMetrics(yfull,tfull)
    [mval,midx]=max(yfull);
    y=double(mval.*midx);
    [mval,midx]=max(tfull);
    t=double(mval.*midx);
    % get standard metrics
    BER=BalancedErrorRate(y,t);
    [TP,TN,FP,FN,TPR,FPR,ACC,SPC,PPV,NPV,FDR,MCC,F1S,PCP]=ConfMatVals(y, t);            
    
    %regression metrics are good for all
    [MAE,RMSE,NRMSE,SSE,STAT,RSTD,RMEA]=StatisticalAnl(y,t);
    Coefficien=[MAE,RMSE,NRMSE,SSE,STAT,RSTD,RMEA,TP,TN,FP,FN,TPR,FPR,ACC,SPC,PPV,NPV,FDR,MCC,F1S,BER];

    labels=[{'Mean Absolute Error, MAE'},{'Root Mean Squared Error, RMSE'},{'Normalized Root Mean Squared Error, NRMSE'},{'Sum of Squared Error, SSE'}, ...
    {'Absolute Error Mean + Error Std. Deviation, STAT'},{'Error Std. Deviation, RSTD'},{'Mean Error, RMEA'},{'True Positives Count, TP'}, ...
    {'True Negatives Count, TN'},{'False Positives Count ,FP'},{'False Negatives Count ,FN'},{'True Positives Rate ,TPR'},{'False Positives Rate, FPR'}, ...
    {'Accuracy, ACC'},{'Specificity, SPC'},{'Positive Predictive Value, PPV'},{'Negative Predictive Value, NPV'},{'False Discovery Rate, FDR'}, ...
    {'Matthews Correlation Coefficient, MCC'},{'F1-Score, F1S'},{'Balanced Error Rate, BER'}];

    Parameters=struct('Metrics',Coefficien,'Labels',{labels}, 'Per_Class_Precision', PCP');

    fprintf('-- Error metrics --\n');
    for k=1:length(Parameters.Metrics)
        fprintf([Parameters.Labels{k} ': ' num2str(Parameters.Metrics(k)) '\n']);
    end
    
    fprintf('-- Per Class Precision --\n');
    for k=1:length(Parameters.Per_Class_Precision)
        fprintf(['Class ' num2str(k) ': ' num2str(Parameters.Per_Class_Precision(k)) '\n']);
    end
    
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function BER=BalancedErrorRate(y, t)    
    if length(unique(t))==2
        y=sign(y); y(y==0)=1;
    else
        y(y<min(t))=min(t);
        y(y>max(t))=max(t); 
    end
    C=confusionmat(t,round(y));
    BER=zeros(length(C),1);
    for k=1:length(C)
        BER(k)=(sum(C(k,:))-C(k,k))/sum(C(k,:));
    end
    BER(isnan(BER))=0;
    BER=mean(BER);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [TP,TN,FP,FN,TPR,FPR,ACC,SPC,PPV,NPV,FDR,MCC,F1S,PCP]=ConfMatVals(y, t)    
    if length(unique(t))==2 
        y=sign(y); y(y==0)=1;
        C=confusionmat(t,round(y));
        TP=zeros(length(C)-1,1);
        TN=zeros(length(C)-1,1);
        FP=zeros(length(C)-1,1);
        FN=zeros(length(C)-1,1);    
        for k=1:length(C)-1
            TP(k)=C(k,k);
            FP(k)=sum(C(:,k))-C(k,k);
            TN(k)=sum(diag(C))-C(k,k);
            FN(k)=sum(C(:))-TP(k)-FP(k)-TN(k);
        end
    else
        y(y<min(t))=min(t);
        y(y>max(t))=max(t);         
        C=confusionmat(t,round(y));
        TP=zeros(length(C),1);
        TN=zeros(length(C),1);
        FP=zeros(length(C),1);
        FN=zeros(length(C),1);    
        for k=1:length(C)
            TP(k)=C(k,k);
            FP(k)=sum(C(:,k))-C(k,k);
            TN(k)=sum(diag(C))-C(k,k);
            FN(k)=sum(C(:))-TP(k)-FP(k)-TN(k);
        end
        TP=sum(TP);
        FP=sum(FP);
        TN=sum(TN);
        FN=sum(FN);
    end
    TPR=TP/(TP+FN);
    FPR=FP/(FP+TN);
    ACC=(TP+TN)/(TP+FN+FP+TN);
    SPC=TN/(FP+TN);
    PPV=TP/(TP+FP);
    NPV=TN/(TN+FN);
    FDR=FP/(FP+TP);
    MCC=((TP*TN)-(FP*FN))/sqrt((TP+FP)*(TP+FN)*(TN+FP)*(TN+FN));
    F1S=2*(((TP/(TP+FP))*(TP/(TP+FN)))/((TP/(TP+FP))+(TP/(TP+FN))));
    % compute the precision per class
    PCP = diag(C) ./ sum(C, 2);
end

function [MAE,RMSE,NRMSE,SSE,STAT,RSTD,RMEA]=StatisticalAnl(y,t)
    MAE=mean(abs(y-t));
    RMSE=sqrt(mean((y-t).^2));
    NRMSE=(1/std(t))*(sqrt(mean((y-t).^2)));
    SSE=sum((y-t).^2);
    STAT=std(y-t)+abs(mean(y-t));
    RSTD=std(y-t);
    RMEA=mean(y-t);
end