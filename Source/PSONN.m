clc
clear
input=[1,1,2,3,2,1,4,0;
       3,2,3,4,1,2,5,1;
       5,3,4,5,2,1,6,2;
       7,4,5,6,1,2,7,3;
       9,5,6,7,2,1,8,4];
    
output=[2;4;6;8;10];

%every neuron number of three layer network
inputnum=8;
hiddennum=6;
outputnum=1;
d=inputnum*hiddennum+hiddennum+hiddennum*outputnum+outputnum; %particle dimension
WholeError=0; %whole error of 10 times
MSE=0;
Data1=zeros(1,10);
Data2=zeros(1,10);
%four samples for train the network and one for test
input_train=input(1:4,:)';
input_test=input(5,:)';
output_train=output(1:4)';
output_test=output(5)';

% build the network
net=newff(input_train,output_train,hiddennum);
for time=1:10
%PSO:initialize the Learning constant "C1 C2", Maximal generation
%"maxgen",Population size "sizepop", Range of velocity "Vmax Vmin",Range of
%particle position "Pmax Pmin" 
c1 = 2;
c2 = 2;
maxgen=30;  
sizepop=10;   
Vmax=1;
Vmin=-1;
Pmax=3;
Pmin=-3;
%initialize every particle velocity and position from [-1,1]
for i=1:sizepop
    pop(i,:)=rands(1,d);
    V(i,:)=rands(1,d);
    fitness(i)=fun(pop(i,:),inputnum,hiddennum,outputnum,net,input_train,output_train);%calculate every partical fitness in function "fun"
end

%Initialize the global best position and individual best position and store
%them
[bestfitness bestindex]=min(fitness);
Gbest=pop(bestindex,:);   
Pbest=pop;    
fitnessPbest=fitness;   
fitnessGbest=bestfitness;   

%Iterative optimization
for i=1:maxgen

    %updata every partical
    for j=1:sizepop
        
        
        W=0.9-(0.9-0.4)*i/maxgen;
        %updata velocity
        V(j,:) = W*V(j,:) + c1*rand*(Pbest(j,:) - pop(j,:)) + c2*rand*(Gbest - pop(j,:));
        V(j,find(V(j,:)>Vmax))=Vmax;
        V(j,find(V(j,:)<Vmin))=Vmin;
        
        %updata position
        pop(j,:)=pop(j,:)+V(j,:);
        pop(j,find(pop(j,:)>Pmax))=Pmax;
        pop(j,find(pop(j,:)<Pmin))=Pmin;
        
        %calculate fitness
        fitness(j)=fun(pop(j,:),inputnum,hiddennum,outputnum,net,input_train,output_train);
    end
    
    %updata individual best position based on fitness
    for j=1:sizepop

    if fitness(j) < fitnessPbest(j)
        Pbest(j,:) = pop(j,:);
        fitnessPbest(j) = fitness(j);
    end
    
    %updata global best position based on fitness
    if fitness(j) < fitnessGbest
        Gbest = pop(j,:);
        fitnessGbest = fitness(j);
    end
    
    end
    
    %store the global fitness in every iterative
    F(i)=fitnessGbest;    
        
end

%extract weight and bias
x=Gbest;
w1=x(1:inputnum*hiddennum);
B1=x(inputnum*hiddennum+1:inputnum*hiddennum+hiddennum);
w2=x(inputnum*hiddennum+hiddennum+1:inputnum*hiddennum+hiddennum+hiddennum*outputnum);
B2=x(inputnum*hiddennum+hiddennum+hiddennum*outputnum+1:inputnum*hiddennum+hiddennum+hiddennum*outputnum+outputnum);
%voluation
net.iw{1,1}=reshape(w1,hiddennum,inputnum);
net.lw{2,1}=reshape(w2,outputnum,hiddennum);
net.b{1}=reshape(B1,hiddennum,1);
net.b{2}=B2;
%train the network and set parameter
net.trainParam.epochs=10;
net.trainParam.lr=0.05;
net.trainParam.goal=0.00001;
[net,per2]=train(net,input_train,output_train);

Weight1=net.iw{1,1};
Weight2=net.lw{2,1};
Bias1=net.b{1};
Bias2=net.b{2};
FOutput_PSONN=sim(net,input');
TestActualOutput=FOutput_PSONN(5);
ErrorRate=abs((TestActualOutput-output_test)/output_test);
WholeError=WholeError+ErrorRate;
MSE=MSE+(ErrorRate)^2;
Data1(1,time)=10;
Data2(1,time)=TestActualOutput;
end
Weight1
Weight2
Bias1
Bias2
AverageWholeError=WholeError/10   %calculate the average error of 100 times
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