filepath = 'video02.mp4';

% create a cascade detector object and read video
faceDetector = vision.CascadeObjectDetector();
videoFileReader = vision.VideoFileReader(filepath);
infoVideo = info(videoFileReader);

% output video configuration
outputVideo = VideoWriter('csce666project/skin-detection/segmentvideo/newfile.avi');
outputVideo.FrameRate = infoVideo.VideoFrameRate;
open(outputVideo);

while ~isDone(videoFileReader)
    % retrieving frame
    frame = step(videoFileReader);
    
    % getting face bounding box
    bbox = step(faceDetector, frame);
    
    if isempty(bbox)
        continue;
    end
    
    % computing region of interest (roi)
    [~,idx] = max(bbox(:,3));
    roi = get_roi(frame, bbox(idx,:));
    
    % cropping face bounding box and roi
    img_bbox = imcrop(frame, bbox(idx,:));
    img_roi = imcrop(frame, roi);
        
    % segmenting image
    segmented_image = segment_image(img_bbox, img_roi);
    
    % placing segmented image back to the image
    frame = zeros(size(frame,1), size(frame,2), 3);
    frame(roi(2):roi(2)+roi(4), roi(1):roi(1)+roi(3), :) = segmented_image;
    
    % write frame to video
    writeVideo(outputVideo,frame);
end

% close video
close(outputVideo);