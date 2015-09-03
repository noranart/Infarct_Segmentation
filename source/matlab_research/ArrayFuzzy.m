%Dfuzzy x,y,image no,class,class no

clearvars;
Dfuzzy=zeros(0,0,0,0,0);
load('finalTestcase.mat');
for i=1:23
    src=D(:,:,i);
    i
    %#### algorithm ####
    check=0;
    c=sum(sum(src>0));
    k=3;
    while k<=20
        [L,C,U,LUT,H]=FastFCMeans(uint16(src*(2^16-1)),k);
        Umap=FM2map(uint16(src*(2^16-1)),U,H);
        for l=1:k
            Dfuzzy(:,:,i,k,l)=im2bw(Umap(:,:,l),0.001);
        end
        k=k+1;
    end     
end