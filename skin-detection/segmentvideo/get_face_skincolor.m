function skin_centroid = get_face_skincolor(face)
%GET_FACE_SKINCOLOR Get the most common color on the face

    % initializing
    width = size(face, 1);
    height = size(face, 2);
    img = reshape(face, [width*height, 3]);
    img_size = size(img, 1);

    % k-means
    [clusters, cent] = kmeans(double(img), 3, 'MaxIter', 200);

    new_image = zeros(width*height, 3);
    % assigning random clusters
    for i = 1:img_size
        new_image(i,:) = cent(clusters(i),:);
    end

    % getting the most common color (skin)
    [values, indices] = hist(clusters, unique(clusters));
    [~, idx] = max(values);
    skin_centroid = cent(indices(idx),:);
end

