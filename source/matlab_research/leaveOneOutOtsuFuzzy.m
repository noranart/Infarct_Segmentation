clearvars;
load('otsu.mat')   %fuzzy / otsu .mat
arraySize=20;       %otsu: 20 , fuzzy: 30
thres=90;           %lower bound for sensitivity and specificity

Acc=zeros(0,0,0);
Sen=zeros(0,0,0);
Spe=zeros(0,0,0);
result=zeros(5,13);
c=1;
for i=[1,2,3,4,7,8,9,11,14,15,16,17,18]
    for j=1:(i-1)
        Acc(j,:,:)=Accuracy(j,:,:);
        Sen(j,:,:)=Sensitivity(j,:,:);
        Spe(j,:,:)=Specificity(j,:,:);
    end
    if(size(j,1)==0)
        j=1;
    end
    for k=(j+1):23
        Acc(k-1,:,:)=Accuracy(k,:,:);
        Sen(k-1,:,:)=Sensitivity(k,:,:);
        Spe(k-1,:,:)=Specificity(k,:,:);
    end
    
    Ac=zeros(arraySize,arraySize);
    Se=zeros(arraySize,arraySize);
    Sp=zeros(arraySize,arraySize);
    for j=1:22
        for k=1:arraySize
            for l=1:arraySize
                Ac(k,l)=Ac(k,l)+Acc(j,k,l);
                Se(k,l)=Se(k,l)+Sen(j,k,l);
                Sp(k,l)=Sp(k,l)+Spe(j,k,l);
            end
        end
    end
    Ac=Ac/22;
    Se=Se/22;
    Sp=Sp/22;
    
    while 1
        [m x]=max(max(Ac)); 
        if m==0
            break;
        end
        [m tmp]=max(Ac);
        y=tmp(x); 
        if Se(y,x)>=thres && Sp(y,x)>=thres
            break;
        end
        Ac(y,x)=0;
    end
    
    result(1,c)=y;        
    result(2,c)=x;   
    result(3,c)=Accuracy(i,y,x);
    result(4,c)=Sensitivity(i,y,x);
    result(5,c)=Specificity(i,y,x);
    c=c+1;
end
