%{
Author: Prajesh Jhumkhawala
%}

function[]=CLAHE(filename)
%{
    This is an adaptation to the original histogram equalization method.
    This approach was suggested by Stephen M. Pizer, R. Eugene Johnston, James P. Ericksen,
    Bonnie C. Yankaskas, Keith E. Muller in the paper Contrast-Limited Adaptive Histogram Equalization:
    Speed and Effectiveness (http://ieeexplore.ieee.org/xpl/login.jsp?tp=&arnumber=109340&url=http%3A%2F%2Fieeexplore.ieee.org%2Fxpls%2Fabs_all.jsp%3Farnumber%3D109340).
    
%}

close all;
%Reading the image, resizing the image and then converting it to gray-scale
img=imread(filename); 
resized_image=imresize(img,[512 512]);
img_gray=0.21*resized_image(:,:,1) + 0.72*resized_image(:,:,2) + 0.07*resized_image(:,:,3);
imshow(img_gray);
title('Gray image');

img_pad=double(padarray(img_gray,[8 8],'symmetric')); %Padding the image 
figure;
[row,col]=size(img_pad); %Storing the row and column number of the padded image
clip_limit=0.1; %Setting the clip limit
eqcount=zeros(row,col);
y_size=1;
x_size=1;
while(y_size<col)
    %Calculating the pixel count for every conextual area
    for x=x_size:x_size+16;
        for y=y_size:y_size+16;
            eqcount(x,y)=0;
            for i=x_size:x_size+16;
                for j=y_size:y_size+16;
                    if img_pad(i,j)==img_pad(x,y)
                        eqcount(x,y)=eqcount(x,y) + 1;
                    end
                end
            end
        end
    end
    if x_size==1;
        x_size=x_size+15;
    else
        x_size=x_size+16;
    end
    if x_size>=row
        x_size=1;
        if y_size==1;
            y_size=y_size+15;
        else
            y_size=y_size+16;
        end
    end    
end
output=(zeros(row,row));
y_size=1;
x_size=1;
while(y_size<col)
    %Calculating the various values for the computing CLAHE
    for x=x_size:x_size+16;
        for y=y_size:y_size+16;
            cliptotal=0;
            partialrank=0;
            for i=x_size:x_size+16;
                for j=y_size:y_size+16;
                    if eqcount(i,j) > clip_limit
                        incr=clip_limit/eqcount(i,j);
                    else
                        incr=1;
                    end
                    cliptotal=cliptotal+(1-incr);
                    if img_pad(x,y) >= img_pad(i,j)
                        partialrank = partialrank + incr;
                    end
                end
            end
            redistr = (cliptotal / (16*16)) * img_pad(x,y);
            output(x,y) = partialrank + redistr;
        end
    end
    if x_size==1;
        x_size=x_size+15;
    else
        x_size=x_size+16;
    end
    if x_size==row
        x_size=1;
        if y_size==1;
            y_size=y_size+15;
        else
            y_size=y_size+16;
        end
    end
end
    u=uint8(output);
    imshow(u);
    title('CLAHE');
end