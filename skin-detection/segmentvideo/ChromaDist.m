function [cb, cr] = ChromaDist(file)
% return the chromatic components of the image
% low pass filtering is carried out to remove noise


im = imread(fullfile(file.folder, file.name));
imycc = rgb2ycbcr(im);
lpf = 1/9 * ones(3);
cb = imycc(:,:,2);
cb = filter2(lpf, cb);
cb = reshape(cb, 1, prod(size(cb)));
cr = imycc(:,:,3);
cr = filter2(lpf, cr);
cr = reshape(cr, 1, prod(size(cr)));

end