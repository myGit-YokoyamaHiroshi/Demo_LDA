
clear all
close all
clc

set(0,'defaultAxesFontSize',10);
set(0,'defaultAxesFontName','Arial');
set(0,'defaultTextFontSize',10);
set(0,'defaultTextFontName','Arial');
%%
cdir=cd;
addpath(genpath(cdir));
%%
load fisheriris
class_labels = {'setosa', 'versicolor'};
labels = ones(1, length(species));
for i = 1:length(species)
    if strcmp(species{i}, class_labels{1})
        labels(1,i) = 1;
    elseif strcmp(species{i}, class_labels{2})
        labels(1,i) = 2;
    else
        labels(1,i) = 3;
    end
end
%%
data1 = meas(labels==1,:).';
data2 = meas(labels==2,:).';

label1 = labels(labels==1);
label2 = labels(labels==2);
%%
f = figure;
scatter(data1(1,:), data1(2,:));
hold on;
scatter(data2(1,:), data2(2,:));
hold off;
legend(class_labels)
xlabel('Sepal length');
ylabel('Sepal width');
N = size(meas,1);
%%
Trinum = length(data1);
cross = 5;
index = crossvalidation( Trinum , cross);
%%
fig = figure(1);
figure_setting(60, 40, fig);
for rep=1:cross
    %% L model
    Xtr = [data1(1:2,index{rep}.train), data2(1:2,index{rep}.train)];
    Xts = [data1(1:2,index{rep}.test),  data2(1:2,index{rep}.test)];
    ctr = [label1(index{rep}.train), label2(index{rep}.train)];
    cts = [label1(index{rep}.test), label2(index{rep}.test)];
    
    %%%%%% model learning
    [tmp_w{rep}, tmp_c{rep}]=LDA(Xtr, ctr);
    
    y = tmp_w{rep}'*Xtr + tmp_c{rep};
    rslt=zeros(size(ctr));
    rslt(y>0)=1;
    rslt(y<0)=2;
    acc(1,rep)=1-sum(rslt~=ctr)./length(rslt);
    
    %%%%%% test 
    y = tmp_w{rep}'*Xts + tmp_c{rep};
    rslt=zeros(size(cts));
    rslt(y>0)=1;
    rslt(y<0)=2;
    
    disp(sum(rslt==cts)./length(rslt));
    acc(2,rep)=1-sum(rslt~=cts)./length(rslt);
	%%
    
    subplot(2,3, rep)
    plot(Xts(1,cts==1), Xts(2,cts==1),'bo')
    hold on
    plot(Xts(1,cts==2), Xts(2,cts==2),'ro')
    
    Xplt = [min(Xts(1,:))-1,  max(Xts(1,:))+1];
    Yplt = -tmp_w{rep}(1)/tmp_w{rep}(2) * Xplt -  tmp_c{rep}/tmp_w{rep}(2);
    plot(Xplt, Yplt, 'k')
    hold off
    
    title(['cv ', num2str(rep), ': test accuracy = ' num2str(acc(2,rep)*100), '%'])
    legend({'class 1', 'class 2', 'decision boundary'})
    
end
figure_save(fig, './figures/result')

