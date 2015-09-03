i=1;
x1=Fparam(i,1);
x2=Fparam(i,2);
y1=Fparam(i,3);
y2=Fparam(i,4);

src=D(:,:,i)
k=28;    


[L,C,U,LUT,H]=FastFCMeans(uint16(src*(2^16-1)),k);
Umap=FM2map(uint16(src*(2^16-1)),U,H);
for l=1:k
    Dfuzzy(:,:,l)=im2bw(Umap(:,:,l),0.001);
end

l=28;
src=Dfuzzy(:,:,l)

centerX = round((x1+x2)/2);
centerY = round((y1+y2)/2);
labels = backgroundLabel(:,:,i);

%erosion
seSize=round(3);
se = strel('ball',seSize,seSize);
e=imerode(double(src),se);
f=e-min(min(e));
f=f/max(max(f));
for a=1:224
    for b=1:224
        if f(a,b)==1
            labels(a,b)=1;
        end
    end
end

[labels_out, strengths] = growcut(D(:,:,i),labels);

thresStrength=0.9999;
tmp = labels_out;
for z=1:224
    for m=1:224
        if labels_out(z,m)==1 && strengths(z,m)<thresStrength
            tmp(z,m)=0;
        end
    end
end

imwrite(tmp,'1.png');