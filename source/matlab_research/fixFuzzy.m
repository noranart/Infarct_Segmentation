% for i=1:23
%     Fresize(:,:,i)=imresize(Fseg(:,:,i),[224 224],'nearest');
% end


i=5
src=D(:,:,i);
for k=26:30
    [L,C,U,LUT,H]=FastFCMeans(uint16(src*(2^16-1)),k);
    Umap=FM2map(uint16(src*(2^16-1)),U,H);
    for l=1:k
        Dfuzzy(:,:,i,k,l)=im2bw(Umap(:,:,l),0.001);
%         imshow(Dfuzzy(:,:,i,k,l),[]);
%         waitforbuttonpress;
    end
end

%clearvars -except D Dname F Fname Fparam Fresize Fseg backgroundLabel tform Dotsu Dfuzzy Dhill DhillCount
%save('finalTestcase.mat');