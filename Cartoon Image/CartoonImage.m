%{
    Author: Prajesh Jhumkhawala
%}
function CartoonImage(image)
%{
    This function contains all the function required to generate the
    cartoon image. It will also calculate the RMSE of both Bilaterat Filter
    and Canny Edge Detection.
%}
close all;
tic;
img= imread(image);
img=imresize(img,[267 400]);
img = im2double(img);
bilat = bilateralFilter(img, 9, 5, 10);
%note: the matlab function takes kernel size as (floor(kernelWidth/2))
%so this matches the kernel of size 9 passed into your function.
matlabbilat = bfilter2(img, 4, 5, 10);
str = strcat('Bilateral Filter RMSE: ',int2str(RMSerror(bilat, matlabbilat)) );
str
edges = Canny(rgb2gray(img), 100, 200);
matlabedges = edge(rgb2gray(img),'canny');
%left off here
str = strcat('Canny Edge RMSE: ',int2str(RMSerror(edges, matlabedges)) );
str
cartoon = cartoonImage(bilat, edges);
%The lines below can be used for looking at your output images, and saving
%them once your code is implemented. Be sure to include the images in your
%report.

imshow(bilat);
title('Bilateral');
figure;
imwrite( bilat,'BilateralOutput.jpg');
imshow(edges);
imwrite(edges,'CannyOutput.jpg')
title('Canny');
figure;
imshow( cartoon);
imwrite( cartoon,'CartoonOutput.jpg');
title('Cartoon');
toc;
end


function I = bilateralFilter(img, ksize, sigmaColor, sigmaSpace)

%     DESCRIBE YOUR FUNCTION HERE
%     (Param descriptions from the OpenCV Documentation)
%     :param img: Double format 3 channel color image.
%     :param kSize: Diameter of each pixel neighborhood that is used during filtering.
%         If it is non-positive, it is computed from sigmaSpace.
%     :param sigmaColor: Filter sigma in the color space. A larger value of the parameter
%         means that farther colors within the pixel neighborhood (see sigmaSpace) will
%         be mixed together, resulting in larger areas of semi-equal color.
%     :param sigmaSpace: Filter sigma in the coordinate space. A larger value of the
%         parameter means that farther pixels will influence each other as long as their
%         colors are close enough (see sigmaColor ). When d>0, it specifies the neighborhood
%         size regardless of sigmaSpace. Otherwise, d is proportional to sigmaSpace.
%     :param borderType: always Reflect_101
%     :return: Filtered image of same size and type as img
%     """

img=padarray(img,[4 4],'circular'); %Padding the array so that the kSize window can fit properly
im=rgb2lab(img); %Converting the image to lab and seperating the L,A and B channels.
lab=im(:,:,1);
a=im(:,:,2);
b=im(:,:,3);
[r,c]=size(a);
e1=0;
e2=0
e=0;
sum_e=0;
sum_up=0;
opimg=zeros(size(a));
for i=1:r-4
    for j=1:c-4
        for k=i:i+ksize-1
            for l=j:j+ksize-1
                if k<r-4 && l<c-4
                    e1=-((abs(lab(i,j)-lab(k,l))^2)./2*(sigmaSpace^2));
                    e2=-((((a(i)-a(k))^2) +((b(j)-b(l))^2))/(2*(sigmaColor^2)));
                    e=exp(e1+e2);
                    sum_e=sum_e+e;
                    temp=lab(k,l)*e;
                    sum_up=sum_up+temp;
                end
            end
        end
        opimg(i,j)=sum_up./sum_e; %setting the new pixel value at i,j
        sum_up=0;
        sum_e=0;
    end
end
im(:,:,1)=opimg; %making the new image as the luminosity for the initialimage
im1=lab2rgb(im);
im1=imcrop(im1,[5 5 399 266]);
im1(isnan(im1))=0; %%Replacingall the NaN values with 0
I=im1;

end
function I = Canny(img, thresh1, thresh2)
%     The function finds the edges of the image and highlights them.
%     It uses gaussianfilter, Sobel Filter ,non-maximum supression and 
%     edge hysteresis.
%     :param img: 8-bit input image.
%     :param thresh1: hysteresis threshold 1.
%     :param thresh2: hysteresis threshold 2.
%     :return: a single channel 8-bit with the same size as img

thresh1=thresh1/2;
thresh2=thresh2/2;
img=padarray(img,[1 1],'symmetric');
[r,c]=size(img);
img=imgaussfilt(img,0.01); %Applying gaussian filter
Gx=zeros(size(img));
Gy=zeros(size(img));
sobel_x=[-1,0,1;-2,0,2;-1,0,1];
sobel_y=sobel_x';
%Applying Sobel Filter
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
Gm=sqrt((Gx.^2)+(Gy.^2)); %Calculating the Magnitute nd orientation matrix 
Go=atan2(Gx,Gy);
Go=rad2deg(Go);
Go=abs(Go);
%Changing orientations to 0,45,90,135
Go(find(Go<181)>164)=0;
Go(find(Go<164)>110)=135;
Go(find(Go<110)>70)=90;
Go(find(Go>0)<23)=0;
Gm1=Gm;

thresh1=thresh1/255;
thresh2=thresh2/255;
%performing non-maximum supression and edge hysteresis
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
        if Gm1(i,j)>=thresh2
            Gm1(i,j)=1;
        else
            if Gm1(i,j)>=thresh1 && Gm1(i,j)<thresh2
                Gm1(i,j)=0.5;
            else if Gm1(i,j)<thresh1
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


G_final=imcrop(G_final, [2 2 399 266]);
I=G_final;

end
function I = cartoonImage(filtered, edges)

%     This function generates the Cartoon image from the bilateral and
%     canny images.
%     :param filtered: a bilateral filtered image
%     :param edges: a canny edge image
%     :return: a cartoon image
%

[r,c]=size(filtered);
for i=1:r-1
    for j=1:(c/3)-1
        if edges(i,j)==1
            filtered(i,j,1)=0;
            filtered(i,j,2)=0;
            filtered(i,j,3)=0;
        end
    end
end
I=filtered;

end
function RMSE = RMSerror(img1, img2)

%     A testing function to see how close your images match expectations
%     Try to make sure your error is under 1. Some floating point error will occur.
%     :param img1: Image 1
%     :param img2: Image 2
%     :return: The error between the two images

diff = img1 - img2;
squaredErr = diff .^2;
meanSE = mean(squaredErr(:));
RMSE = sqrt(meanSE);
end
