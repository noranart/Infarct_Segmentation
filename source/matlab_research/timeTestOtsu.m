i=1;
x1=Fparam(i,1);
x2=Fparam(i,2);
y1=Fparam(i,3);
y2=Fparam(i,4);

src=D(:,:,i);
k=17;
l=10;

src=D(:,:,l)

thres=multithresh(src,k);
tmp=im2bw(src,thres(l));

%imshow(tmp);