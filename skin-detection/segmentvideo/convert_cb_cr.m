function [ cb, cr ] = convert_cb_cr( folder )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here

cb = [];
cr = [];

files = dir(fullfile(folder, '*.jpg'));
for file = files'
    [cb1, cr1] = ChromaDist(file);
    
    cb = [cb cb1];
    cr = [cr cr1];
end

end

