pic=4;
group=10;

src=F(:,:,pic);

thres=multithresh(src,group-1);
for i=round(group/2):group-1
    display(i);
    BW = im2bw(src,thres(i));
    figure,subplot(1,2,1),imshow(src),subplot(1,2,2),imshow(BW);
    set(gcf,'units','normalized','outerposition',[0 0 1 1]);
    waitforbuttonpress;
    close all;
end