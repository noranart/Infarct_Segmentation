load('hillclimbing.mat')   
thres=90;           %lower bound for sensitivity and specificity

Acc=zeros(0,0);
Sen=zeros(0,0);
Spe=zeros(0,0);
result=zeros(5,13);
c=1;
for i=[1,2,3,4,7,8,9,11,14,15,16,17,18]
    for j=1:(i-1)
        Acc(j,:)=Accuracy(j,:);
        Sen(j,:)=Sensitivity(j,:);
        Spe(j,:)=Specificity(j,:);
    end
    if(size(j,1)==0)
        j=1;
    end
    for k=(j+1):23
        Acc(k-1,:)=Accuracy(k,:);
        Sen(k-1,:)=Sensitivity(k,:);
        Spe(k-1,:)=Specificity(k,:);
    end
    
    Ac=zeros(30,1);
    Se=zeros(30,1);
    Sp=zeros(30,1);
    for j=1:22
        for k=1:30
           Ac(k,1)=Ac(k,1)+Acc(j,k);
           Se(k,1)=Se(k,1)+Sen(j,k);
           Sp(k,1)=Sp(k,1)+Spe(j,k);
        end
    end
    Ac=Ac/22;
    Se=Se/22;
    Sp=Sp/22;
    
    while 1
        [m x]=max(Ac); 
        if m==0
            break;
        end
        if Se(x)>=thres && Sp(x)>=thres
            break;
        end
        Ac(x)=0;
    end
    
    result(1,c)=x;         
    result(2,c)=Accuracy(i,x);
    result(3,c)=Sensitivity(i,x);
    result(4,c)=Specificity(i,x);
    c=c+1;
end
