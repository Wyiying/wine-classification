clear all;close all;clc;
% load data
% 178*14�����ݷ�Ϊ���࣬��һ��Ϊ����Դ�����13�зֱ�Ϊ��
%  	1) Alcohol
%  	2) Malic acid
%  	3) Ash
% 	4) Alcalinity of ash
%  	5) Magnesium
% 	6) Total phenols
%  	7) Flavanoids
%  	8) Nonflavanoid phenols
%  	9) Proanthocyanins
% 	10)Color intensity
%  	11)Hue
%  	12)OD280/OD315 of diluted wines
%  	13)Proline
%  ÿ������������Ŀ��
%   class 1 59 (1-59)
% 	class 2 71 (60-130)
% 	class 3 48  (131-178)
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

%% normalize
[train_data,ps] = mapminmax(train_wine',0,1);
[test_data,ps1] = mapminmax(test_wine',0,1);

%% ����RBF����
net = newrb(train_data,train_labels',0.001,0.8);
% net = newrbe(train_data,train_labels');
y = sim(net,test_data);

tr = vec2ind(sim(net,train_data));

%% ����������
% vec2ind������������������ֵ����λ�ã�����M*N���󣬷���һ��1*N�ľ���ÿһ�б�ʾM��Ԫ�������ֵ�����ڵ��к�
test_ind = vec2ind(test_labels');
yc = vec2ind(y);
count = 0;
for j = 1:length(test_ind)
    if test_ind(j)==yc(j)
        count = count+1;
    end
end

err = count/length(test_ind)

find(test_ind~=yc)
