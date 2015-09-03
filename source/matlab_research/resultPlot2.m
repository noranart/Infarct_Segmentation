clc
clearvars;
m=30;

load('hillclimbing.mat');
for i=2:m
    for k=1:10
            se=sum(GSensitivity([1,2,3,4,7,8,9,11,14,15,16,17,18],i,k))/13;
            sp=sum(GSpecificity([1,2,3,4,7,8,9,11,14,15,16,17,18],i,k))/13;
            if se<90 || sp<90
                GAccuracy([1,2,3,4,7,8,9,11,14,15,16,17,18],i,k)=0;  
            end
    end
end
for i=2:m
    for k=1:10
            p(i,k)=sum(GAccuracy([1,2,3,4,7,8,9,11,14,15,16,17,18],i,k))/13;  
    end
end

[A B]=max(max(p));
[D C]=max(p);
C(B)
B
Acc=A
Sens=sum(GSensitivity([1,2,3,4,7,8,9,11,14,15,16,17,18],C(B),B))/13
Spec=sum(GSpecificity([1,2,3,4,7,8,9,11,14,15,16,17,18],C(B),B))/13
