%{
    Author: Prajesh Jhumkhawala
%}
function HOG_Feature_Matching(image1,image2)
%{
    This function is the main function which calls other sub functions to
    perform feature mathing of the two images. We have pre-identified 5 key
    points which  are the strongest feature points in the two images.
    You can also find the ky feature points by using any feature matching
    such as SURF or SIFT.
%}

img1= im2double(rgb2gray(imread(image1)));
img2= im2double(rgb2gray(imread(image2)));

%allocate matrix to hold features1 and features 2
%HOG vecs are 128 length, and we are providing 5 keypoints
%each column will be a feature vector
features1 = zeros(128,5);
features2 = zeros(128,5);
threshold=0.03;
keyPoints1 = [402 372;
    371 230;
    156 381;
    419 231;
    323 322;
    ];

keyPoints2 = [325 232;
    300 90;
    81 230;
    348 94;
    249 182;
    ];
i2=[img1 img2];



for i = 1:5
    curr = keyPoints1(i,:);
    features1(:,i) = HOG(img1,curr(1),curr(2));
    curr = keyPoints2(i,:);
    features2(:,i) = HOG(img2,curr(1),curr(2));
end
%TODO: print result in meaningful way,
%      unless using specified format, see matchFeatures description
result = matchFeatures(features1,features2,threshold);
disp(['result for Threshold: ',num2str(threshold)]);
for i=1:length(result)
    if result(i,1)==result (i,2)
        disp(['Point ',num2str(result(i,1)),' i.e. (',num2str(keyPoints1(i,:)),') correctly matched with Point ',num2str(result(i,2)),' i.e. (',num2str(keyPoints1(i,:)),')' ]);
    else
        disp(['Point ',num2str(result(i,1)),' i.e. (',num2str(keyPoints1(i,:)),') did not correctly match with Point ',num2str(result(i,2)),' i.e. (',num2str(keyPoints1(i,:)),')' ]);
        
    end
end
imshow(i2); hold on;
for i=1:length(result)
    x=result(i,1);
    y=result(i,2);
    a=[keyPoints1(x,1),704+keyPoints2(x,1)];
    b=[keyPoints1(x,2),keyPoints2(x,2)];
    if (x==y)
        plot(a,b,'Color','g');
    else
        plot(a,b,'Color','r');
        
    end
    title('Matched Features')
    
end

end




function out_vec = HOG(im, x,y)
%Function that calculates a 128 element Histogram of Gradients feature
%vector for a given keypoint (x,y) in the provided image.
%Runs the HOG algorithm centered around the point x,y and return the generated feature vector


if size(im,3)==3
    im=rgb2gray(im);
end
im=double(im);

sobel_x=[-1,0,1;-2,0,2;-1,0,1];
sobel_y=sobel_x';
Gx=imfilter(im,sobel_x);
Gy=imfilter(im,sobel_y);
magnitude=sqrt((Gx.^2)+(Gy.^2));
angle1=atan2(Gx,Gy);
angle=rad2deg(angle1);
angle=imadd(angle,180);
angle(isnan(angle))=0;
magnitude(isnan(magnitude))=0;
%Initilaizing the feature vector to an empty array
feature1=[]; 
count=1;
i=x;
j=y;
%Extarcting a 16 x 16  patch centered around the pixel
mag = magnitude(i-8 : i+8 , j-8 : j+8);
ang = angle(i-8 : i+8 , j-8 : j+8);
feature=[];
%Taking a patch of 4 x 4 from the 16 x 16 window 
for k= 0:3
    for l= 0:3
        ang1 =ang(4*k+1:4*k+4, 4*l+1:4*l+4);
        mag1  =mag(4*k+1:4*k+4, 4*l+1:4*l+4);
        histr  =zeros(1,8);
        
        %Iterations for pixels in one 4 x 4 window
        for p=1:4
            for q=1:4
                alpha=ang1(p,q);
                % Process of Binning
                if alpha>0 && alpha<=45
                    histr(1)=histr(1)+ mag1(p,q)*(45-alpha)/45;
                elseif alpha>45 && alpha<=90
                    histr(2)=histr(2)+ mag1(p,q)*(90-alpha)/45;
                elseif alpha>90 && alpha<=135
                    histr(3)=histr(3)+ mag1(p,q)*(135-alpha)/45;
                elseif alpha>135 && alpha<=180
                    histr(4)=histr(4)+ mag1(p,q)*(180-alpha)/45;
                elseif alpha>180 && alpha<=225
                    histr(5)=histr(5)+ mag1(p,q)*(225-alpha)/45;
                elseif alpha>225 && alpha<=270
                    histr(6)=histr(6)+ mag1(p,q)*(270-alpha)/45;
                elseif alpha>270 && alpha<=315
                    histr(7)=histr(7)+ mag1(p,q) *(315-alpha)/45;
                elseif alpha>315 && alpha<=360
                    histr(8)=histr(8)+ mag1(p,q)*(360-alpha)/45;
                end
            end
        end
        %Horizontal appending to make the feature vector 128 bit long
        feature=[feature histr];
    end
end
% Normalize the values
feature=feature/norm(feature);




feature(isnan(feature))=0.001; %Removing Infinitiy values
out_vec=feature;
end

function out_indicies = matchFeatures(feature1,feature2,threshold)

%Function that takes in a matrix with feature vectors as columns
%dim(features1) = 128 by n = dim(features2)
%where n is the number of feature vectors being compared.
%Output should indicate which columns (indicies) are the best matches
%between the features1 and features2. One possibility is
%dim(out_indicies) = n by 2, where n is the same as before.
%The first column could be the elements 1:n (indicies of columns of
%features1), and then for each row the element in the second column is
%the column index of the best match from features2.
%Your output does not have to be exactly of this format, but should
%clearly indicate which columns from features1 match with features2, if
%not points will be deducted.
%
%Calculates the closest match for the vectors in the columns of
%features1 to the columns of features2 and return the a matrix that
%indicates the matched indicies.Transposing th feature vector to make it 5 x 128


feature1=feature1';
feature2=feature2';
d=sqrt(sum(feature1.^2));
feature1=feature1/d;
d=sqrt(sum(feature2.^2));
feature2=feature2/d;
check=zeros(1,5);
out_indices1=zeros(5,2);
% carryig out feature matching
for i=1:length(feature1)
    for j=1:length(feature2)
        if (abs(feature1(i)-feature2(j))<threshold) &&(size(check(check==j),2)==0)
            min1=j;
            break;
        end
    end
    check(i)=min1;
    out_indices1(i,1)=i;
    out_indices1(i,2)=min1;
   
end
out_indicies=out_indices1;

end
