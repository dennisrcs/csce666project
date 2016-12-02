inputDirPath = 'input_videos/true/';
outputDirPath = 'output_videos/';

files = dir(fullfile(inputDirPath, '*.mp4'));
videoNumber = 1;
for file = files'
    % create a cascade detector object and read video
    faceDetector = vision.CascadeObjectDetector();
    videoFileReader = VideoReader(fullfile(file.folder, file.name));

    % output video configuration
    outputVideo = VideoWriter(strcat(outputDirPath, file.name, '.avi'));
    outputVideo.FrameRate = videoFileReader.FrameRate;
    open(outputVideo);
    fileID = fopen(fullfile(outputDirPath, [file.name '.txt']),'w');
    iteration = 0;
    
    %compute starting end ending frame
    frameRate = floor(videoFileReader.FrameRate);
    totalFrames = round(videoFileReader.Duration * frameRate);
    startFrame = 0;
    endFrame = totalFrames - 1;
    if(videoFileReader.Duration > 60)
        startFrame = totalFrames/2 - (30*frameRate);
        endFrame = totalFrames/2 + (30*frameRate);
    end
    
    %while ~isDone(videoFileReader) && iteration < 10
    while hasFrame(videoFileReader) && iteration <= endFrame
        % retrieving frame
        frame = readFrame(videoFileReader);
        if(iteration >= startFrame)
            fprintf('video %d: %d frame of %d frames\n', videoNumber, iteration, endFrame);
            % getting face bounding box and writing to txt file
            bbox = step(faceDetector, frame);
            fprintf(fileID, '%d ', size(bbox, 1));
            fprintf(fileID, '\n');
            % black image
            %segmentedFrame = zeros(size(frame,1), size(frame,2), 3);
            [~, segmentedFrame] = generate_skinmap(frame);
            %erode and dilate image to filter small particles
            se = strel('rectangle',[3 3]);
            segmentedFrame = imerode(segmentedFrame,se);
            segmentedFrame = imdilate(segmentedFrame,se);

            % proceed if at least one face has been found
    %         if ~isempty(bbox)
    %             for i = 1:size(bbox,1)
    %                 % computing region of interest (roi)
    %                 roi = get_roi(frame, bbox(i,:));
    % 
    %                 % cropping face bounding box and roi
    %                 imgbbox = imcrop(frame, bbox(i,:));
    %                 img_roi = imcrop(frame, roi);
    % 
    %                 % segmenting image
    %                 %segmentedImage = segment_image(imgbbox, img_roi, iteration);
    %                 
    %                 % placing segmented image back to the image
    %                 %segmentedFrame(roi(2):roi(2)+roi(4), roi(1):roi(1)+roi(3), :) = segmentedImage;              
    %                 
    %             end
    %         end

            % write segmented frame to video
            writeVideo(outputVideo, segmentedFrame);            
        end
        iteration = iteration + 1;
    end

    % close video
    close(outputVideo);
    
    %close txt file
    fclose(fileID);
    videoNumber = videoNumber + 1;
end