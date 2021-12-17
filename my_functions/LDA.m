function [w,c, Sw, S1, S2, X1, X2]=LDA(Xtr,clabel)
    mv_est(:,1)=mean(Xtr(:,clabel==1)')';
    mv_est(:,2)=mean(Xtr(:,clabel==2)')';
    
    X1=bsxfun(@minus, Xtr(:,clabel==1), mv_est(:,1));
    S1=X1*X1';
    
    X2=bsxfun(@minus, Xtr(:,clabel==2), mv_est(:,2));
    S2=X2*X2';
    
    Sw=(S1+S2);
    invSw=inv(Sw);
    w=invSw*(mv_est(:,1)-mv_est(:,2));
    
    tmp1=mv_est(:,1)'*invSw*mv_est(:,1)-mv_est(:,2)'*invSw*mv_est(:,2);
    tmp2=log(length(clabel(clabel==1))/length(clabel(clabel==2)));
    c=-1/2*tmp1+tmp2;
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % オーム社 統計的機械学習 生成モデルに基づくパターン認識 pp.61-62 参照  %
    %    w = inv(Sw) * (m1 - m2)                                        %
    %    c = - 1/2 * (m1*Sw*m1' - m2*Sw*m2') + log(n1/n2)               %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end