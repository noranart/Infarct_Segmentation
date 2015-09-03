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
        Acc(j,:,:,:)=GAccuracy(j,:,:,:);
        Sen(j,:,:,:)=GSensitivity(j,:,:,:);
        Spe(j,:,:,:)=GSpecificity(j,:,:,:);
    end
    if(size(j,1)==0)
        j=1;
    end
    for k=(j+1):23
        Acc(k-1,:,:,:)=GAccuracy(k,:,:,:);
        Sen(k-1,:,:,:)=GSensitivity(k,:,:,:);
        Spe(k-1,:,:,:)=GSpecificity(k,:,:,:);
    end
    
    Ac=zeros(arraySize,arraySize,10);
    Se=zeros(arraySize,arraySize,10);
    Sp=zeros(arraySize,arraySize,10);
    for j=1:22
        for k=1:arraySize
            for l=1:arraySize
                for m=1:10
                    Ac(k,l,m)=Ac(k,l,m)+Acc(j,k,l,m);
                    Se(k,l,m)=Se(k,l,m)+Sen(j,k,l,m);
                    Sp(k,l,m)=Sp(k,l,m)+Spe(j,k,l,m);
                end
            end
        end
    end
    Ac=Ac/22;
    Se=Se/22;
    Sp=Sp/22;
    
    while 1
        [m x]=max(max(max(Ac))); 
        if m==0
            break;
        end
        [m tmp]=max(max(Ac));
        y=tmp(x);
        [m tmp]=max(Ac);
        z=tmp(1,y,x);
        if Se(z,y,x)>=thres && Sp(z,y,x)>=thres
            break;
        end
        Ac(z,y,x)=0;
    end
    
    result(1,c)=z;        
    result(2,c)=y;
    result(3,c)=x;
    result(4,c)=GAccuracy(i,z,y,x);
    result(5,c)=GSensitivity(i,z,y,x);
    result(6,c)=GSpecificity(i,z,y,x);
    c=c+1;
end
