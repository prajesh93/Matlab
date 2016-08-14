close all;
tic;
img=imread('castle.jpg');

img=rgb2gray(img);
imshow(img);
title('gray');
figure;
img=imgaussfilt(img,[0.001 0.1]);
img=double(img);
img=padarray(img,[1 1],'symmetric');
[r,c]=size(img);

Gx=zeros(size(img));
Gy=zeros(size(img));
sobel_x=[-1,0,1;-2,0,2;-1,0,1];
sobel_y=sobel_x';
for i=2:r-1
    for j=2:c-1
        window=img(i-1:i+1,j-1:j+1);
        temp1=sobel_x.*window;
        sum_temp1=sum(sum(temp1));
        Gx(i,j)=sum_temp1;
        
        temp2=sobel_y.*window;
        sum_temp2=sum(sum(temp2));
        Gy(i,j)=sum_temp2;
        
    end
end
Gm=sqrt((Gx.^2)+(Gy.^2));
Go=atan2(Gx,Gy);
Go=rad2deg(Go);
Go1=(Go);
Go=abs(Go);

Gm1=Gm;

Go(find(find(Go<181)>164))=0;
Go(find(find(Go<164)>110))=135;
Go(find(find(Go<110)>70))=90;
Go(find(find(Go>0)<23))=0;


G_final=zeros(size(Go));
Th=145;
Tl=72;

for i=2:r-1
    for j=2:c-1
        if Go(i,j)==0
            if Gm(i,j)>Gm(i-1,j) && Gm(i,j)>Gm(i+1,j)
                Gm1(i,j)=Gm(i,j);
            else
                Gm1(i,j)=0;
            end
        end
        if Go(i,j)==90
            if Gm(i,j)>Gm(i,j+1) && Gm(i,j)>Gm(i,j-1)
                Gm1(i,j)=Gm(i,j);
            else
                Gm1(i,j)=0;
            end
        end
        if Go(i,j)==45
            if Gm(i,j)>Gm(i-1,j-1) && Gm(i,j)>Gm(i+1,j+1)
                Gm1(i,j)=Gm(i,j);
            else
                Gm1(i,j)=0;
            end
        end
        if Go(i,j)==135
            if Gm(i,j)>Gm(i-1,j+1) && Gm(i,j)>Gm(i+1,j-1)
                Gm1(i,j)=Gm(i,j);
            else
                Gm1(i,j)=0;
            end
        end
        if Gm1(i,j)>=Th
            Gm1(i,j)=1;
        else
            if Gm1(i,j)>=Tl && Gm1(i,j)<Th
                Gm1(i,j)=0.5;
            else if Gm1(i,j)<Tl
                    Gm1(i,j)=0;
                end
                
            end
        end
        window=Gm1(i-1:i+1,j-1:j+1);
        t=max(max(window));
        if t==1 && Gm1(i,j)==0.5
            G_final(i,j)=1;
        end
        if Gm1(i,j)==1
            G_final(i,j)=1;
        end
        
        if Gm1(i,j)==0.5 &&t<1
            G_final(i,j)=0;
        end
        
    end
end


imshow((G_final));
title('Canny');
G_final=imcrop(G_final, [2 2 399 266]);
toc;
