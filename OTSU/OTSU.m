%{ 
   Author: Prajesh Jhumkhawala 
%}

function[]= OTSU(name)
%{ 
This function autoatically determines the threshold value
for the supplied image.
It is basedon the approach suggested by NOBUYUKI OTSU in the paper
A Tlreshold Selection Method from Gray-Level Histograms
(https://engineering.purdue.edu/kak/courses-i-teach/ECE661.08/OTSU_paper.pdf)s
%}

close all;
figure;
rgb_img=imread(name); %Read the image
resized_image=imresize(rgb_img,[768 1024]); %Resizing the image
img_gray=0.21*resized_image(:,:,1) + 0.72*resized_image(:,:,2) + 0.07*resized_image(:,:,3);
imshow(rgb_img); %Gray scale image
title('Original Image');

thresh=0; %Initial threshold value
[row,col]=size(img_gray);
intensity=zeros(1,256);
%Determining the intensity of every pixel
for i=1:row
    for j=1:col
       intensity(img_gray(i,j)+1)=intensity(img_gray(i,j)+1)+1;
    end
end
prob1=intensity./(row*col); % Probability of each pixel
total=zeros(1,255);
cumulative1=0;
cumulative2=0;
class_mean1=0;
class_mean2=0;
variance_1=0;
variance_2=0;
       

while ~(thresh==255) 
    %Calcualting the sum of each class
    cumulative1=sum(intensity(1:thresh+1));
    cumulative2=sum(intensity(thresh+1:255));
    %Calcualting the mean of each class
    for temp=1:256
       
       if temp<thresh+1
           class_mean1=class_mean1+((temp*intensity(temp))/cumulative1);
       else
           class_mean2=class_mean2+((temp*intensity(temp))/cumulative2);
       end
    end 
   %Calcualting the variance of each class
   for temp=1:256

       if temp<thresh
           variance_1=variance_1+((temp-class_mean1)*(temp-class_mean1))*(intensity(temp)/cumulative1);
           
       else
           variance_2=variance_2+((temp-class_mean2)*(temp-class_mean2))*(intensity(temp)/cumulative2);
       end
    end
   %Calcualting the between class variance
   variance_3=(cumulative1*variance_1)+(cumulative2*variance_2);
   total(thresh+1)=variance_3;
   thresh=thresh+1;
   class_mean1=0;
   class_mean2=0;
   variance_1=0;
   variance_2=0;
       
end
%Finding the minimum
smallest=find(total==(min(total))); 
threshold_value=(smallest-1)/256;
disp([' Threshold Value ,.is ' num2str(threshold_value)]);
figure;
im=im2bw(img_gray,threshold_value);%Converting to binary using th obtained value
imshow(im);
title(['OTSU Implemented with Threshold ' num2str(threshold_value)]);
 end