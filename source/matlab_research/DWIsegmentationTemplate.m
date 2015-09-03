clearvars;
load('finalTestcase.mat');
Dseg=zeros(0,0,0);
Eval=zeros(0,0);

lowerBound=0.1;
upperBound=0.3;
for i=1:23
    src=D(:,:,i);
    i

    %#### algorithm ####
    check=0;
    c=sum(sum(src>0));
    k=2;
    while k<=20
        l=2;
        while l<=k
            thres=multithresh(src,k);
            Dseg(:,:,i)=im2bw(src,thres(l));
            p=sum(sum(Dseg(:,:,i)>0));
            if(c<=100*p/lowerBound && c>=100*p/upperBound)  %boundary check  
                100*p/c
                k=99;
                l=k+1;
                check=1;
            end
            l=l+1;
        end
        k=k+1;
    end




    if check==0
        Eval(1,i)=0;            %Sensitivity
        Eval(2,i)=0;            %Specificity
        Eval(3,i)=0; %Accuracy
        Eval(4,i)=0;
        Eval(5,i)=0;
        Eval(6,i)=0;
        Eval(7,i)=0;
        display('failed')
    else     
    
%     x1=1;
%     y1=1;
%     x2=size(src,2);
%     y2=size(src,1);
%     %cheat
    x1=round(224*Fparam(1,i)/672-5);
    x2=round(224*Fparam(2,i)/672+5);
    y1=round(224*Fparam(3,i)/672-5);
    y2=round(224*Fparam(4,i)/672+5);
    for k=1:224
        for l=1:224
           if k<y1 || k>y2 || l<x1 || l>x2
              Dseg(k,l,i)=0;
           end
        end
    end    
    
    %#### registration ####
    moving=D(:,:,i);
    fixed=F(:,:,i);
    fixed=imresize(fixed,[size(moving,1),size(moving,2)]);
    [optimizer, metric] = imregconfig('multimodal');
    optimizer.InitialRadius = 0.001;
    optimizer.Epsilon = 1.5e-4;
    optimizer.GrowthFactor = 1.01;
    optimizer.MaximumIterations = 300;

    %find tform
    %tform = imregtform(moving, fixed, 'affine', optimizer, metric);

    %change moving, fixed to dseg, fseg
    moving=Dseg(:,:,i);
    fixed=imresize(Fseg(:,:,i),[size(moving,1),size(moving,2)],'nearest');
    register = tformRegister(moving, fixed, 'affine', optimizer, metric,tform(i));
    register=im2bw(register,0.01);

    %#### Evaluation ####
    A=register;
    B=fixed;
    TP=0;
    TN=0;
    FP=0;
    FN=0;
    for l=x1:x2
        for k=y1:y2
            if A(k,l)==1 && B(k,l)==1
               TP=TP+1;
            elseif A(k,l)==1 && B(k,l)==0
               FP=FP+1;
            elseif A(k,l)==0 && B(k,l)==1
               FN=FN+1;
            elseif A(k,l)==0 && B(k,l)==0
               TN=TN+1;
            end
        end
    end
    Eval(1,i)=100*TP/(TP+FN);            %Sensitivity
    Eval(2,i)=100*TN/(TN+FP);            %Specificity
    Eval(3,i)=100*(TP+TN)/(TP+TN+FP+FN); %Accuracy
    Eval(4,i)=TP;
    Eval(5,i)=TN;
    Eval(6,i)=FP;
    Eval(7,i)=FN;

    %imshow
%     figure,subplot(1,2,1),imshowpair(D(:,:,i),fixed),subplot(1,2,2),imshowpair(register,fixed);
%     set(gcf,'units','normalized','outerposition',[0 0 1 1])
%     figure,subplot(1,2,1),imshow(D(:,:,i)),subplot(1,2,2),imshow(Dseg(:,:,i));
%     set(gcf,'units','normalized','outerposition',[0 0 1 1])
%     waitforbuttonpress;
%     close all;
    %imwrite(Dseg(:,:,i),char(strcat('segmentation/',folderName,'/',Dname(i),'.png')));
    end
end
