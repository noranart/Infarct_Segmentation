%Dfuzzy x,y,image no,class,class no

clearvars;
Dhill=zeros(0,0,0,0);
%DhillCount=zeros(100,23,25);
load('finalTestcase_old.mat');
for i=1:23
    src=D(:,:,i);
    for k=2:30
        seg=HillClimbingSegment(src,k);
        Dhill(:,:,i,k)=seg;
        count=0;
        for w=1:max(max(seg))
            count(w)=sum(sum(seg==w));
        end
        count(count==0)=10^5;
        [A B]=sort(count);
        for w=1:max(max(seg))
            if(A(w)==10^5)
                break;
            end
            DhillCount(w,i,k)=B(w);
        end
        
        [L,C,U,LUT,H]=FastFCMeans(uint16(src*(2^16-1)),k);
        Umap=FM2map(uint16(src*(2^16-1)),U,H);
        for l=1:k
            Dfuzzy(:,:,i,k,l)=im2bw(Umap(:,:,l),0.001);
        end
    end
    for k=2:20
        thres=multithresh(src,k);
        for l=1:k
            Dotsu(:,:,i,k,l)=im2bw(src,thres(l));
        end
    end
end
clearvars -except D Dname F Fname Fparam Fresize Fseg backgroundLabel tform Dotsu Dfuzzy Dhill DhillCount
save('finalTestcase.mat');