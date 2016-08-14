%{
    Author: Prajesh Jhumkhawala
%}
function Hybrid1(filename,filename2)
%{
    This function is the main function and calls the subfunctionsto
    generate the Hybrid image og the two supplied images.
%}
close all;
h=hybridImage(filename,filename2);
imshow(h);
title('HYBRID');

end

%Function to calculate the DFFT of the Image
function Y= dfft(I1)
new=zeros(size(I1));
[r,c]=size(I1);
for i=1:r
new(i,:)=dfft_helper(I1(i,:)); %DFFT for each row
end
for i=1:c
    new1(:,i)=dfft_helper(new(:,i)); %DFFT for each coloumn
end
Y=new1;
end

%Helper function to calculate the DFFT of the Image by implementing Cooley-Tuckey
%algorithm
function Y=dfft_helper(x)
N=length(x);
if N==1
    X(1)=x(1);
else
    xe=x(1:2:N);
    xo=x(2:2:N);
    
    X(1:N/2)=dfft_helper(xe);
    X(N/2+1:N)=dfft_helper(xo);
    for k=1:N/2
        t=X(k);
        X(k)=t + (exp(-1i*2*pi*(k-1)/N)*X(k+(N/2)));
        X(k+(N/2))=t - (exp(-1i*2*pi*(k-1)/N)*X(k+(N/2)));
    end
    
end
Y=X;
end

%Function that shifts the DFFT image to the center
function X=fftshift1(x)
N=length(x);
ul=x(1:N/2,1:N/2);
ur=x(1:N/2,(N/2)+1:N);
ll=x((N/2)+1:N,1:N/2);
lr=x((N/2)+1:N,(N/2)+1:N);

X(1:N/2,1:N/2)=lr;
X(1:N/2,(N/2)+1:N)=ll;
X((N/2)+1:N,1:N/2)=ur;
X((N/2)+1:N,(N/2)+1:N)=ul;
end

%Function that computes the inverse center shift of the center shifted DFFT image
function x=ifftshift1(X)
N=length(X);
lr=X(1:N/2,1:N/2);
ll=X(1:N/2,(N/2)+1:N);
ur=X((N/2)+1:N,1:N/2);
ul=X((N/2)+1:N,(N/2)+1:N);

x(1:N/2,1:N/2)=ul;
x(1:N/2,(N/2)+1:N)=ur;
x((N/2)+1:N,1:N/2)=ll;
x((N/2)+1:N,(N/2)+1:N)=lr;

end

%Function to calculate the Inverse DFFT of the Image
function new2=idfft(x)
[r c]=size(x);
for i=1:c
    new3(:,i)=idfft_helper(x(:,i))./length(x(:,i)); %Inverse DFFT for each row
end

for i=1:r
new2(i,:)=idfft_helper(new3(i,:))./length(new3(i,:)); %Inverse DFFT for each column
end
new2=(new2/max(max(new2)));

end

%Helper function to calculate the inverse DFFT of the Image
function X=idfft_helper(x)
N=length(x);

if N==1
    X(1)=x(1);
else
    xe=x(1:2:N);
    xo=x(2:2:N);
    X(1:N/2)=idfft_helper(xe);
    X(N/2+1:N)=idfft_helper(xo);
    for k=1:N/2
        t=X(k);
        X(k)=(t + (exp(1i*2*pi*(k-1)/N)*X((k+(N/2)))));
        X(k+(N/2))=(t - (exp(1i*2*pi*(k-1)/N)*X(k+(N/2))));
    end 
   
end
end

%Function that calculates the hybrid image
function J=hybridImage(filename,filename2)
    img1 = imread(filename);
    img2 = imread(filename2);
    
    img1=rgb2gray(img1);
    img2=rgb2gray(img2);
    imshow(img1);
    figure;
    imshow(img2);
    figure;
    %Resizing the image so that the row and column size is a power of 2
    img1=imresize(img1,[512 512]); 
    img2=imresize(img2,[512 512]);
    
    dog = fftshift1(dfft(double(img1)));
    cat = fftshift1(dfft(double(img2)));
    [m,n] = size(img1);
    h = fspecial('gaussian', [m n], 20); %low pass gaussian filter
    h1 = 1-h;
    h = h./max(max(h));
    h1 = h1./max(max(h1));
    dog=dog.*h;
    cat=cat.*(h1);
    J_=dog+cat;
    J = (idfft(ifftshift1(J_)));

end
