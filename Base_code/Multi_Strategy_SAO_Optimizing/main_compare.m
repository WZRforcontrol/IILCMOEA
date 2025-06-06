%% introduce
% Author: Z.R.Wang
% Email: wangzhanran@stumail.ysu.edu.cn
% August,5,2024 in YSU
clc;clear;close all;
rng(100)
tic
% MyPar = parpool;
%% 模型超参数
% 搜索代理的数目 Number of search agents
SearchAgents_no=30;
% 最大迭代次数 Maximum number of iterations   
Max_iteration=1000;
% 维度(决策变量个数) Dimension,[2,10,30,50,100]
dim=10;
% 下界 lower boound
lb=-100;
% upper bound
ub=100;
%% cec2017原论文展示
% 目标函数 objective function
% Fun_name_len = [1,3,5,7,24,26];
% figure
% for j = 1:length(Fun_name_len)
%     %% 选择目标函数
%     disp(['function',num2str(Fun_name_len(j))]);
%     Function_name=Fun_name_len(j);
%     fobj = @(x) cec17_func(x',Function_name);
%     %% 多次优化，消除概率数据干扰
%     Max_test=10;
%     for i=1:Max_test
%         %% SAO优化
%         [Best_pos_SAO(i,:),Best_score_SAO(i),SAO_curve_SAO(i,:)]=SAO(SearchAgents_no,Max_iteration,lb,ub,dim,fobj);
%         %% DP-SAO优化
%         [Best_pos_MSAO(i,:),Best_score_MSAO(i),SAO_curve_MSAO(i,:)]=MSAO(SearchAgents_no,Max_iteration,lb,ub,dim,fobj);
%     end
%     %% 绘图
%     subplot(3,2,j)
%     semilogy(mean(SAO_curve_SAO), 'color', 'k', 'linewidth', 2.0)
%     hold on
%     semilogy(mean(SAO_curve_MSAO), 'color', 'r', 'linewidth', 2.0)
%     legend('SAO', 'MSAO')
%     f = ['Convergence curve of C2017_','{',num2str(Fun_name_len(j)),'}'];
%     title(f)
%     xlabel('Iteration')
%     ylabel('Fitness')
%     axis tight
%     grid off
%     box on
%     hold off
% end
%% cec2019测试
Fun_name_len = [1,2,3,4,7,8];
figure
for j = 1:length(Fun_name_len)
    %% 选择目标函数
    disp(['function',num2str(Fun_name_len(j))]);
    Function_name=Fun_name_len(j);
    fobj = @(x) cec19_func(x',Function_name);
    %% 多次优化，消除概率数据干扰
    Max_test=10;
    for i=1:Max_test
        %% SAO优化
        [Best_pos_SAO(i,:),Best_score_SAO(i),SAO_curve_SAO(i,:)]=SAO(SearchAgents_no,Max_iteration,lb,ub,dim,fobj);
        %% DP-SAO优化
        [Best_pos_MSAO(i,:),Best_score_MSAO(i),SAO_curve_MSAO(i,:)]=MSAO(SearchAgents_no,Max_iteration,lb,ub,dim,fobj);
    end
    %% 绘图
    subplot(3,2,j)
    semilogy(mean(SAO_curve_SAO), 'color', [189,178,255]/255, 'linewidth', 2.0)
    hold on
    semilogy(mean(SAO_curve_MSAO), 'color', [255, 99, 97]/255, 'linewidth', 2.0)
    legend('SAO', 'MSAO')
    f = ['Convergence curve of C2019_','{',num2str(Fun_name_len(j)),'}'];
    title(f)
    xlabel('Iteration')
    ylabel('Fitness')
    axis tight
    grid off
    box on
    hold off
end
% delete(MyPar)
toc
