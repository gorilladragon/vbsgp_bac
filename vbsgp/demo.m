% delete('demo.txt');
% fid=fopen('demo.txt','a');
% myformat='%5d %5d %5d %5d\n';
% for i=1:4
%     fprintf(fid,'Cycle %d:\n',i);
%     fprintf(fid,myformat,magic(4));
%     fprintf('\n');
% end
% % fclose(fid);

% y=[10;2;36;4;15];
% x=1:5;
% plot(x,y)


% n=10000;
% A=randn(n,n);
% tic;
% B=A.*A;
% toc;
% pause(0.01);
% 
% C=zeros(n,n);
% tic;
% for i=1:n
%     for j=1:n
%         C(i,j)=A(i,j)*A(i,j);
%     end
% end
% toc;

figure('Name','Lower Bound and RMSE');
axis[]
hold on;


for x=1:1000
    y1=x^2;
    y2=2*x;
    subplot(2,1,1);
    plot(x,y1);
    
    subplot(2,1,2);
    plot(x,y2);
end

