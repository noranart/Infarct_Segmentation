m=30;
clc
clearvars p name;
for i=2:m
    for k=1:i
    for j=1:10
        p(i,k,j)=sum(GAccuracy([1,2,3,4,7,8,9,11,14,15,16,17,18],i,k,j))/13;  
    end
    end
end

[A B]=max(max(max(p)));
[D C]=max(max(p));
[E F]=max(p);
F(1,C(B),B)
C(B)
B
Acc=A
Sens=sum(GSensitivity([1,2,3,4,7,8,9,11,14,15,16,17,18],F(1,C(B),B),C(B),B))/13
Spec=sum(GSpecificity([1,2,3,4,7,8,9,11,14,15,16,17,18],F(1,C(B),B),C(B),B))/13
    
for i=2:m
    for k=1:i
    for j=1:10
        p(i,k,j)=sum(GSensitivity([1,2,3,4,7,8,9,11,14,15,16,17,18],i,k,j))/13;  
    end
    end
end

[A B]=max(max(max(p)));
[D C]=max(max(p));
[E F]=max(p);
F(1,C(B),B)
C(B)
B
Acc=sum(GAccuracy([1,2,3,4,7,8,9,11,14,15,16,17,18],F(1,C(B),B),C(B),B))/13
Sens=A
Spec=sum(GSpecificity([1,2,3,4,7,8,9,11,14,15,16,17,18],F(1,C(B),B),C(B),B))/13

for i=2:m
    for k=1:i
    for j=1:10
        p(i,k,j)=sum(GSpecificity([1,2,3,4,7,8,9,11,14,15,16,17,18],i,k,j))/13;  
    end
    end
end

[A B]=max(max(max(p)));
[D C]=max(max(p));
[E F]=max(p);
F(1,C(B),B)
C(B)
B
Acc=sum(GAccuracy([1,2,3,4,7,8,9,11,14,15,16,17,18],F(1,C(B),B),C(B),B))/13
Sens=sum(GSensitivity([1,2,3,4,7,8,9,11,14,15,16,17,18],F(1,C(B),B),C(B),B))/13
Spec=A
    