function [surprise]=BF_sur(string,epsilon,m,n)
% string=string';
surprise=zeros(size(string,1),1);
c=zeros(n);
surprise(1) = log(3)/log(2);
for i=2:size(string,1)
    p=(epsilon+c(string(i-1),string(i)))/(n*epsilon+sum(c(string(i-1),:)));
%     surprise(i)=1/(n*p);
%     gamma=m*surprise(i)/(1+m*surprise(i));
    % My change, it can change to -log(p)
    temp = 1/(n*p);
    surprise(i) = temp;
    gamma=m*temp/(1+m*temp);
%   This should deleted    
%     delta=zeros(n);
%     delta(string(i-1),string(i))=1;
    c(string(i-1),:)=(1-gamma)*c(string(i-1),:);
    c(string(i-1),string(i))=c(string(i-1),string(i))+1;
%     c = c + delta
end
    
