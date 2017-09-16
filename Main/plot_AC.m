%% import text file
data = importdata('mountain_car VAC - reward10minus2 percent10.txt');
data = horzcat(data, importdata('mountain_car VAC - reward10minus2 percent30.txt'));
% data = horzcat(data, importdata('mountain_car VAC - reward5 percent40.txt'));
data = horzcat(data, importdata('mountain_car BAC - reward10minus2.txt'));


%%%%%%%%%%%%%%%% 1.Process the raw results into row vectors %%%%%%%%%%%%%%%
x = data(:, 1)'; %  x axis
y = data(:, 2:2:6)';
% y = y./1000;

%%
%%%%%%%%%%%%%%%% 2. initialize a figure structure %%%%%%%%%%%%%%%%%%%%%%%%%
xl='Number of Episodes'; % 1. xlabel
yl='Avg. Number of Steps to Goal'; % 2. ylabel
% 3. legend the number of strings should be the 
%   same as the number of curves in yl
legend={'VAC $10\%$', 'VAC $30\%$', 'BAC'}; %  '$40\%$',
% legend={'$10\%$', 'BAC'}; 

% 4. marker is a string of three fields including
%   i)    line style (i.e., solid line '-', dash line '--')
%   ii)   color (i.e., 'm','r','g','b','k','y')
%   iii)  marker style (i.e., 'o','v','^','s','x',',')
% use doc plot in Matlab for more information
marker={'-r', '-b', '--k'};  %  '-g',
% marker={'-b', '--m'}; 

c=mFig(x,y,xl,yl,marker,legend);

%%
%%%%%%%%%%%%%%% 2.5 Adjust legend/range %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Position of the legend: 'North', 'South', 'West', 'East', 'NorthWest' ...
%c.lpos='NorthWest'; 
%c.ttl='No title'; % title
%c.xlm=[0,6]; % range of plotted x 
%c.ylm=[0,8]; % range of plotted y 
%c.xtk=[0,2,4,6]; % ticks of x axis
%c.ytk=[0,2,4,6,8]; % ticks of y axis

%%%%%%%%%%%%%% 3. plot/replot the figure %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Plot the curve: plot/logx/logy/logxy/bar
% mPlot('plot',c,'file');
% if the last argument is set empty, the figure is output to screen
mPlot('plot',c,'');


%%
% import
data = importdata('perf_BAC_mountain_car_100trials.txt');

meanX = data(:, 1)';
stdDevX = data(:, 2)';
Y = [1:10:500, 1];


% figure(1)
% errorbar(Y,meanX, stdDevX)