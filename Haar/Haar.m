%{ 
   Author: Prajesh Jhumkhawala 
%}

function Haar(img)
%{ 
   This function performs image compression on the image provided.
It is based on the approach suggested by 
Colm Mulcahy in Image compression using the Haar wavelet transform
( https://www.eecis.udel.edu/~amer/CISC651/Haar.wavelets.paper.by.Mulcahy.pdf )
%}


close all;
orig=imread(img);
imshow(orig);
title('Original');
figure;
orig=double(orig); %Converting the image to double
[row,col]=size(orig);
k=log(row)/log(2); %Determining the number of iteration required
orig1=orig;
orig2=orig1;
%Carrying out Row transformations
for j=1:row
    count=0;
    num1=row;
    num3=row;
    i=1;
    while count<k
        num=1;
        num2=(num3/2)+1;
        while i<num1+1
            orig2(j,num)= ((orig1(j,i)+orig1(j,i+1))/2);
            orig2(j,num2)= (orig1(j,i)-orig1(j,i+1))/2;
            i=i+2;
            num=num+1;
            num2=num2+1;
            
        end
        orig1=orig2;
        i=1;
        num1=num1/2;
        count=count+1;
        num3=num3/2;
    end
end
row_trans=orig1;
%Carrying out column transformations

orig1=orig1';
orig2=orig1;
for j=1:row
    
    count=0;
    num1=row;
    num3=row;
    i=1;
    while count<k
        num=1;
        num2=(num3/2)+1;
        while i<num1+1
            orig2(j,num)= ((orig1(j,i)+orig1(j,i+1))/2);
            orig2(j,num2)= (orig1(j,i)-orig1(j,i+1))/2;
            i=i+2;
            num=num+1;
            num2=num2+1;
            
        end
        orig1=orig2;
        i=1;
        num1=num1/2;
        count=count+1;
        num3=num3/2;
    end
end
orig1=orig1';
final=orig1;

%Thresholding
e=4;
orig1(abs(orig1)<=e)= 0;
thresh=orig1;


%INVERSE TRANSFORM
%Carrying out column transformations

orig1=orig1';
orig2=orig1;
for j=1:row
    count=0;
    num1=1;
    i=1;
    while count<k
        num=1;
        num2=power(2,count);
        while i<num1+1
            orig2(j,num)= ((orig1(j,i)+orig1(j,i+num2)));
            orig2(j,num+1)= (orig1(j,i)-orig1(j,i+num2));
            i=i+1;
            num=num+2;
        end
        orig1=orig2;
        i=1;
        num1=num1*2;
        count=count+1;
    end
end
count=0;
%Carrying out row transformations

orig1=orig1';
i=1;
orig2=orig1;
for j=1:row
    count=0;
    num1=1;
    i=1;
    while count<k
        num=1;
        num2=power(2,count);
        while i<num1+1
            orig2(j,num)= ((orig1(j,i)+orig1(j,i+num2)));
            orig2(j,num+1)= (orig1(j,i)-orig1(j,i+num2));
            i=i+1;
            num=num+2;
        end
        orig1=orig2;
        i=1;
        num1=num1*2;
        count=count+1;
    end
end
small=uint8(orig1);
imshow(small);
title('Final');
imwrite(small,'compressed.jpg');
end
