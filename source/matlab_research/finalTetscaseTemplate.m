clearvars;

fid = fopen('D:\workspace\Matlab\final testcase\fileList.txt');

tline = fgetl(fid);
while ischar(tline)
    if tline(size(tline,2)-6)=='D'   
        disp(tline)
        src = dicomread(tline);
        
        
        imshow(src,[] );
        set(gcf,'units','normalized','outerposition',[0 0 1 1])
        waitforbuttonpress;
        close all;
    end
    tline = fgetl(fid);
end
fclose(fid);

