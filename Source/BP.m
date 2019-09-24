
clc
clear
data=load ('source.mat');
HiddenNum=8; %number of hidden 
WholeError=0; %whole error of 100 times
MSE=0;
[row column]=size(data.source); %achieve input data dimension
row1=row-1;
row2=1;
column1=column-1;
column2=1;
InputNum=row1;   %number of input
OutputNum=row2;  %number of output
Data1=zeros(1,10);
Data2=zeros(1,10);
%uniformization 0.1 to 0.9

Input=(data.source-min(min(data.source)))/(max(max(data.source))-min(min(data.source)))*(0.9-0.1)+0.1
for time=1:10
             
TrainNum=row1;
TestNum=1;
%train data
TrainIn=Input(1:row1,1:column-1);
TrainOut=Input(row1+1,1:column-1);
%test data
TestIn=Input(1:row1,column);
TestOut=Input(row1+1,column);

%create a new forward neural network
net=newff(minmax(TrainIn),[HiddenNum,OutputNum],{'tansig','tansig'},'traingdm');
%input layer weights and threshold value
inputWeights=net.IW{1,1};
inputbias=net.b{1};
%hidden layer weights and threshold value
layerWeights=net.LW{2,1};
layerbias=net.b{2};

%setting parameters
net.trainParam.show = 500;
net.trainParam.lr = 0.05;
net.trainParam.mc = 0.9;
net.trainParam.epochs=2000;
net.trainParam.goal = 1e-5;

%train the network
net=train(net,TrainIn,TrainOut);

%simulation training
PreTestOut=sim(net,TestIn);
ErrorRate=abs(TestOut-PreTestOut)/TestOut;
TestActualOutput=(PreTestOut-0.1)*(max(max(data.source))-min(min(data.source)))/(0.9-0.1)+min(min(data.source));
WholeError=WholeError+ErrorRate;
MSE=MSE+(ErrorRate)^2;
Data1(1,time)=10;
Data2(1,time)=TestActualOutput;
end


AverageWholeError=WholeError/10   %calculate the average error of 10 times
WholeMSE=sqrt(MSE)/10
x1=1:10;
x2=1:10;
y1=Data1;
y2=Data2;
plot(x1,y1,'r-',x2,y2,'b-','linewidth',2)
xlabel('sample');      
ylabel('value');     
title('Error Result'); 
ylim([6 11])