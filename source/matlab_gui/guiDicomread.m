fid = fopen('tmp');
path = fgetl(fid);

src = double(dicomread(path));
src = src/max(max(src));
src = imresize(src,[504 504]);
imwrite(src,'input.jpg');