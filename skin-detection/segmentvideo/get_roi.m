function roi = get_roi(frame, bbox)
%GET_ROI computes the region of interest and validates it

    % calculating region of interest
    roi = [bbox(1) - bbox(3), bbox(2), bbox(3)*3, bbox(4)*3];
    
    % validation 1 - no negative pixel
    if roi(1) < 1
        roi(1) = 1;
    end
    
    % validation 2 - roi shouldnt be wider than original frame
    if roi(1) + roi(3) > size(frame, 2)
        roi(3) = size(frame, 2) - roi(1);
    end
    
    % validation 3 - roi shouldnt be taller than original frame
    if roi(2) + roi(4) > size(frame, 1)
        roi(4) = size(frame, 1) - roi(2);
    end
end

