
%{
    Author: Prajesh Jhumkhawala
%}
function DCT(Filename)
%{
    This function generates the discrete cosine transform for the image and
    then regenerates the image from the generated DCT  of the image.
%}
close all;
I=double(rgb2gray(imread(Filename)));
Y=DCT_dimen(I);
A=Y*I*Y';
imshow(A);
title('Discrete Cosine Transform');
figure;
B=Y'*A*Y;
imshow(B/max(max(B)));
title('Inverse Discrete Cosine Transform');
end

%Function which generates the matrix that will be used to compute the DCT
%and Inverse DCT
function T=DCT_dimen(img)
N=length(img);
T=zeros(size(img));
for p=1:N
    for q=1:N
        if p==1
            T(p,q)=sqrt(1/N);
        else
            temp=(pi*((2*q)+1)*p)/(2*N);
            T(p,q)=sqrt(2/N)*cos(temp);
        end
    end
end
end

