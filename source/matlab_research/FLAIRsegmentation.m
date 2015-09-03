% x1=251;
% x2=317;
% y1=284;
% y2=424;


param(5,pic)=group;
param(6,pic)=thres(i);

seg(:,:,pic)=BW;
% for i=1:672
%     for j=1:672
%         if i<y1 || i>y2 || j<x1 || j>x2
%             seg(i,j,pic)=0;
%         end
%     end
% end

% figure,subplot(1,2,1),imshow(BW),subplot(1,2,2),imshow(seg(:,:,pic));
% set(gcf,'units','normalized','outerposition',[0 0 1 1]);
% 
% clearvars ans BW group i j x1 x2 y1 y2 thres src pic;