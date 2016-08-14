%{
Author: Prajesh Jhumkhawala
%}

function[]= rgbh(name)
%%
close all;
img=imread(name); %Reading the image from the current folder 
img_eq=img;
%(Storing the image read into multiple images%)
img_red=img;
img_green=img;
img_blue=img;
figure; %Figure keyword is used to display the image in new window
%( The blue and green channels are changed to 0 to display the red channel%)
img_red(:,:,2)=0;
img_red(:,:,3)=0;
img_green(:,:,1)=0;
img_green(:,:,3)=0;
img_blue(:,:,1)=0;
img_blue(:,:,2)=0;
set(gcf, 'Position', get(0,'Screensize'));
subplot(2,2,1);
imshow(img);
title('Original Image')
subplot(2,2,2);
imshow(img_red);
title('Red Image')
subplot(2,2,3);
imshow(img_green);
title('Green Image')
subplot(2,2,4);
imshow(img_blue);
title('Blue Image')
%%
%Converting the image to another format
imwrite(img,'FLOWERS.jpeg');
%%
figure;
set(gcf, 'Position', get(0,'Screensize'));
subplot(1,2,1);
%Following formula is used to covert the RGB image to gray-scale image
img_gray=0.21*img(:,:,1) + 0.72*img(:,:,2) + 0.07*img(:,:,3);
img_gray1=0.21*img_eq(:,:,1) + 0.72*img_eq(:,:,2) + 0.07*img_eq(:,:,3);

imshow(img);
title('Original Image')
subplot(1,2,2);
imshow(img_gray);
title('Gray Image')

%%
figure;
set(gcf, 'Position', get(0,'Screensize'));
subplot(1,2,1);
%Function im2bw is used to convert the given image to binary image.
image_bin=im2bw(img_gray,0.5);
imshow(img);
title('Original Image')
subplot(1,2,2);
imshow(image_bin);
title('Binary Image')


%%
figure;
set(gcf, 'Position', get(0,'Screensize'));
subplot(2,2,1);
imshow(img);
title('Original Image')
subplot(2,2,2);
img1=(img_red+img_blue)*2; %Arithematic Operation 1
imshow(img1);
title('(Red channel + blue Channel).*2')
subplot(2,2,3);
img1=(img.^2);%Arithematic Operation 2
imshow(img1);
title('Original Image^2')
subplot(2,2,4);
img1=(img.^2)-img;%Arithematic Operation 3
imshow(img1);
title('Original Image^2-(Original Image)')
%%
figure;
set(gcf, 'Position', get(0,'Screensize'));

im = imread('Sea-7.jpg');
subplot(2,2,1)
imshow(im);
title('Image 1');
im=imcrop(im,[0 0 1024 768]);
imgh = imread('Boat.jpg');
subplot(2,2,2)
imshow(imgh);
title('Image 2');
imh=imgh+im; %Arithematic Operation 4 
subplot(2,2,3)
imshow(imh);
title('Image 1+Image 2');
figure;


%%
[row,col]=size(img_gray);

intensity=zeros(1,256);
%For loop is used to calculate the intensity for every pixel in the image
for i=1:row
    for j=1:col
       intensity(img_gray(i,j)+1)=intensity(img_gray(i,j)+1)+1;
    end
end
set(gcf, 'Position', get(0,'Screensize'));

subplot(2,3,1);
plot(intensity); %plotting the intensity array will give us the histogram for the image
title('Intensity');
[row1,col1]=size(img_gray1);

intensity1=zeros(1,256);
for i=1:row1
    for j=1:col1
       intensity1(img_gray1(i,j)+1)=intensity1(img_gray1(i,j)+1)+1;
    end
end
%%
%Calculating the probability of each pixel's occurence in the image and
%plotting it will give us the PDF for that image
prob=intensity./(row*col); 
subplot(2,3,2);
plot(prob);
title('PDF')
prob1=intensity1./(row1*col1);
%%
%Calculating the cumulative probability of each pixel's occurence in the image and
%plotting it will give us the CDF for that image

cdfArray=zeros(1,256);
total=0;
for i=1:256
    total=total+prob(i);
    cdfArray(i)=total;
end
subplot(2,3,3);
plot(cdfArray);
title('CDF');
cdfArray1=zeros(1,256);
total=0;
for i=1:256
    total=total+prob1(i);
    cdfArray1(i)=total;
end
%%
%Histogram Equalization: each pixel value is multiplied by 255 and then the
%formula is used to find the corresponding value for thatpixel in the new
%image
temp=cdfArray1.*255;
hist_equal=img_gray1;
for i=1:row1
    for j=1:col1
       hist_equal(i,j)=temp(img_gray1(i,j)+1);
    end
end
figure;
set(gcf, 'Position', get(0,'Screensize'));

subplot(1,2,1)
imshow(img_gray1);
title('originalImage');
subplot(1,2,2)
imshow(hist_equal);
title('Equalized image');
end
