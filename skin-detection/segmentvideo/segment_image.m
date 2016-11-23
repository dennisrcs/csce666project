function new_image = segment_image(face, roi)
%IMAGE_KMEANS Segments the image using kmeans

    % loading image
    skin = get_face_skincolor(face);
    fullimg = roi;

    % initializing
    width = size(fullimg, 1);
    height = size(fullimg, 2);
    img = reshape(fullimg, [width*height, 3]);
    img_size = size(img, 1);

    % euclidean distance lambda function
    ed = @(x,y) sqrt(sum((x - y) .^ 2));

    % k-means
    [clusters, cent] = kmeans(double(img), 10, 'MaxIter', 200);

    % segmenting image
    new_image = zeros(width*height, 3);
    for i = 1:img_size
        pixel = cent(clusters(i),:);
        d = ed(skin, pixel);
        if d < (50/256)
            new_image(i,:) = [1,1,1];
        else
            new_image(i,:) = [0,0,0];
        end
    end

    % reshape image
    new_image = reshape(new_image, [width, height, 3]);

end

