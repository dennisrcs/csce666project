function [out, bin] = generate_skinmap(image, bmean, rmean, brcov)
%GENERATE_SKINMAP Produce a skinmap of a given image. Highlights patches of
%"skin" like pixels. Can be used in face detection, gesture recognition,
%and other HCI applications.

%   The function reads an image file given by the input parameter string
%   filename, read by the MATLAB function 'imread'.
%   out - contains the skinmap overlayed onto the image with skin pixels
%   marked in blue color.
%   bin - contains the binary skinmap, with skin pixels as '1'.
%
%   Example usage:
%       [out bin] = generate_skinmap('nadal.jpg');
%       generate_skinmap('nadal.jpg');
%
%   Gaurav Jain, 2010.
    
    if nargin > 4 | nargin < 4
        error('usage: generate_skinmap(filename)');
    end;
    
    %Read the image, and capture the dimensions
    img_orig = image;
    height = size(img_orig,1);
    width = size(img_orig,2);
    
    %Initialize the output images
    out = img_orig;
    bin = zeros(height,width);
    
    %Apply Grayworld Algorithm for illumination compensation
    img = grayworld(img_orig);    
    
    %Convert the image from RGB to YCbCr
    img_ycbcr = rgb2ycbcr(img);
    Cb = img_ycbcr(:,:,2);
    Cr = img_ycbcr(:,:,3);
    
    %Detect Skin
    [r,c,v] = find(Cb>=77 & Cb<=127 & Cr>=133 & Cr<=173);
    numind = size(r,1);
    
    %Mark Skin Pixels
    for i=1:numind
        out(r(i),c(i),:) = [0 0 255];
        bin(r(i),c(i)) = 1;
    end
    
    
    %calculate based on gaussian model
    dim = size(image);
    skin1 = zeros(dim(1), dim(2));
    for i = 1:dim(1)
       for j = 1:dim(2)
          cbx = double(Cb(i,j));
          crx = double(Cr(i,j));
          x = [(cbx-bmean); (crx-rmean)];
          skin1(i,j) = exp(-0.5* x'*inv(brcov)* x);
       end
    end

    lpf= 1/9*ones(3);
    skin1 = filter2(lpf,skin1);
    skin1 = skin1./max(max(skin1));
    skin2 = zeros(i,j);
    skin2(find(skin1>0.4)) = 1;
    
    
    bin = double(bin & skin2);
    %imshow(img_orig);
    %figure; imshow(out);
    %figure; imshow(bin);
end