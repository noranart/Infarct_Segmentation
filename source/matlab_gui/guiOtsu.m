fid = fopen('tmp');
check = 0;
path = fgetl(fid);
x1 = fgetl(fid);
if ischar(x1)
    x1 = str2num(x1);
    x2 = str2num (fgetl(fid));
    y1 = str2num (fgetl(fid));
    y2 = str2num (fgetl(fid));
    check = 1;
end

src = double(dicomread(path));
src = src/max(max(src));
k=17;
l=10;


thres=multithres(src,k);
tmp=im2bw(src,thres(l));

if check==1
    for a=1:size(src,1)
        for b=1:size(src,2)
           if a<y1 || a>y2 || b<x1 || b>x2
              tmp(a,b)=0;
           end
        end
    end
end

tmp = imresize(tmp,[504 504]);
imwrite(tmp,'segment.jpg');