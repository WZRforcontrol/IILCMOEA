clc;clear;close all;
%% LCMOEA5测试
% CFx 系列:1,2,6很好; 4,9勉勉强强; 3,5,7,8,10不行
% DASCMOPx 系列: 1,2,3很好;  勉勉强强; 不行 4,5,6测试有bug
% DOCx 系列: 1很好;  勉勉强强; 2,3,4,5,6,7,8,9不行 
% LIRCMOPx 系列(原论文测试): 1,2很好;  勉勉强强;不行
platemo('problem',@LIRCMOP11,'algorithm',@LCMOEA,'N',100,'maxFE',100000)