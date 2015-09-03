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
k=28;

[L,C,U,LUT,H]=FastFCMeans(uint16(src*(2^16-1)),k);
Umap=FM2map(uint16(src*(2^16-1)),U,H);
for l=1:k
    Dfuzzy(:,:,l)=im2bw(Umap(:,:,l),0.001);
end

l=28;
tmp = Dfuzzy(:,:,l);

if check==1
    for a=1:size(src,1)
        for b=1:size(src,2)
           if a<y1 || a>y2 || b<x1 || b>x2
              tmp(a,b)=0;
           end
        end
    end
end

labels = zeros(size(src,1),size(src,2));
for a=1:size(src,1)
    for b=1:size(src,2)
        if src(a,b)==0
            labels(a,b)=-1;
        end
    end
end

%erosion
percent = sum(sum(tmp==1))/sum(sum(src>0));
seSize=round(1+40*percent);
se = strel('ball',seSize,seSize);
e=imerode(double(tmp),se);
f=e-min(min(e));
f=f/max(max(f));
for a=1:size(src,1)
    for b=1:size(src,2)
        if f(a,b)==1
            labels(a,b)=1;
        end
    end
end

[labels_out, strengths] = growcut(src,labels);

thresStrength=0.9999;
tmp = labels_out;
for z=1:size(src,1)
    for m=1:size(src,2)
        if labels_out(z,m)==1 && strengths(z,m)<thresStrength
            tmp(z,m)=0;
        end
    end
end

tmp = imresize(tmp,[504 504]);
imwrite(tmp,'segment.jpg');