function newImage = segment_image(face, roi, iteration)
%IMAGE_KMEANS Segments the image using kmeans

    framesToBeSkipped = 30;

    % skin color is computed in every 30 frames
    if rem(iteration, framesToBeSkipped) == 0
        skin = get_face_skincolor(face);
    else
        load('skin_cents');
    end
    
    % initializing
    width = size(roi, 1);
    height = size(roi, 2);
    img = reshape(roi, [width*height, 3]);
    imgSize = size(img, 1);

    % k-means is performed in every 30 frames
    if rem(iteration, framesToBeSkipped) == 0
        [clusters, cents] = kmeans(double(img), 10, 'MaxIter', 200);
        save('skin_cents', 'skin', 'cents');
    else
        [~, clusters] = min(pdist2(cents, double(img)));
    end
        
    % finding closest centroid
    [~, closest_idx] = min(pdist2(cents, skin));
    
    % segmenting image
    newImage = zeros(width*height, 3);
    for i = 1:imgSize
        if closest_idx == clusters(i)
            newImage(i,:) = [1,1,1];
        else
            newImage(i,:) = [0,0,0];
        end
    end

    % reshape image
    newImage = reshape(newImage, [width, height, 3]);

end

