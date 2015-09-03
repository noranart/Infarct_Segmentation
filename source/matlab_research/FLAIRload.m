clearvars;

fid = fopen('D:\workspace\Matlab\final testcase\fileList.txt');
arraySrc = zeros(0,0,0);
name = cell(10,1);
src = double(0);
count = 1;

tline = fgetl(fid);
while ischar(tline)
    if tline(size(tline,2)-6)=='F'   
        disp(tline)
        disp(count)
        src = double(dicomread(tline));
        src = src/max(max(src));
        arraySrc(:,:,count)=src;
        name{count} = tline(max(strfind(tline,'\'))+1:end-4);
        
        imshow(src);
        set(gcf,'units','normalized','outerposition',[0 0 1 1])
        %waitforbuttonpress;
        close all;
        count = count+1;
    end
    tline = fgetl(fid);
end
fclose(fid);
clearvars ans count fid src tline;
