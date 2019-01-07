clear all;close all;clc;

net = feedforwardnet([20],'traingdx');
% view(net);

load chp_wineclass.mat;
% ����һ��1-30���ڶ����60-95���������131-153��Ϊѵ����
train_wine = [wine(1:30,2:end);wine(60:95,2:end);wine(131:153,2:end)];
train_wine_labels = [wine(1:30,1);wine(60:95,1);wine(131:153,1)];
% ����һ��31-59���ڶ����96-130���������154-178��Ϊ���Լ�
test_wine = [wine(31:59,2:end);wine(96:130,2:end);wine(154:178,2:end)];
test_wine_labels = [wine(31:59,1);wine(96:130,1);wine(154:178,1)];

[t,r] = size(train_wine);
for i = 1:t
    if train_wine_labels(i,1) == 1
        train_labels(i,:) = [1;0;0];
    elseif train_wine_labels(i,1) == 2
        train_labels(i,:) = [0;1;0];
    else
        train_labels(i,:) = [0;0;1];
    end
end
%�Բ������ݼ���������������
[t1,r1] = size(test_wine);
for j = 1:t1
    if test_wine_labels(j,1) == 1
        test_labels(j,:) = [1;0;0];
    elseif test_wine_labels(j,1) == 2
        test_labels(j,:) = [0;1;0];
    else
        test_labels(j,:) = [0;0;1];
    end
end
% [train_data,ps] = mapminmax(train_wine',0,1); feedforwardnet�Զ���һ��

net.trainparam.show = 50 ;%ÿ���50����ʾһ��ѵ�����
net.trainparam.epochs = 1000 ;%�������ѵ������500��
net.trainparam.goal = 0.001 ;%ѵ��Ŀ����С���0.01
net.trainParam.lr = 0.01 ;%ѧϰ����0.05

net = train(net,train_wine',train_labels');

outputs = sim(net,test_wine');
% outputs = net(test_wine');
y = vec2ind(outputs);
out = test_wine_labels' - y;
rate = 1 - sum(out~=0)/t   %����out�в�Ϊ0��Ԫ�ظ���
find(out~=0)
% plotregression(test_labels',outputs,'Regression');% plotregression(t,y,'Regression')
