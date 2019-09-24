clc
clear
data=load ('sourcepcnp.mat');
HiddenNum=3; %number of hidden 
Overlap=1.0;  %overlap coefficient
WholeError=0; %whole error of 100 times
MSE=0;
[row column]=size(data.sourcepcnp); %achieve input data dimension
row1=row-1;
row2=1;
column1=column;
column2=column;
InputNum=row1;  %number of input
OutputNum=row2; %number of output
Data1=zeros(1,100);
Data2=zeros(1,100);
%uniformization 0.1 to 0.9
%Input=(data.source-min(min(data.source)))/(max(max(data.source))-min(min(data.source)))*(0.9-0.1)+0.1
Input=data.sourcepcnp;
for time=1:100             
TrainNum=row1;
TestNum=1;
%train data
TrainIn=Input(1:row1,1:column-1)';
TrainOut=Input(1:row1,column)';
%test data
TestIn=Input(row1+1,1:column-1)';
TestOut=Input(row1+1,column)';

%initialization center 
Nonrepeat=unique(TrainIn','rows')'; %delet repeat column1
[r c]=size(Nonrepeat);              %select centers form training data randomly
Sequence2=1:c;
RandomSequence2=randperm(c);
CentersSequence=Sequence2(RandomSequence2(1:HiddenNum));
Centers=Nonrepeat(:,CentersSequence);


%iteration to calculate the center
while 1
    Index1=zeros(HiddenNum,1);       %Initialization index
    Index2=zeros(HiddenNum,TrainNum);%Initialization index
 
    for i=1:TrainNum
        Distance=dist(Centers',TrainIn(:,i)); %calculate every train data to the center of distance
        [MinDistance,p]=min(Distance);        %select minimum distance
        Index1(p)=Index1(p)+1;                %record the address of minimum distance
        Index2(p,Index1(p))=i;                %record the sequence number of train data
    end
    
    OriginalCenters=Centers;                  %save original center
    
    %according to the center clustering to get new mean of data in cluster 
    for i=1:HiddenNum
        Index=Index2(i,1:Index1(i));
        Centers(:,i)=mean(TrainIn(:,Index),2);
    end
 
    if isequal(OriginalCenters,Centers)~=0; %if no change, finish the iteration
        break                               
    end
end
    
%calculate the spread constant
CenterDistance=dist(Centers',Centers); %calculate the distance of each centers
Maximun=max(max(CenterDistance));      %select the maximum distence
for i=1:HiddenNum
   CenterDistance(i,i)=Maximun+1;      %replace the diagonal of zero
end

Spread=Overlap*min(CenterDistance)';   %with the minimum distance as spread

%Train: calculate the weight and bias by least square method
TrainDistance=dist(Centers',TrainIn);                       %calculate the distance of train data
TrainSpreadMat=repmat(Spread,1,TrainNum);                   %remat the spread
TrainHiddenOut=exp(-(TrainDistance./(TrainSpreadMat)).^2);  %calculate the train output of hidden layer by Gaussian
TrainHiddenOutBias=[TrainHiddenOut' ones(TrainNum,1)]';     %consider the deviation
M=TrainOut*pinv(TrainHiddenOutBias);                        %calculate the generalized weight
Weight=M(:,1:HiddenNum);                                    %calculate the weight
Bias=M(:,HiddenNum+1);                                      %calculate the bias

%Test
TestDistance=dist(Centers',TestIn);                         %calculate the distance of test data
TestSpreadMat=repmat(Spread,1,TestNum);                     %remat the spread
TestHiddenOut=exp(-(TestDistance./(TestSpreadMat)).^2);     %calculate the test output of hidden layer by Gaussian                                       
BiasMat=repmat(Bias,1,TestNum);                             %remat the Bias    
PreTestOut=Weight*TestHiddenOut+BiasMat;                    %calculate the predict test output
Data1(1,time)=10;
Data2(1,time)=PreTestOut;
Error=abs(TestOut-PreTestOut)/TestOut;
WholeError=WholeError+Error;
MSE=MSE+(Error)^2;
end
Weight
Bias
FOutput_PCNPKM_RBF=PreTestOut
AverageWholeError=WholeError/100   %calculate the average error of 100 times
WholeMSE=sqrt(MSE)/100
x1=1:100;
x2=1:100;
y1=Data1;
y2=Data2;
plot(x1,y1,'r-',x2,y2,'b-','linewidth',2)
xlabel('sample');      
ylabel('value');     
title('Error Result'); 
ylim([6 11])