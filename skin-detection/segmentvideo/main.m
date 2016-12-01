inputDirPath = 'csce666project/skin-detection/segmentvideo/input_videos/';
outputDirPath = 'csce666project/skin-detection/segmentvideo/output_videos/';

files = dir(fullfile(inputDirPath, '*.mp4'));
for file = files'
    % create a cascade detector object and read video
    faceDetector = vision.CascadeObjectDetector();
    videoFileReader = vision.VideoFileReader(fullfile(file.folder, file.name));
    infoVideo = info(videoFileReader);

    % output video configuration
    outputVideo = VideoWriter(strcat(outputDirPath, file.name, '.avi'));
    outputVideo.FrameRate = infoVideo.VideoFrameRate;
    open(outputVideo);

    iteration = 0;
    while ~isDone(videoFileReader)
        % retrieving frame
        frame = step(videoFileReader);

        % getting face bounding box
        bbox = step(faceDetector, frame);
        
        % black image
        segmentedFrame = zeros(size(frame,1), size(frame,2), 3);
        
        % proceed if at least one face has been found
        if ~isempty(bbox)
            for i = 1:size(bbox,1)
                % computing region of interest (roi)
                roi = get_roi(frame, bbox(i,:));

                % cropping face bounding box and roi
                imgbbox = imcrop(frame, bbox(i,:));
                img_roi = imcrop(frame, roi);

                % segmenting image
                segmentedImage = segment_image(imgbbox, img_roi, iteration);

                % placing segmented image back to the image
                segmentedFrame(roi(2):roi(2)+roi(4), roi(1):roi(1)+roi(3), :) = segmentedImage;
            end
        end
        
        % write segmented frame to video
        writeVideo(outputVideo, segmentedFrame);
        iteration = iteration + 1;
    end

    % close video
    close(outputVideo);
end