function skin_centroid = get_face_skincolor(face)
%GET_FACE_SKINCOLOR Get the most common color on the face

    % initializing
    width = size(face, 1);
    height = size(face, 2);
    img = reshape(face, [width*height, 3]);
    imgSize = size(img, 1);

    % k-means
    [clusters, cent] = kmeans(double(img), 3, 'MaxIter', 200);

    newImage = zeros(width*height, 3);
    % retrieving segmented face image
    for i = 1:imgSize
        newImage(i,:) = cent(clusters(i),:);
    end

    % getting the most common color (skin)
    [values, indices] = hist(clusters, unique(clusters));
    [~, idx] = max(values);
    skin_centroid = cent(indices(idx),:);
end

