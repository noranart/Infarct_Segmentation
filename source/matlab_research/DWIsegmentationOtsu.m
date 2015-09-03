clearvars;
algo='otsu';
load('finalTestcase.mat');

[optimizer, metric] = imregconfig('multimodal');
optimizer.InitialRadius = 0.001;
optimizer.Epsilon = 1.5e-4;
optimizer.GrowthFactor = 1.01;
optimizer.MaximumIterations = 300;

mkdir(char(strcat('segmentation/',algo)));
mkdir(char(strcat('segmentation/',algo,'-growcut')));
for i=[1:23]
   mkdir(char(strcat('segmentation/',algo,'/',num2str(i),'-',Dname(i))));
   mkdir(char(strcat('segmentation/',algo,'-growcut','/',num2str(i),'-',Dname(i))));
end

for j=[1:23]
    for i=[0:9]
       mkdir(char(strcat('segmentation/',algo,'-growcut','/',num2str(j),'-',Dname(j),'/',num2str(0.999+(i)/10000))));
    end
end

for k=2:20              %class
    for l=1:k           %class no
        for i=1:23      %picture no
            src=Dotsu(:,:,i,k,l);
            %crop
            x1=round(224*Fparam(1,i)/672-5);
            x2=round(224*Fparam(2,i)/672+5);
            y1=round(224*Fparam(3,i)/672-5);
            y2=round(224*Fparam(4,i)/672+5);
            %rough percentage screen
            c=sum(sum(D(:,:,i)>0));
            p=sum(sum(src>0));
            percent(i,k,l)=p/c;
            imwrite(src,char(strcat('segmentation/',algo,'/',num2str(i),'-',Dname(i),'/',num2str(k),'x',num2str(l),'.png')));
            if 100*percent(i,k,l)>=5 || 100*percent(i,k,l)<=0.01 || sum(sum(src(y1:y2,x1:x2)))==0
                TP=0;
                TN=0;
                FP=0;
                FN=0;
                Sensitivity(i,k,l)=0;  
                Specificity(i,k,l)=0;   
                Accuracy(i,k,l)=0;
            else
                for a=1:224
                    for b=1:224
                       if a<y1 || a>y2 || b<x1 || b>x2
                          src(a,b)=0;
                       end
                    end
                end
            
                register = tformRegister(src, Fresize(:,:,i), 'affine', optimizer, metric,tform(i));
                %#### Evaluation ####
                A=register;         %generate
                B=Fresize(:,:,i);   %answer
                TP=0;
                TN=0;
                FP=0;
                FN=0;
                for a=x1:x2
                    for b=y1:y2
                        if A(b,a)==1 && B(b,a)==1
                           TP=TP+1;
                        elseif A(b,a)==1 && B(b,a)==0
                           FP=FP+1;
                        elseif A(b,a)==0 && B(b,a)==1
                           FN=FN+1;
                        elseif A(b,a)==0 && B(b,a)==0
                           TN=TN+1;
                        end
                    end
                end
                TruePositive(i,k,l)=TP;
                TrueNegative(i,k,l)=TN;
                FalsePositive(i,k,l)=FP;
                FalseNegative(i,k,l)=FN;
                Sensitivity(i,k,l)=100*TP/(TP+FN);  
                Specificity(i,k,l)=100*TN/(TN+FP);   
                Accuracy(i,k,l)=100*(TP+TN)/(TP+TN+FP+FN);

                %imwrite(src,char(strcat('segmentation/',algo,'/',num2str(i),'-',Dname(i),'/',num2str(k),'x',num2str(l),'.png')));
                
                %growcut
                centerX = round((x1+x2)/2);
                centerY = round((y1+y2)/2);
                labels = backgroundLabel(:,:,i);

                %erosion
                seSize=round(1+40*percent(i,k,l));
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
                
                for w=0:9
                    thresStrength=0.999+(w)/10000;
                    tmp = labels_out;
                    for z=1:224
                        for m=1:224
                            if labels_out(z,m)==1 && strengths(z,m)<thresStrength
                                tmp(z,m)=0;
                            end
                        end
                    end
                    register = tformRegister(tmp, Fresize(:,:,i), 'affine', optimizer, metric,tform(i));
                    %#### Evaluation ####
                    A=register;         %generate
                    B=Fresize(:,:,i);   %answer
                    TP=0;
                    TN=0;
                    FP=0;
                    FN=0;
                    for a=x1:x2
                        for b=y1:y2
                            if A(b,a)==1 && B(b,a)==1
                               TP=TP+1;
                            elseif A(b,a)==1 && B(b,a)==0
                               FP=FP+1;
                            elseif A(b,a)==0 && B(b,a)==1
                               FN=FN+1;
                            elseif A(b,a)==0 && B(b,a)==0
                               TN=TN+1;
                            end
                        end
                    end
                    z=w+1;
                    GTruePositive(i,k,l,z)=TP;
                    GTrueNegative(i,k,l,z)=TN;
                    GFalsePositive(i,k,l,z)=FP;
                    GFalseNegative(i,k,l,z)=FN;
                    GSensitivity(i,k,l,z)=100*TP/(TP+FN);  
                    GSpecificity(i,k,l,z)=100*TN/(TN+FP);   
                    GAccuracy(i,k,l,z)=100*(TP+TN)/(TP+TN+FP+FN);
                    Gpercent(i,k,l,z)=100*sum(sum(tmp>0))/c;
                    
                    imwrite(tmp,char(strcat('segmentation/',algo,'-growcut','/',num2str(i),'-',Dname(i),'/',num2str(0.999+(w)/10000),'/',num2str(k),'x',num2str(l),'.png')));
                end    
            end
        end
    end
end
clearvars -except Accuracy Sensitivity Specificity percent GAccuracy GSensitivity GSpecificity Gpercent TruePositive TrueNegative FalsePositive FalseNegative GTruePositive GTrueNegative GFalsePositive GFalseNegative;
save('otsu.mat');