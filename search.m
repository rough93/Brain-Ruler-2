function [point,distance] = search(subject_brain,EEG_list,res_x,res_y,res_z,searchend)

% The algorithm works by querying a series of points in a cube around every
% other two previously queried points that lie on the outside face of the
% queried box. It also checks each corner if not included to ensure every
% point is checked. It must first manually checking a 9 coordinate box
% around the initial point and then switches to checking every other 2 in
% an expanding field.

% create a matrix to save the coordinates of the cortex points closest to
% the EEG points. format (x y z);(x2 y2 z2);etc.
point = zeros(19,3);

% create a matrix to save the distances between the saved points and the
% EEG points. format (d);(d2);etc.
distance = zeros(19,1);
% upper_buffer = zeros(size(subject_brain,1),size(subject_brain,2),30);
% subject_brain = cat(3,upper_buffer,subject_brain);
subject_brain = int8(subject_brain);
for iv = 1:searchend
    fprintf('\nSearching for closest point to input\n')
    % save search1.mat point
    coordinate_list = ones(70000,3);
    value_list = zeros(70000,1);
    max_Coordinates = zeros(size(coordinate_list,1),3);
    max_Value = zeros(size(coordinate_list,1),1);
    distances = zeros(size(coordinate_list,1),1);
    x = EEG_list(iv,1);
    y = EEG_list(iv,2);
    z = EEG_list(iv,3);
    it = 1;

    if iv == 1
        for iii = z-35:1:z
            for ii = y-30:1:y+30
                for i = x-30:1:x+30

                    if i>size(subject_brain,1)
                        xi = size(subject_brain,1);
                    elseif i<1
                        xi = 1;
                    else
                        xi = i;
                    end

                    if ii>size(subject_brain,2)
                        yii = size(subject_brain,2);
                    elseif ii<1
                        yii = 1;
                    else
                        yii = ii;
                    end

                    if iii>size(subject_brain,3)
                        ziii = size(subject_brain,3);
                    elseif iii<1
                        ziii = 1;
                    else
                        ziii = iii;
                    end

                    coordinate_list(it,:) = [xi,yii,ziii];
                    value_list(it) = subject_brain(xi,yii,ziii);

                    if subject_brain(xi,yii,ziii) > 150
                        max_Coordinates(it,:) = [coordinate_list(it,1),coordinate_list(it,2),coordinate_list(it,3)];
                        max_Value(it) = subject_brain(coordinate_list(it,1),coordinate_list(it,2),coordinate_list(it,3));
                        distances(it) = sqrt(...
                            (((EEG_list(iv,1)-coordinate_list(it,1))*res_x)^2)+...
                            (((EEG_list(iv,2)-coordinate_list(it,2))*res_y)^2)+...
                            (((EEG_list(iv,3)-coordinate_list(it,3))*res_z)^2));
                    else
                        distances(it) = 100;
                    end
                    it = it+1;
                end
            end
        end
        for dist = 1:size(distances,1)
            if distances(dist) == 0
                distances(dist) = 100;
            end
        end

        [val,idx] = min(distances);
        point(iv,:) = coordinate_list(idx,:);
        distance(iv) = val;

    elseif iv == 2
        for iii = z-35:1:z
            for ii = y-30:1:y
                for i = x-30:1:x+30

                    if i>size(subject_brain,1)
                        xi = size(subject_brain,1);
                    elseif i<1
                        xi = 1;
                    else
                        xi = i;
                    end

                    if ii>size(subject_brain,2)
                        yii = size(subject_brain,2);
                    elseif ii<1
                        yii = 1;
                    else
                        yii = ii;
                    end

                    if iii>size(subject_brain,3)
                        ziii = size(subject_brain,3);
                    elseif iii<1
                        ziii = 1;
                    else
                        ziii = iii;
                    end

                    coordinate_list(it,:) = [xi,yii,ziii];
                    value_list(it) = subject_brain(xi,yii,ziii);

                    if subject_brain(xi,yii,ziii) > 150
                        max_Coordinates(it,:) = [coordinate_list(it,1),coordinate_list(it,2),coordinate_list(it,3)];
                        max_Value(it) = subject_brain(coordinate_list(it,1),coordinate_list(it,2),coordinate_list(it,3));
                        distances(it) = sqrt(...
                            (((EEG_list(iv,1)-coordinate_list(it,1))*res_x)^2)+...
                            (((EEG_list(iv,2)-coordinate_list(it,2))*res_y)^2)+...
                            (((EEG_list(iv,3)-coordinate_list(it,3))*res_z)^2));
                    else
                        distances(it) = 100;
                    end
                    it = it+1;
                end
            end
        end
        for dist = 1:size(distances,1)
            if distances(dist) == 0
                distances(dist) = 100;
            end
        end

        [val,idx] = min(distances);
        point(iv,:) = coordinate_list(idx,:);
        distance(iv) = val;
    elseif iv == 3
        for iii = z-10:1:z+10
            for ii = y-50:1:y
                for i = x-30:1:x+30

                    if i>size(subject_brain,1)
                        xi = size(subject_brain,1);
                    elseif i<1
                        xi = 1;
                    else
                        xi = i;
                    end

                    if ii>size(subject_brain,2)
                        yii = size(subject_brain,2);
                    elseif ii<1
                        yii = 1;
                    else
                        yii = ii;
                    end

                    if iii>size(subject_brain,3)
                        ziii = size(subject_brain,3);
                    elseif iii<1
                        ziii = 1;
                    else
                        ziii = iii;
                    end

                    coordinate_list(it,:) = [xi,yii,ziii];
                    value_list(it) = subject_brain(xi,yii,ziii);

                    if subject_brain(xi,yii,ziii) > 150
                        max_Coordinates(it,:) = [coordinate_list(it,1),coordinate_list(it,2),coordinate_list(it,3)];
                        max_Value(it) = subject_brain(coordinate_list(it,1),coordinate_list(it,2),coordinate_list(it,3));
                        distances(it) = sqrt(...
                            (((EEG_list(iv,1)-coordinate_list(it,1))*res_x)^2)+...
                            (((EEG_list(iv,2)-coordinate_list(it,2))*res_y)^2)+...
                            (((EEG_list(iv,3)-coordinate_list(it,3))*res_z)^2));
                    else
                        distances(it) = 100;
                    end
                    it = it+1;
                end
            end
        end
        for dist = 1:size(distances,1)
            if distances(dist) == 0
                distances(dist) = 100;
            end
        end

        [val,idx] = min(distances);
        point(iv,:) = coordinate_list(idx,:);
        distance(iv) = val;
    elseif iv == 4
        for iii = z-35:1:z
            for ii = y-30:1:y+10
                for i = x-30:1:x+10

                    if i>size(subject_brain,1)
                        xi = size(subject_brain,1);
                    elseif i<1
                        xi = 1;
                    else
                        xi = i;
                    end

                    if ii>size(subject_brain,2)
                        yii = size(subject_brain,2);
                    elseif ii<1
                        yii = 1;
                    else
                        yii = ii;
                    end

                    if iii>size(subject_brain,3)
                        ziii = size(subject_brain,3);
                    elseif iii<1
                        ziii = 1;
                    else
                        ziii = iii;
                    end

                    coordinate_list(it,:) = [xi,yii,ziii];
                    value_list(it) = subject_brain(xi,yii,ziii);

                    if subject_brain(xi,yii,ziii) > 150
                        max_Coordinates(it,:) = [coordinate_list(it,1),coordinate_list(it,2),coordinate_list(it,3)];
                        max_Value(it) = subject_brain(coordinate_list(it,1),coordinate_list(it,2),coordinate_list(it,3));
                        distances(it) = sqrt(...
                            (((EEG_list(iv,1)-coordinate_list(it,1))*res_x)^2)+...
                            (((EEG_list(iv,2)-coordinate_list(it,2))*res_y)^2)+...
                            (((EEG_list(iv,3)-coordinate_list(it,3))*res_z)^2));
                    else
                        distances(it) = 100;
                    end
                    it = it+1;
                end
            end
        end
        for dist = 1:size(distances,1)
            if distances(dist) == 0
                distances(dist) = 100;
            end
        end

        [val,idx] = min(distances);
        point(iv,:) = coordinate_list(idx,:);
        distance(iv) = val;
    elseif iv ==5
        for iii = z-30:1:z+30
            for ii = y-30:1:y+30
                for i = x-50:1:x

                    if i>size(subject_brain,1)
                        xi = size(subject_brain,1);
                    elseif i<1
                        xi = 1;
                    else
                        xi = i;
                    end

                    if ii>size(subject_brain,2)
                        yii = size(subject_brain,2);
                    elseif ii<1
                        yii = 1;
                    else
                        yii = ii;
                    end

                    if iii>size(subject_brain,3)
                        ziii = size(subject_brain,3);
                    elseif iii<1
                        ziii = 1;
                    else
                        ziii = iii;
                    end

                    coordinate_list(it,:) = [xi,yii,ziii];
                    value_list(it) = subject_brain(xi,yii,ziii);

                    if subject_brain(xi,yii,ziii) > 150
                        max_Coordinates(it,:) = [coordinate_list(it,1),coordinate_list(it,2),coordinate_list(it,3)];
                        max_Value(it) = subject_brain(coordinate_list(it,1),coordinate_list(it,2),coordinate_list(it,3));
                        distances(it) = sqrt(...
                            (((EEG_list(iv,1)-coordinate_list(it,1))*res_x)^2)+...
                            (((EEG_list(iv,2)-coordinate_list(it,2))*res_y)^2)+...
                            (((EEG_list(iv,3)-coordinate_list(it,3))*res_z)^2));
                    else
                        distances(it) = 100;
                    end
                    it = it+1;
                end
            end
        end
        for dist = 1:size(distances,1)
            if distances(dist) == 0
                distances(dist) = 100;
            end
        end

        [val,idx] = min(distances);
        point(iv,:) = coordinate_list(idx,:);
        distance(iv) = val;
    elseif iv ==6
        for iii = z-30:1:z+30
            for ii = y-50:1:y+30
                for i = x-50:1:x+30

                    if i>size(subject_brain,1)
                        xi = size(subject_brain,1);
                    elseif i<1
                        xi = 1;
                    else
                        xi = i;
                    end

                    if ii>size(subject_brain,2)
                        yii = size(subject_brain,2);
                    elseif ii<1
                        yii = 1;
                    else
                        yii = ii;
                    end

                    if iii>size(subject_brain,3)
                        ziii = size(subject_brain,3);
                    elseif iii<1
                        ziii = 1;
                    else
                        ziii = iii;
                    end

                    coordinate_list(it,:) = [xi,yii,ziii];
                    value_list(it) = subject_brain(xi,yii,ziii);

                    if subject_brain(xi,yii,ziii) > 150
                        max_Coordinates(it,:) = [coordinate_list(it,1),coordinate_list(it,2),coordinate_list(it,3)];
                        max_Value(it) = subject_brain(coordinate_list(it,1),coordinate_list(it,2),coordinate_list(it,3));
                        distances(it) = sqrt(...
                            (((EEG_list(iv,1)-coordinate_list(it,1))*res_x)^2)+...
                            (((EEG_list(iv,2)-coordinate_list(it,2))*res_y)^2)+...
                            (((EEG_list(iv,3)-coordinate_list(it,3))*res_z)^2));
                    else
                        distances(it) = 100;
                    end
                    it = it+1;
                end
            end
        end
        for dist = 1:size(distances,1)
            if distances(dist) == 0
                distances(dist) = 100;
            end
        end

        [val,idx] = min(distances);
        point(iv,:) = coordinate_list(idx,:);
        distance(iv) = val;
    elseif iv ==7
        for iii = z-30:1:z+30
            for ii = y-50:1:y+10
                for i = x-50:1:x+10

                    if i>size(subject_brain,1)
                        xi = size(subject_brain,1);
                    elseif i<1
                        xi = 1;
                    else
                        xi = i;
                    end

                    if ii>size(subject_brain,2)
                        yii = size(subject_brain,2);
                    elseif ii<1
                        yii = 1;
                    else
                        yii = ii;
                    end

                    if iii>size(subject_brain,3)
                        ziii = size(subject_brain,3);
                    elseif iii<1
                        ziii = 1;
                    else
                        ziii = iii;
                    end

                    coordinate_list(it,:) = [xi,yii,ziii];
                    value_list(it) = subject_brain(xi,yii,ziii);

                    if subject_brain(xi,yii,ziii) > 150
                        max_Coordinates(it,:) = [coordinate_list(it,1),coordinate_list(it,2),coordinate_list(it,3)];
                        max_Value(it) = subject_brain(coordinate_list(it,1),coordinate_list(it,2),coordinate_list(it,3));
                        distances(it) = sqrt(...
                            (((EEG_list(iv,1)-coordinate_list(it,1))*res_x)^2)+...
                            (((EEG_list(iv,2)-coordinate_list(it,2))*res_y)^2)+...
                            (((EEG_list(iv,3)-coordinate_list(it,3))*res_z)^2));
                    else
                        distances(it) = 100;
                    end
                    it = it+1;
                end
            end
        end
        for dist = 1:size(distances,1)
            if distances(dist) == 0
                distances(dist) = 100;
            end
        end

        [val,idx] = min(distances);
        point(iv,:) = coordinate_list(idx,:);
        distance(iv) = val;
    elseif iv ==8
        for iii = z-30:1:z+30
            for ii = y-35:1:y+35
                for i = x-30:1:x+30

                    if i>size(subject_brain,1)
                        xi = size(subject_brain,1);
                    elseif i<1
                        xi = 1;
                    else
                        xi = i;
                    end

                    if ii>size(subject_brain,2)
                        yii = size(subject_brain,2);
                    elseif ii<1
                        yii = 1;
                    else
                        yii = ii;
                    end

                    if iii>size(subject_brain,3)
                        ziii = size(subject_brain,3);
                    elseif iii<1
                        ziii = 1;
                    else
                        ziii = iii;
                    end

                    coordinate_list(it,:) = [xi,yii,ziii];
                    value_list(it) = subject_brain(xi,yii,ziii);

                    if subject_brain(xi,yii,ziii) > 150
                        max_Coordinates(it,:) = [coordinate_list(it,1),coordinate_list(it,2),coordinate_list(it,3)];
                        max_Value(it) = subject_brain(coordinate_list(it,1),coordinate_list(it,2),coordinate_list(it,3));
                        distances(it) = sqrt(...
                            (((EEG_list(iv,1)-coordinate_list(it,1))*res_x)^2)+...
                            (((EEG_list(iv,2)-coordinate_list(it,2))*res_y)^2)+...
                            (((EEG_list(iv,3)-coordinate_list(it,3))*res_z)^2));
                    else
                        distances(it) = 100;
                    end
                    it = it+1;
                end
            end
        end
        for dist = 1:size(distances,1)
            if distances(dist) == 0
                distances(dist) = 100;
            end
        end

        [val,idx] = min(distances);
        point(iv,:) = coordinate_list(idx,:);
        distance(iv) = val;
    elseif iv ==9
        for iii = z-35:1:z+10
            for ii = y-30:1:y+30
                for i = x-30:1:x+30

                    if i>size(subject_brain,1)
                        xi = size(subject_brain,1);
                    elseif i<1
                        xi = 1;
                    else
                        xi = i;
                    end

                    if ii>size(subject_brain,2)
                        yii = size(subject_brain,2);
                    elseif ii<1
                        yii = 1;
                    else
                        yii = ii;
                    end

                    if iii>size(subject_brain,3)
                        ziii = size(subject_brain,3);
                    elseif iii<1
                        ziii = 1;
                    else
                        ziii = iii;
                    end

                    coordinate_list(it,:) = [xi,yii,ziii];
                    value_list(it) = subject_brain(xi,yii,ziii);

                    if subject_brain(xi,yii,ziii) > 150
                        max_Coordinates(it,:) = [coordinate_list(it,1),coordinate_list(it,2),coordinate_list(it,3)];
                        max_Value(it) = subject_brain(coordinate_list(it,1),coordinate_list(it,2),coordinate_list(it,3));
                        distances(it) = sqrt(...
                            (((EEG_list(iv,1)-coordinate_list(it,1))*res_x)^2)+...
                            (((EEG_list(iv,2)-coordinate_list(it,2))*res_y)^2)+...
                            (((EEG_list(iv,3)-coordinate_list(it,3))*res_z)^2));
                    else
                        distances(it) = 100;
                    end
                    it = it+1;
                end
            end
        end
        for dist = 1:size(distances,1)
            if distances(dist) == 0
                distances(dist) = 100;
            end
        end

        [val,idx] = min(distances);
        point(iv,:) = coordinate_list(idx,:);
        distance(iv) = val;
    elseif iv ==10
        for iii = z-30:1:z+30
            for ii = y-30:1:y+30
                for i = x:1:x+65

                    if i>size(subject_brain,1)
                        xi = size(subject_brain,1);
                    elseif i<1
                        xi = 1;
                    else
                        xi = i;
                    end

                    if ii>size(subject_brain,2)
                        yii = size(subject_brain,2);
                    elseif ii<1
                        yii = 1;
                    else
                        yii = ii;
                    end

                    if iii>size(subject_brain,3)
                        ziii = size(subject_brain,3);
                    elseif iii<1
                        ziii = 1;
                    else
                        ziii = iii;
                    end

                    coordinate_list(it,:) = [xi,yii,ziii];
                    value_list(it) = subject_brain(xi,yii,ziii);

                    if subject_brain(xi,yii,ziii) > 150
                        max_Coordinates(it,:) = [coordinate_list(it,1),coordinate_list(it,2),coordinate_list(it,3)];
                        max_Value(it) = subject_brain(coordinate_list(it,1),coordinate_list(it,2),coordinate_list(it,3));
                        distances(it) = sqrt(...
                            (((EEG_list(iv,1)-coordinate_list(it,1))*res_x)^2)+...
                            (((EEG_list(iv,2)-coordinate_list(it,2))*res_y)^2)+...
                            (((EEG_list(iv,3)-coordinate_list(it,3))*res_z)^2));
                    else
                        distances(it) = 100;
                    end
                    it = it+1;
                end
            end
        end
        for dist = 1:size(distances,1)
            if distances(dist) == 0
                distances(dist) = 100;
            end
        end

        [val,idx] = min(distances);
        point(iv,:) = coordinate_list(idx,:);
        distance(iv) = val;
    elseif iv ==11
        for iii = z-30:1:z+30
            for ii = y-50:1:y+10
                for i = x-30:1:x+30

                    if i>size(subject_brain,1)
                        xi = size(subject_brain,1);
                    elseif i<1
                        xi = 1;
                    else
                        xi = i;
                    end

                    if ii>size(subject_brain,2)
                        yii = size(subject_brain,2);
                    elseif ii<1
                        yii = 1;
                    else
                        yii = ii;
                    end

                    if iii>size(subject_brain,3)
                        ziii = size(subject_brain,3);
                    elseif iii<1
                        ziii = 1;
                    else
                        ziii = iii;
                    end

                    coordinate_list(it,:) = [xi,yii,ziii];
                    value_list(it) = subject_brain(xi,yii,ziii);

                    if subject_brain(xi,yii,ziii) > 150
                        max_Coordinates(it,:) = [coordinate_list(it,1),coordinate_list(it,2),coordinate_list(it,3)];
                        max_Value(it) = subject_brain(coordinate_list(it,1),coordinate_list(it,2),coordinate_list(it,3));
                        distances(it) = sqrt(...
                            (((EEG_list(iv,1)-coordinate_list(it,1))*res_x)^2)+...
                            (((EEG_list(iv,2)-coordinate_list(it,2))*res_y)^2)+...
                            (((EEG_list(iv,3)-coordinate_list(it,3))*res_z)^2));
                    else
                        distances(it) = 100;
                    end
                    it = it+1;
                end
            end
        end
        for dist = 1:size(distances,1)
            if distances(dist) == 0
                distances(dist) = 100;
            end
        end

        [val,idx] = min(distances);
        point(iv,:) = coordinate_list(idx,:);
        distance(iv) = val;
    elseif iv ==12
        for iii = z-30:1:z+30
            for ii = y-50:1:y+10
                for i = x-10:1:x+65

                    if i>size(subject_brain,1)
                        xi = size(subject_brain,1);
                    elseif i<1
                        xi = 1;
                    else
                        xi = i;
                    end

                    if ii>size(subject_brain,2)
                        yii = size(subject_brain,2);
                    elseif ii<1
                        yii = 1;
                    else
                        yii = ii;
                    end

                    if iii>size(subject_brain,3)
                        ziii = size(subject_brain,3);
                    elseif iii<1
                        ziii = 1;
                    else
                        ziii = iii;
                    end

                    coordinate_list(it,:) = [xi,yii,ziii];
                    value_list(it) = subject_brain(xi,yii,ziii);

                    if subject_brain(xi,yii,ziii) > 150
                        max_Coordinates(it,:) = [coordinate_list(it,1),coordinate_list(it,2),coordinate_list(it,3)];
                        max_Value(it) = subject_brain(coordinate_list(it,1),coordinate_list(it,2),coordinate_list(it,3));
                        distances(it) = sqrt(...
                            (((EEG_list(iv,1)-coordinate_list(it,1))*res_x)^2)+...
                            (((EEG_list(iv,2)-coordinate_list(it,2))*res_y)^2)+...
                            (((EEG_list(iv,3)-coordinate_list(it,3))*res_z)^2));
                    else
                        distances(it) = 100;
                    end
                    it = it+1;
                end
            end
        end
        for dist = 1:size(distances,1)
            if distances(dist) == 0
                distances(dist) = 100;
            end
        end

        [val,idx] = min(distances);
        point(iv,:) = coordinate_list(idx,:);
        distance(iv) = val;
    elseif iv ==13
        for iii = z-35:1:z+30
            for ii = y-30:1:y+30
                for i = x-30:1:x+30

                    if i>size(subject_brain,1)
                        xi = size(subject_brain,1);
                    elseif i<1
                        xi = 1;
                    else
                        xi = i;
                    end

                    if ii>size(subject_brain,2)
                        yii = size(subject_brain,2);
                    elseif ii<1
                        yii = 1;
                    else
                        yii = ii;
                    end

                    if iii>size(subject_brain,3)
                        ziii = size(subject_brain,3);
                    elseif iii<1
                        ziii = 1;
                    else
                        ziii = iii;
                    end

                    coordinate_list(it,:) = [xi,yii,ziii];
                    value_list(it) = subject_brain(xi,yii,ziii);

                    if subject_brain(xi,yii,ziii) > 150
                        max_Coordinates(it,:) = [coordinate_list(it,1),coordinate_list(it,2),coordinate_list(it,3)];
                        max_Value(it) = subject_brain(coordinate_list(it,1),coordinate_list(it,2),coordinate_list(it,3));
                        distances(it) = sqrt(...
                            (((EEG_list(iv,1)-coordinate_list(it,1))*res_x)^2)+...
                            (((EEG_list(iv,2)-coordinate_list(it,2))*res_y)^2)+...
                            (((EEG_list(iv,3)-coordinate_list(it,3))*res_z)^2));
                    else
                        distances(it) = 100;
                    end
                    it = it+1;
                end
            end
        end
        for dist = 1:size(distances,1)
            if distances(dist) == 0
                distances(dist) = 100;
            end
        end

        [val,idx] = min(distances);
        point(iv,:) = coordinate_list(idx,:);
        distance(iv) = val;
    elseif iv ==14
        for iii = z-35:1:z+30
            for ii = y-30:1:y+30
                for i = x-30:1:x+30

                    if i>size(subject_brain,1)
                        xi = size(subject_brain,1);
                    elseif i<1
                        xi = 1;
                    else
                        xi = i;
                    end

                    if ii>size(subject_brain,2)
                        yii = size(subject_brain,2);
                    elseif ii<1
                        yii = 1;
                    else
                        yii = ii;
                    end

                    if iii>size(subject_brain,3)
                        ziii = size(subject_brain,3);
                    elseif iii<1
                        ziii = 1;
                    else
                        ziii = iii;
                    end

                    coordinate_list(it,:) = [xi,yii,ziii];
                    value_list(it) = subject_brain(xi,yii,ziii);

                    if subject_brain(xi,yii,ziii) > 150
                        max_Coordinates(it,:) = [coordinate_list(it,1),coordinate_list(it,2),coordinate_list(it,3)];
                        max_Value(it) = subject_brain(coordinate_list(it,1),coordinate_list(it,2),coordinate_list(it,3));
                        distances(it) = sqrt(...
                            (((EEG_list(iv,1)-coordinate_list(it,1))*res_x)^2)+...
                            (((EEG_list(iv,2)-coordinate_list(it,2))*res_y)^2)+...
                            (((EEG_list(iv,3)-coordinate_list(it,3))*res_z)^2));
                    else
                        distances(it) = 100;
                    end
                    it = it+1;
                end
            end
        end
        for dist = 1:size(distances,1)
            if distances(dist) == 0
                distances(dist) = 100;
            end
        end

        [val,idx] = min(distances);
        point(iv,:) = coordinate_list(idx,:);
        distance(iv) = val;
    elseif iv ==15
        for iii = z-30:1:z+30
            for ii = y:1:y+65
                for i = x-30:1:x+30

                    if i>size(subject_brain,1)
                        xi = size(subject_brain,1);
                    elseif i<1
                        xi = 1;
                    else
                        xi = i;
                    end

                    if ii>size(subject_brain,2)
                        yii = size(subject_brain,2);
                    elseif ii<1
                        yii = 1;
                    else
                        yii = ii;
                    end

                    if iii>size(subject_brain,3)
                        ziii = size(subject_brain,3);
                    elseif iii<1
                        ziii = 1;
                    else
                        ziii = iii;
                    end

                    coordinate_list(it,:) = [xi,yii,ziii];
                    value_list(it) = subject_brain(xi,yii,ziii);

                    if subject_brain(xi,yii,ziii) > 150
                        max_Coordinates(it,:) = [coordinate_list(it,1),coordinate_list(it,2),coordinate_list(it,3)];
                        max_Value(it) = subject_brain(coordinate_list(it,1),coordinate_list(it,2),coordinate_list(it,3));
                        distances(it) = sqrt(...
                            (((EEG_list(iv,1)-coordinate_list(it,1))*res_x)^2)+...
                            (((EEG_list(iv,2)-coordinate_list(it,2))*res_y)^2)+...
                            (((EEG_list(iv,3)-coordinate_list(it,3))*res_z)^2));
                    else
                        distances(it) = 100;
                    end
                    it = it+1;
                end
            end
        end
        for dist = 1:size(distances,1)
            if distances(dist) == 0
                distances(dist) = 100;
            end
        end

        [val,idx] = min(distances);
        point(iv,:) = coordinate_list(idx,:);
        distance(iv) = val;

    elseif iv ==16
        for iii = z-30:1:z+30
            for ii = y-10:1:y+65
                for i = x-50:1:x+10

                    if i>size(subject_brain,1)
                        xi = size(subject_brain,1);
                    elseif i<1
                        xi = 1;
                    else
                        xi = i;
                    end

                    if ii>size(subject_brain,2)
                        yii = size(subject_brain,2);
                    elseif ii<1
                        yii = 1;
                    else
                        yii = ii;
                    end

                    if iii>size(subject_brain,3)
                        ziii = size(subject_brain,3);
                    elseif iii<1
                        ziii = 1;
                    else
                        ziii = iii;
                    end

                    coordinate_list(it,:) = [xi,yii,ziii];
                    value_list(it) = subject_brain(xi,yii,ziii);

                    if subject_brain(xi,yii,ziii) > 150
                        max_Coordinates(it,:) = [coordinate_list(it,1),coordinate_list(it,2),coordinate_list(it,3)];
                        max_Value(it) = subject_brain(coordinate_list(it,1),coordinate_list(it,2),coordinate_list(it,3));
                        distances(it) = sqrt(...
                            (((EEG_list(iv,1)-coordinate_list(it,1))*res_x)^2)+...
                            (((EEG_list(iv,2)-coordinate_list(it,2))*res_y)^2)+...
                            (((EEG_list(iv,3)-coordinate_list(it,3))*res_z)^2));
                    else
                        distances(it) = 100;
                    end
                    it = it+1;
                end
            end
        end
        for dist = 1:size(distances,1)
            if distances(dist) == 0
                distances(dist) = 100;
            end
        end

        [val,idx] = min(distances);
        point(iv,:) = coordinate_list(idx,:);
        distance(iv) = val;
    elseif iv ==17
        for iii = z-30:1:z+30
            for ii = y-30:1:y+65
                for i = x-50:1:x+10

                    if i>size(subject_brain,1)
                        xi = size(subject_brain,1);
                    elseif i<1
                        xi = 1;
                    else
                        xi = i;
                    end

                    if ii>size(subject_brain,2)
                        yii = size(subject_brain,2);
                    elseif ii<1
                        yii = 1;
                    else
                        yii = ii;
                    end

                    if iii>size(subject_brain,3)
                        ziii = size(subject_brain,3);
                    elseif iii<1
                        ziii = 1;
                    else
                        ziii = iii;
                    end

                    coordinate_list(it,:) = [xi,yii,ziii];
                    value_list(it) = subject_brain(xi,yii,ziii);

                    if subject_brain(xi,yii,ziii) > 150
                        max_Coordinates(it,:) = [coordinate_list(it,1),coordinate_list(it,2),coordinate_list(it,3)];
                        max_Value(it) = subject_brain(coordinate_list(it,1),coordinate_list(it,2),coordinate_list(it,3));
                        distances(it) = sqrt(...
                            (((EEG_list(iv,1)-coordinate_list(it,1))*res_x)^2)+...
                            (((EEG_list(iv,2)-coordinate_list(it,2))*res_y)^2)+...
                            (((EEG_list(iv,3)-coordinate_list(it,3))*res_z)^2));
                    else
                        distances(it) = 100;
                    end
                    it = it+1;
                end
            end
        end
        for dist = 1:size(distances,1)
            if distances(dist) == 0
                distances(dist) = 100;
            end
        end

        [val,idx] = min(distances);
        point(iv,:) = coordinate_list(idx,:);
        distance(iv) = val;
    elseif iv ==18
        for iii = z-30:1:z+30
            for ii = y-10:1:y+65
                for i = x-10:1:x+65

                    if i>size(subject_brain,1)
                        xi = size(subject_brain,1);
                    elseif i<1
                        xi = 1;
                    else
                        xi = i;
                    end

                    if ii>size(subject_brain,2)
                        yii = size(subject_brain,2);
                    elseif ii<1
                        yii = 1;
                    else
                        yii = ii;
                    end

                    if iii>size(subject_brain,3)
                        ziii = size(subject_brain,3);
                    elseif iii<1
                        ziii = 1;
                    else
                        ziii = iii;
                    end

                    coordinate_list(it,:) = [xi,yii,ziii];
                    value_list(it) = subject_brain(xi,yii,ziii);

                    if subject_brain(xi,yii,ziii) > 150
                        max_Coordinates(it,:) = [coordinate_list(it,1),coordinate_list(it,2),coordinate_list(it,3)];
                        max_Value(it) = subject_brain(coordinate_list(it,1),coordinate_list(it,2),coordinate_list(it,3));
                        distances(it) = sqrt(...
                            (((EEG_list(iv,1)-coordinate_list(it,1))*res_x)^2)+...
                            (((EEG_list(iv,2)-coordinate_list(it,2))*res_y)^2)+...
                            (((EEG_list(iv,3)-coordinate_list(it,3))*res_z)^2));
                    else
                        distances(it) = 100;
                    end
                    it = it+1;
                end
            end
        end
        for dist = 1:size(distances,1)
            if distances(dist) == 0
                distances(dist) = 100;
            end
        end

        [val,idx] = min(distances);
        point(iv,:) = coordinate_list(idx,:);
        distance(iv) = val;
    elseif iv ==19
        for iii = z-30:1:z+30
            for ii = y-10:1:y+65
                for i = x-10:1:x+65

                    if i>size(subject_brain,1)
                        xi = size(subject_brain,1);
                    elseif i<1
                        xi = 1;
                    else
                        xi = i;
                    end

                    if ii>size(subject_brain,2)
                        yii = size(subject_brain,2);
                    elseif ii<1
                        yii = 1;
                    else
                        yii = ii;
                    end

                    if iii>size(subject_brain,3)
                        ziii = size(subject_brain,3);
                    elseif iii<1
                        ziii = 1;
                    else
                        ziii = iii;
                    end

                    coordinate_list(it,:) = [xi,yii,ziii];
                    value_list(it) = subject_brain(xi,yii,ziii);

                    if subject_brain(xi,yii,ziii) > 150
                        max_Coordinates(it,:) = [coordinate_list(it,1),coordinate_list(it,2),coordinate_list(it,3)];
                        max_Value(it) = subject_brain(coordinate_list(it,1),coordinate_list(it,2),coordinate_list(it,3));
                        distances(it) = sqrt(...
                            (((EEG_list(iv,1)-coordinate_list(it,1))*res_x)^2)+...
                            (((EEG_list(iv,2)-coordinate_list(it,2))*res_y)^2)+...
                            (((EEG_list(iv,3)-coordinate_list(it,3))*res_z)^2));
                    else
                        distances(it) = 100;
                    end
                    it = it+1;
                end
            end
        end
        for dist = 1:size(distances,1)
            if distances(dist) == 0
                distances(dist) = 100;
            end
        end

        [val,idx] = min(distances);
        point(iv,:) = coordinate_list(idx,:);
        distance(iv) = val;
    elseif iv ==20
        for iii = z-35:1:z+10
            for ii = y-30:1:y+30
                for i = x-30:1:x+30

                    if i>size(subject_brain,1)
                        xi = size(subject_brain,1);
                    elseif i<1
                        xi = 1;
                    else
                        xi = i;
                    end

                    if ii>size(subject_brain,2)
                        yii = size(subject_brain,2);
                    elseif ii<1
                        yii = 1;
                    else
                        yii = ii;
                    end

                    if iii>size(subject_brain,3)
                        ziii = size(subject_brain,3);
                    elseif iii<1
                        ziii = 1;
                    else
                        ziii = iii;
                    end

                    coordinate_list(it,:) = [xi,yii,ziii];
                    value_list(it) = subject_brain(xi,yii,ziii);

                    if subject_brain(xi,yii,ziii) > 150
                        max_Coordinates(it,:) = [coordinate_list(it,1),coordinate_list(it,2),coordinate_list(it,3)];
                        max_Value(it) = subject_brain(coordinate_list(it,1),coordinate_list(it,2),coordinate_list(it,3));
                        distances(it) = sqrt(...
                            (((EEG_list(iv,1)-coordinate_list(it,1))*res_x)^2)+...
                            (((EEG_list(iv,2)-coordinate_list(it,2))*res_y)^2)+...
                            (((EEG_list(iv,3)-coordinate_list(it,3))*res_z)^2));
                    else
                        distances(it) = 100;
                    end
                    it = it+1;
                end
            end
        end
        for dist = 1:size(distances,1)
            if distances(dist) == 0
                distances(dist) = 100;
            end
        end

        [val,idx] = min(distances);
        point(iv,:) = coordinate_list(idx,:);
        distance(iv) = val;
    elseif iv ==21
        for iii = z-35:1:z+10
            for ii = y-30:1:y+30
                for i = x-50:1:x+30

                    if i>size(subject_brain,1)
                        xi = size(subject_brain,1);
                    elseif i<1
                        xi = 1;
                    else
                        xi = i;
                    end

                    if ii>size(subject_brain,2)
                        yii = size(subject_brain,2);
                    elseif ii<1
                        yii = 1;
                    else
                        yii = ii;
                    end

                    if iii>size(subject_brain,3)
                        ziii = size(subject_brain,3);
                    elseif iii<1
                        ziii = 1;
                    else
                        ziii = iii;
                    end

                    coordinate_list(it,:) = [xi,yii,ziii];
                    value_list(it) = subject_brain(xi,yii,ziii);

                    if subject_brain(xi,yii,ziii) > 150
                        max_Coordinates(it,:) = [coordinate_list(it,1),coordinate_list(it,2),coordinate_list(it,3)];
                        max_Value(it) = subject_brain(coordinate_list(it,1),coordinate_list(it,2),coordinate_list(it,3));
                        distances(it) = sqrt(...
                            (((EEG_list(iv,1)-coordinate_list(it,1))*res_x)^2)+...
                            (((EEG_list(iv,2)-coordinate_list(it,2))*res_y)^2)+...
                            (((EEG_list(iv,3)-coordinate_list(it,3))*res_z)^2));
                    else
                        distances(it) = 100;
                    end
                    it = it+1;
                end
            end
        end
        for dist = 1:size(distances,1)
            if distances(dist) == 0
                distances(dist) = 100;
            end
        end

        [val,idx] = min(distances);
        point(iv,:) = coordinate_list(idx,:);
        distance(iv) = val;


    end

    save search.mat
end
end
