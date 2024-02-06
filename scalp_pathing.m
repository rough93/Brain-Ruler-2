function [EEG_list,tragus_track_true, inion_track_true, nasion_circumference_true, inion_circumference_true, tragus_circumference_true, p3p4_track_true, f3f4_track_true] = scalp_pathing(Cz,patient_head,trag,inion,circ,res_x,res_y,res_z)

fprintf('1/5 Starting Tragus track pathing\n')
tragus_track = [Cz(1) Cz(2) Cz(3)];
tragus_track_mirror = [Cz(1) Cz(2) Cz(3)];
headt = patient_head;
%tragus pathing
y = Cz(2);
for z = Cz(3)+5:-1:60
    for x = 30:Cz(1)
        if headt(x,y,z) > 10
            str = size(tragus_track,1);
            if eval(sqrt((tragus_track(str,1)-x)^2 + (tragus_track(str,2)-y)^2 + (tragus_track(str,3)-z)^2)) > 10
                headt(x,y,z) = 0;
            else
                tragus_track = [tragus_track; x y z];
                break
            end

            %tragus_track = [tragus_track; x y z];
            %break

        end
    end

end
% plot3(tragus_track(:,1),tragus_track(:,2),tragus_track(:,3), '-o')
headt = patient_head;
for z = Cz(3)+5:-1:60
    for x = size(patient_head,1)-30:-1:Cz(1)
        if headt(x,y,z) > 30
            str = size(tragus_track_mirror,1);
            if eval(sqrt((tragus_track_mirror(str,1)-x)^2 + (tragus_track_mirror(str,2)-y)^2 + (tragus_track_mirror(str,3)-z)^2)) > 10
                headt(x,y,z) = 0;
            else
                tragus_track_mirror = [tragus_track_mirror; x y z];
                break
            end
        end
    end

end
tragus_track = flip(tragus_track);
tragus_track_true = [tragus_track; tragus_track_mirror];
tragus_track_distance = zeros(size(tragus_track_true,1),1);
for i = 1:size(tragus_track_true,1)-1

    tragus_track_distance(i) = sqrt(...
        (tragus_track_true(i,1)*res_x-tragus_track_true(i+1,1)*res_x)^2+...
        (tragus_track_true(i,2)*res_y-tragus_track_true(i+1,2)*res_y)^2+...
        (tragus_track_true(i,3)*res_z-tragus_track_true(i+1,3)*res_z)^2);

end
[~,idx] = ismember(Cz,tragus_track_true);
Cz_idx_in_tragus = idx(1);

fprintf('2/5 Beginning Nasion-Inion track pathing\n')
inion_track = [Cz(1) Cz(2) Cz(3)];
inion_track_mirror = [Cz(1) Cz(2) Cz(3)];
%nasion-inion pathing
headt = patient_head;
x = Cz(1);
for z = Cz(3)+5:-1:60
    for y = 20:Cz(2)
        if headt(x,y,z) > 10
            str = size(inion_track,1);
            if eval(sqrt((inion_track(str,1)-x)^2 + (inion_track(str,2)-y)^2 + (inion_track(str,3)-z)^2)) > 10
                headt(x,y,z) = 0;
            else
                inion_track = [inion_track; x y z];
                break
            end
        end
    end

end
headt = patient_head;
for z = Cz(3)+5:-1:60
    for y = size(patient_head,2)-20:-1:Cz(2)
        if headt(x,y,z) > 10
            str = size(inion_track_mirror,1);
            if eval(sqrt((inion_track_mirror(str,1)-x)^2 + (inion_track_mirror(str,2)-y)^2 + (inion_track_mirror(str,3)-z)^2)) > 10
                headt(x,y,z) = 0;
            else
                inion_track_mirror = [inion_track_mirror; x y z];
                break
            end
        end
    end

end
inion_track = flip(inion_track);
inion_track_true = [inion_track; inion_track_mirror];
inion_track_distance = zeros(size(inion_track_true,1),1);
for i = 1:size(inion_track_true,1)-1

    inion_track_distance(i) = sqrt(...
        (inion_track_true(i,1)*res_x-inion_track_true(i+1,1)*res_x)^2+...
        (inion_track_true(i,2)*res_y-inion_track_true(i+1,2)*res_y)^2+...
        (inion_track_true(i,3)*res_z-inion_track_true(i+1,3)*res_z)^2);

end

[~,idx] = ismember(Cz,inion_track_true,'rows');
Cz_idx_in_inion = idx(1);

fprintf('3/5 Beginning inion circumference pathing\n')

ii = Cz_idx_in_inion;
tot = 0;
while tot < inion*.4*10
    tot = tot + inion_track_distance(ii);
    ii=ii+1;
end
circ_top_z_front = inion_track_true(ii,3);

ii = Cz_idx_in_inion;
tot = 0;
while tot < inion*.4*10
    tot = tot + inion_track_distance(ii-1);
    ii=ii-1;
end
circ_top_z_back_coord = inion_track_true(ii,:);
circ_top_z_back = inion_track_true(ii,3);




index = any(tragus_track_true == circ_top_z_front, 2);
index = find(index);
for i = 1:size(index,1)
    if tragus_track_true(index(i),3) == circ_top_z_front
        tragus_intercept_point_top_left = tragus_track(index(1),:);
        break
    end
end
for ii = i+1:size(index,1)
    if tragus_track_true(index(ii),3) == circ_top_z_front
        tragus_intercept_point_top_right = tragus_track_true(index(ii),:);
        break
    end
end

inion_circumference = [];
inion_top_track_mirror_back = [];
inion_top_track_mirror_1_back = [];
% circumference pathing (top track coincident with nasion-inion
z = circ_top_z_back;

index = any(tragus_track_true == circ_top_z_back, 2);
index = find(index);
for i = 1:size(index,1)
    if tragus_track_true(index(i),3) == circ_top_z_back
        tragus_intercept_point_ttop_left = tragus_track(index(1),:);
        break
    end
end
for ii = i+1:size(index,1)
    if tragus_track_true(index(ii),3) == circ_top_z_back
        tragus_intercept_point_ttop_right = tragus_track_true(index(ii),:);
        break
    end
end

headt = patient_head;
for x = Cz(1):-1:Cz(1)-30
    for y = size(patient_head,2)-20:-1:Cz(2)%size(patient_head,2)-50
        if headt(x,y,z) > 35
            str = size(inion_circumference,1);
            if str == 0
                inion_circumference = [x y z];
            elseif eval(sqrt((inion_circumference(str,1)-x)^2 + (inion_circumference(str,2)-y)^2 + (inion_circumference(str,3)-z)^2)) > 10
                headt(x,y,z) = 0;
            else
                inion_circumference = [inion_circumference; x y z];
                break
            end
        end
    end

end
headt = patient_head;
for y = inion_circumference(size(inion_circumference,1),2):-1:50
    for x = 50:1:Cz(1)
        if y == tragus_intercept_point_top_right(2)
            inion_circumference = [inion_circumference; tragus_intercept_point_ttop_left];
            %idx_tragus_intercept_circ_top_left = size(back_circumference,1);
            break
        elseif headt(x,y,z) > 10
            str = size(inion_circumference, 1);
            if eval(sqrt((inion_circumference(str,1)-x)^2 + (inion_circumference(str,2)-y)^2 + (inion_circumference(str,3)-z)^2)) > 10
                headt(x,y,z) = 0;
            else
                inion_circumference = [inion_circumference; x y z];
                break
            end
        end
    end

end
headt = patient_head;
for x = inion_circumference(size(inion_circumference,1),1):1:Cz(1)
    for y = 20:1:Cz(2)
        if headt(x,y,z) > 10
            str = size(inion_circumference, 1);
            if eval(sqrt((inion_circumference(str,1)-x)^2 + (inion_circumference(str,2)-y)^2 + (inion_circumference(str,3)-z)^2)) > 10
                headt(x,y,z) = 0;
            else
                inion_circumference = [inion_circumference; x y z];
                break
            end
        end
    end

end
headt = patient_head;
for x = Cz(1):1:Cz(1)+30
    for y = size(patient_head,2)-20:-1:Cz(2)%size(patient_head,2)-50
        if headt(x,y,z) > 10
            str = size(inion_top_track_mirror_back,1);
            if str == 0
                inion_top_track_mirror_back = [x y z];
            elseif eval(sqrt((inion_top_track_mirror_back(str,1)-x)^2 + (inion_top_track_mirror_back(str,2)-y)^2 + (inion_top_track_mirror_back(str,3)-z)^2)) > 5
                headt(x,y,z) = 0;
            else
                inion_top_track_mirror_back = [inion_top_track_mirror_back; x y z];
                break
            end
        end
    end

end
headt = patient_head;
for y = inion_top_track_mirror_back(size(inion_top_track_mirror_back,1),2):-1:50
    for x = size(patient_head,1)-30:-1:Cz(1)
        if y == tragus_intercept_point_top_left(2)
            inion_top_track_mirror_back = [inion_top_track_mirror_back; tragus_intercept_point_ttop_right];
            %idx_tragus_intercept_circ_top_right = size(circ_top_track_mirror_back,1);
            break
        elseif headt(x,y,z) > 40
            str = size(inion_top_track_mirror_back,1);
            if eval(sqrt((inion_top_track_mirror_back(str,1)-x)^2 + (inion_top_track_mirror_back(str,2)-y)^2 + (inion_top_track_mirror_back(str,3)-z)^2)) > 5
                headt(x,y,z) = 0;
            else
                inion_top_track_mirror_back = [inion_top_track_mirror_back; x y z];
                break
            end
        end
    end

end
headt = patient_head;
for x = inion_top_track_mirror_back(size(inion_top_track_mirror_back,1),1):-1:Cz(1)
    for y = 20:1:Cz(2)
        if headt(x,y,z) > 35
            str = size(inion_top_track_mirror_1_back,1);
            if str == 0
                inion_top_track_mirror_1_back = [x y z];
            elseif eval(sqrt((inion_top_track_mirror_1_back(str,1)-x)^2 + (inion_top_track_mirror_1_back(str,2)-y)^2 + (inion_top_track_mirror_1_back(str,3)-z)^2)) > 5
                headt(x,y,z) = 0;
            else
                inion_top_track_mirror_1_back = [inion_top_track_mirror_1_back; x y z];
                break
            end
        end
    end

end
%idx_tragus_intercept_circ_top_right = idx_tragus_intercept_circ_top_right + size(idx_tragus_intercept_circ_top_left,1);
inion_top_track_mirror_back = [inion_top_track_mirror_back;inion_top_track_mirror_1_back];
inion_circumference = flip(inion_circumference);
inion_circumference_true = [inion_circumference; inion_top_track_mirror_back];
back_circumference_distance = zeros(size(inion_circumference_true,1),1);
for i = 1:size(inion_circumference_true,1)
    if i == size(inion_circumference_true,1)
        back_circumference_distance(i) = sqrt(...
            (inion_circumference_true(i,1)*res_x-inion_circumference_true(1,1)*res_x)^2+...
            (inion_circumference_true(i,2)*res_y-inion_circumference_true(1,2)*res_y)^2+...
            (inion_circumference_true(i,3)*res_z-inion_circumference_true(1,3)*res_z)^2);
    else
        back_circumference_distance(i) = sqrt(...
            (inion_circumference_true(i,1)*res_x-inion_circumference_true(i+1,1)*res_x)^2+...
            (inion_circumference_true(i,2)*res_y-inion_circumference_true(i+1,2)*res_y)^2+...
            (inion_circumference_true(i,3)*res_z-inion_circumference_true(i+1,3)*res_z)^2);
    end
end
fprintf('4/5 Beginning nasion circumference pathing\n')

index = any(tragus_track_true == circ_top_z_front, 2);
index = find(index);
for i = 1:size(index,1)
    if tragus_track_true(index(i),3) == circ_top_z_front
        tragus_intercept_point_top_left = tragus_track(index(1),:);
        break
    end
end
for ii = i+1:size(index,1)
    if tragus_track_true(index(ii),3) == circ_top_z_front
        tragus_intercept_point_top_right = tragus_track_true(index(ii),:);
        break
    end
end

nasion_circumference = [];
nasion_circumference_mirror = [];
nasion_circumference_mirror_1 = [];
headt = patient_head;
% circumference pathing (top track coincident with nasion-inion
z = circ_top_z_front;
for x = Cz(1):-1:Cz(1)-30
    for y = size(patient_head,2)-20:-1:Cz(2)%size(patient_head,2)-50
        if headt(x,y,z) > 40
            str = size(nasion_circumference,1);
            if str == 0
                nasion_circumference = [x y z];
            elseif eval(sqrt((nasion_circumference(str,1)-x)^2 + (nasion_circumference(str,2)-y)^2 + (nasion_circumference(str,3)-z)^2)) > 5
                headt(x,y,z) = 0;
            else
                nasion_circumference = [nasion_circumference; x y z];
                break
            end
        end
    end

end
for y = nasion_circumference(size(nasion_circumference,1),2):-1:50
    for x = 50:1:Cz(1)
        if y == tragus_intercept_point_top_right(2)
            nasion_circumference = [nasion_circumference; tragus_intercept_point_top_left];
            % idx_tragus_intercept_circ_top_left = size(front_circumference,1);
            break
        elseif headt(x,y,z) > 80
            str = size(nasion_circumference,1);
            if eval(sqrt((nasion_circumference(str,1)-x)^2 + (nasion_circumference(str,2)-y)^2 + (nasion_circumference(str,3)-z)^2)) > 5
                headt(x,y,z) = 0;
            else
                nasion_circumference = [nasion_circumference; x y z];
                break
            end
        end
    end

end
for x = nasion_circumference(size(nasion_circumference,1),1):1:Cz(1)
    for y = 20:1:Cz(2)
        if headt(x,y,z) > 40
            str = size(nasion_circumference,1);
            if eval(sqrt((nasion_circumference(str,1)-x)^2 + (nasion_circumference(str,2)-y)^2 + (nasion_circumference(str,3)-z)^2)) > 5
                headt(x,y,z) = 0;
            else
                nasion_circumference = [nasion_circumference; x y z];
                break
            end
        end
    end

end
headt = patient_head;
for x = Cz(1):1:Cz(1)+30
    for y = size(patient_head,2)-20:-1:Cz(2)%size(patient_head,2)-50
        if headt(x,y,z) > 40
            str = size(nasion_circumference_mirror,1);
            if str == 0
                nasion_circumference_mirror = [x y z];
            elseif eval(sqrt((nasion_circumference_mirror(str,1)-x)^2 + (nasion_circumference_mirror(str,2)-y)^2 + (nasion_circumference_mirror(str,3)-z)^2)) > 5
                headt(x,y,z) = 0;
            else
                nasion_circumference_mirror = [nasion_circumference_mirror; x y z];
                break
            end
        end
    end

end
for y = nasion_circumference_mirror(size(nasion_circumference_mirror,1),2):-1:50
    for x = size(patient_head,1)-30:-1:Cz(1)
        if y == tragus_intercept_point_top_left(2)
            nasion_circumference_mirror = [nasion_circumference_mirror; tragus_intercept_point_top_right];
            %idx_tragus_intercept_circ_top_right = size(front_circumference_mirror,1);
            break
        elseif headt(x,y,z) > 80
            str = size(nasion_circumference_mirror,1);
            if eval(sqrt((nasion_circumference(str,1)-x)^2 + (nasion_circumference(str,2)-y)^2 + (nasion_circumference(str,3)-z)^2)) > 5
                headt(x,y,z) = 0;
            else
                nasion_circumference_mirror = [nasion_circumference_mirror; x y z];
                break
            end
        end
    end

end
headt = patient_head;
for x = nasion_circumference_mirror(size(nasion_circumference_mirror,1),1):-1:Cz(1)
    for y = 20:1:Cz(2)
        if headt(x,y,z) > 40
            str = size(nasion_circumference_mirror_1,1);
            if str == 0
                nasion_circumference_mirror_1 = [x y z];
            elseif  eval(sqrt((nasion_circumference_mirror_1(str,1)-x)^2 + (nasion_circumference_mirror_1(str,2)-y)^2 + (nasion_circumference_mirror_1(str,3)-z)^2)) > 5
                headt(x,y,z) = 0;
            else
                nasion_circumference_mirror_1 = [nasion_circumference_mirror_1; x y z];
                break
            end
        end
    end

end
% idx_tragus_intercept_circ_top_right = idx_tragus_intercept_circ_top_right + size(idx_tragus_intercept_circ_top_left,1);
nasion_circumference_mirror = [nasion_circumference_mirror;nasion_circumference_mirror_1];
nasion_circumference = flip(nasion_circumference);
nasion_circumference_true = [nasion_circumference; nasion_circumference_mirror];
circ_top_track_front_distance = zeros(size(nasion_circumference_true,1),1);
for i = 1:size(nasion_circumference_true,1)
    if i == size(nasion_circumference_true,1)
        circ_top_track_front_distance(i) = sqrt(...
            (nasion_circumference_true(i,1)*res_x-nasion_circumference_true(1,1)*res_x)^2+...
            (nasion_circumference_true(i,2)*res_y-nasion_circumference_true(1,2)*res_y)^2+...
            (nasion_circumference_true(i,3)*res_z-nasion_circumference_true(1,3)*res_z)^2);
    else
        circ_top_track_front_distance(i) = sqrt(...
            (nasion_circumference_true(i,1)*res_x-nasion_circumference_true(i+1,1)*res_x)^2+...
            (nasion_circumference_true(i,2)*res_y-nasion_circumference_true(i+1,2)*res_y)^2+...
            (nasion_circumference_true(i,3)*res_z-nasion_circumference_true(i+1,3)*res_z)^2);
    end
end
fprintf('5/5 Beginning tragus circumference pathing\n')


ii = Cz_idx_in_tragus;
tot = 0;
while tot < trag*.4*10
    tot = tot + tragus_track_distance(ii);
    ii=ii-1;
end
circ_tragus_z = tragus_track_true(ii,3);

index = any(tragus_track_true == circ_tragus_z, 2);
index = find(index);
for i = 1:size(index,1)
    if tragus_track_true(index(i),3) == circ_tragus_z
        tragus_intercept_point_bottom_right = tragus_track_true(index(i),:);
        break
    end
end
for ii = i+1:size(index,1)
    if tragus_track_true(index(ii),3) == circ_tragus_z
        tragus_intercept_point_bottom_left = tragus_track_true(index(ii),:);
        break
    end
end

tragus_circumference = [];
tragus_circumference_mirror = [];
tragus_circumference_mirror_1 = [];
% circumference pathing (bottom track coincident with tragus-tragus)
z = circ_tragus_z;
headt = patient_head;
for x = Cz(1):-1:Cz(1)-100
    for y = size(patient_head,2)-20:-1:Cz(2)%size(patient_head,2)-50
        if headt(x,y,z) > 80
            str = size(tragus_circumference,1);
            if str == 0
                tragus_circumference = [x y z];
            elseif  eval(sqrt((tragus_circumference(str,1)-x)^2 + (tragus_circumference(str,2)-y)^2 + (tragus_circumference(str,3)-z)^2)) > 5
                headt(x,y,z) = 0;
            else
                tragus_circumference = [tragus_circumference; x y z];
                break
            end
        end
    end

end
for y = tragus_circumference(size(tragus_circumference,1),2):-1:50
    for x = 50:1:Cz(1)
        if y == tragus_intercept_point_bottom_right(2)
            tragus_circumference = [tragus_circumference; tragus_intercept_point_bottom_right];
            idx_tragus_intercept_circ_bottom_left = size(tragus_circumference,1);
            break
        elseif headt(x,y,z) > 100
            str = size(tragus_circumference,1);
            if eval(sqrt((tragus_circumference(str,1)-x)^2 + (tragus_circumference(str,2)-y)^2 + (tragus_circumference(str,3)-z)^2)) > 5
                headt(x,y,z) = 0;
            else
                tragus_circumference = [tragus_circumference; x y z];
                break
            end
        end
    end

end
for x = tragus_circumference(size(tragus_circumference,1),1):1:Cz(1)
    for y = 20:1:Cz(2)
        if headt(x,y,z) > 140
            str = size(tragus_circumference,1);
            if eval(sqrt((tragus_circumference(str,1)-x)^2 + (tragus_circumference(str,2)-y)^2 + (tragus_circumference(str,3)-z)^2)) > 5
                headt(x,y,z) = 0;
            else
                tragus_circumference = [tragus_circumference; x y z];
                break
            end
        end
    end

end
headt = patient_head;
for x = Cz(1):1:Cz(1)+120
    for y = size(patient_head,2)-20:-1:Cz(2)
        if headt(x,y,z) > 80
            str = size(tragus_circumference_mirror,1);
            if str == 0
                tragus_circumference_mirror = [x y z];
            elseif eval(sqrt((tragus_circumference_mirror(str,1)-x)^2 + (tragus_circumference_mirror(str,2)-y)^2 + (tragus_circumference_mirror(str,3)-z)^2)) > 5
                headt(x,y,z) = 0;
            else
                tragus_circumference_mirror = [tragus_circumference_mirror; x y z];
                break
            end
        end
    end

end
y_save = tragus_circumference_mirror(size(tragus_circumference_mirror,1),2);
for y = y_save:-1:50
    for x = size(patient_head,1)-30:-1:Cz(1)
        if y == tragus_intercept_point_bottom_right(2)
            tragus_circumference_mirror = [tragus_circumference_mirror; tragus_intercept_point_bottom_left];
            idx_tragus_intercept_circ_bottom_right = size(tragus_circumference_mirror,1);
            break
        elseif headt(x,y,z) > 100
            str = size(tragus_circumference_mirror,1);
            if eval(sqrt((tragus_circumference_mirror(str,1)-x)^2 + (tragus_circumference_mirror(str,2)-y)^2 + (tragus_circumference_mirror(str,3)-z)^2)) > 5
                headt(x,y,z) = 0;
            else
                tragus_circumference_mirror = [tragus_circumference_mirror; x y z];
                break
            end
        end
    end

end
for x = tragus_circumference_mirror(size(tragus_circumference_mirror,1),1):-1:Cz(1)
    for y = 20:1:Cz(2)
        if headt(x,y,z) > 140
            str = size(tragus_circumference_mirror_1,1);
            if str == 0
                tragus_circumference_mirror_1 = [x y z];
            elseif eval(sqrt((tragus_circumference_mirror_1(str,1)-x)^2 + (tragus_circumference_mirror_1(str,2)-y)^2 + (tragus_circumference_mirror_1(str,3)-z)^2)) > 5
                headt(x,y,z) = 0;
            else
                tragus_circumference_mirror_1 = [tragus_circumference_mirror_1; x y z];
                break
            end
        end
    end

end
idx_tragus_intercept_circ_bottom_right = idx_tragus_intercept_circ_bottom_right + size(tragus_circumference,1);
tragus_circumference_mirror = [tragus_circumference_mirror;tragus_circumference_mirror_1];
tragus_circumference = flip(tragus_circumference);
tragus_circumference_true = [tragus_circumference; tragus_circumference_mirror];
side_circumference_distance = zeros(size(tragus_circumference_true,1),1);
for i = 1:size(tragus_circumference_true,1)
    if i == size(tragus_circumference_true,1)
        side_circumference_distance(i) = sqrt(...
            (tragus_circumference_true(i,1)*res_x-tragus_circumference_true(1,1)*res_x)^2+...
            (tragus_circumference_true(i,2)*res_y-tragus_circumference_true(1,2)*res_y)^2+...
            (tragus_circumference_true(i,3)*res_z-tragus_circumference_true(1,3)*res_z)^2);
    else
        side_circumference_distance(i) = sqrt(...
            (tragus_circumference_true(i,1)*res_x-tragus_circumference_true(i+1,1)*res_x)^2+...
            (tragus_circumference_true(i,2)*res_y-tragus_circumference_true(i+1,2)*res_y)^2+...
            (tragus_circumference_true(i,3)*res_z-tragus_circumference_true(i+1,3)*res_z)^2);
    end
end

nasion_circumference_true = [nasion_circumference_true; nasion_circumference_true(1,:)];
tragus_circumference_true = [tragus_circumference_true; tragus_circumference_true(1,:)];
fprintf('Finished preliminary pathing\n')
%circ_front_start_coord = size(front_circumference,1);

save  scalp_pathing1.mat

% tracks 1 save point
fprintf('Creating EEG distances reference list\n')
EEG_list = zeros(21,3);
EEG_list(:,1) = Cz(1);EEG_list(:,2) = Cz(2);EEG_list(:,3) = Cz(3);
EEG_distances = zeros(21,3);

EEG_list(1,:) = Cz;
EEG_distances(2) = 10*inion*.2;     % Fz
EEG_distances(3) = 10*inion*.4;     % Fpz
EEG_distances(4) = 10*trag*.2;      % c4x
EEG_distances(5) = 10*trag*.4;      % t4x
EEG_distances(6,1) = 10*trag*.4;    % f7x (circ_bottom_track)
EEG_distances(6,2) = 10*circ*.1;
EEG_distances(7,1) = 10*inion*.4;   % fp2
EEG_distances(7,2) = circ*0.05;
% EEG_distances(8,1) =              % f4x
% EEG_distances(8,2) =
EEG_distances(9) = 10*trag*.2;      % c3x
EEG_distances(10) = 10*trag*.4;     % t3x
EEG_distances(11,1) = 10*inion*.4;  % fp1
EEG_distances(11,2) = circ*0.05;
EEG_distances(12,1) = 10*trag*.4;   % f8x
EEG_distances(12,2) = 10*circ*.1;
% EEG_distances(13,1) =             % f3x
% EEG_distances(13,2) =
EEG_distances(14) = 10*inion*.2;    % pzx
EEG_distances(15) = 10*inion*.4;    % ozx
EEG_distances(16,1) = 10*trag*.4;   % t5x
EEG_distances(16,2) = 10*circ*.1;
EEG_distances(17,1) = 10*inion*.4;  % o2x
EEG_distances(17,2) = 10*circ*0.05;
EEG_distances(18,1) = 10*inion*.4;  % o1x
EEG_distances(18,2) = 10*circ*0.05;
EEG_distances(19,1) = 10*trag*.4;   % t6x
EEG_distances(19,2) = 10*circ*.1;
% EEG_distances(20,1) =              % p4x
% EEG_distanceS(20,2) =
% EEG_distances(21,1) =              % p3x
% EEG_distances(21,2) =

% fprintf('selecting track intersections for pathing\n')
% circ_top_track_intersect = intersect(inion_track_true,front_circumference_true,'rows');
% [~, idx] = ismember(front_circumference_true, circ_top_track_intersect, 'rows');
% circ_top_start_point = find(idx);
% circ_top_start_point_back = circ_top_start_point(1);
% circ_top_start_point_front = circ_top_start_point(2);


% circ top intersect front of head
% circ bottom intersect right of head

fprintf('Getting EEG locations on subject\n')
for i = 2:size(EEG_list,1)
    if i <= 7
        if i == 2   %Fz - GOOD
            ii = Cz_idx_in_inion;
            tot = 0;
            while tot < EEG_distances(2,1)
                tot = tot + inion_track_distance(ii);
                ii=ii+1;
            end
            EEG_list(i,:) = inion_track_true(ii,:);
            save_point2 = EEG_list(i,2);
        end
        if i == 3   %Fpz
            ii = Cz_idx_in_inion;
            tot = 0;
            while tot < EEG_distances(3,1)
                tot = tot + inion_track_distance(ii);
                ii=ii+1;
            end
            EEG_list(i,:) = inion_track_true(ii,:);
        end
        if i == 4   %c4x
            ii = Cz_idx_in_tragus;
            tot = 0;
            while tot < EEG_distances(4,1)
                tot = tot + tragus_track_distance(ii);
                ii=ii+1;
            end
            EEG_list(i,:) = tragus_track_true(ii,:);
        end
        if i == 5   %t4x
            ii = Cz_idx_in_tragus;
            tot = 0;
            while tot < EEG_distances(5,1)
                tot = tot + tragus_track_distance(ii);
                ii=ii+1;
            end
            EEG_list(i,:) = tragus_track_true(ii,:);
        end
        if i == 6   %f8x
            ii = idx_tragus_intercept_circ_bottom_right; %floor(size(circ_bottom_track_distance,1));
            tot = 0;
            while tot < EEG_distances(6,2)
                tot = tot + side_circumference_distance(ii);
                ii=ii-1;
            end
            EEG_list(i,:) = tragus_circumference_true(ii,:);
        end
        if i == 7   %fp2
            ii = floor(size(circ_top_track_front_distance,1)/2);
            tot = 0;
            while tot < circ/2 - EEG_distances(7,2)
                tot = tot + circ_top_track_front_distance(ii);
                ii=ii+1;
            end
            EEG_list(i,:) = nasion_circumference_true(ii,:);
        end

    elseif i <= 12
        if i == 9   %c3x
            ii = Cz_idx_in_tragus;
            tot = 0;
            while tot < EEG_distances(9,1)
                tot = tot + tragus_track_distance(ii);
                ii=ii-1;
            end
            EEG_list(i,:) = tragus_track_true(ii,:);
        end
        if i == 10  %t3x
            ii = Cz_idx_in_tragus;
            tot = 0;
            while tot < EEG_distances(10,1)
                tot = tot + tragus_track_distance(ii);
                ii=ii-1;
            end
            EEG_list(i,:) = tragus_track_true(ii,:);
        end
        if i == 11  %fp1
            ii = ceil(size(circ_top_track_front_distance,1)/2);
            tot = 0;
            while tot < circ/2 - EEG_distances(11,2)
                tot = tot + circ_top_track_front_distance(ii);
                ii=ii-1;
            end
            EEG_list(i,:) = nasion_circumference_true(ii,:);
        end
        if i == 12  %f7x
            ii = idx_tragus_intercept_circ_bottom_left;
            tot = 0;
            while tot < EEG_distances(12,2)
                tot = tot + side_circumference_distance(ii);
                ii=ii+1;
            end
            EEG_list(i,:) = tragus_circumference_true(ii,:);
            F4_coord = (EEG_list(i,2)+save_point2)/2;
        end

    elseif i <= 16 || i == 19
        if i == 14  %pzx
            ii = floor(size(inion_track_distance,1)/2);
            tot = 0;
            while tot < EEG_distances(14,1)
                tot = tot + inion_track_distance(ii);
                ii=ii-1;
            end
            EEG_list(i,:) = inion_track_true(ii,:);
            save_point = EEG_list(i,2);
        end
        if i == 15  %ozx
            ii = Cz_idx_in_inion;
            tot = 0;
            while tot < EEG_distances(15,1)
                tot = tot + inion_track_distance(ii);
                ii=ii-1;
            end
            EEG_list(i,:) = inion_track_true(ii,:);
        end
        if i == 16  %t5x
            ii = idx_tragus_intercept_circ_bottom_right;
            tot = 0;
            while tot < EEG_distances(16,2)
                tot = tot + side_circumference_distance(ii);
                ii=ii+1;
            end
            EEG_list(i,:) = tragus_circumference_true(ii,:);
        end
        if i == 19  %t6x
            ii = idx_tragus_intercept_circ_bottom_left;
            tot = 0;
            while tot < EEG_distances(19,2)
                tot = tot + side_circumference_distance(ii);
                ii=ii-1;
            end
            EEG_list(i,:) = tragus_circumference_true(ii,:);
            P4_coord = (EEG_list(i,2)+save_point)/2;
        end

    else
        if i == 17  %o2x
            ii = size(back_circumference_distance,1);
            tot = 0;
            while tot < EEG_distances(17,2)
                tot = tot + back_circumference_distance(ii);
                ii=ii-1;
            end
            EEG_list(i,:) = inion_circumference_true(ii,:);
        end
        if i == 18  %o1x
            ii = 1;
            tot = 0;
            while tot < EEG_distances(18,2)
                tot = tot + back_circumference_distance(ii);
                ii=ii+1;
            end
            EEG_list(i,:) = inion_circumference_true(ii,:);
        end
    end
end

% tracks 2 save point
fprintf('Pathing P3P4 and F3F4 Tracks\n')
p3p4_track = [];
p3p4_track_mirror = [];
%P3-P4 pathing
y = floor(P4_coord);
for z = Cz(3):-1:60
    for x = 30:Cz(1)
        if patient_head(x,y,z) > 50
            p3p4_track = [p3p4_track; x y z];
            break
        end
    end

end
for z = Cz(3):-1:60
    for x = size(patient_head,1)-30:-1:Cz(1)
        if patient_head(x,y,z) > 50
            p3p4_track_mirror = [p3p4_track_mirror; x y z];
            break
        end
    end

end
p3p4_track = flip(p3p4_track);
p3p4_track_true = [p3p4_track; p3p4_track_mirror];
p3p4_track_distance = zeros(size(p3p4_track_true,1),1);
for i = 1:size(p3p4_track_true,1)-1

    p3p4_track_distance(i) = sqrt(...
        (p3p4_track_true(i,1)*res_x-p3p4_track_true(i+1,1)*res_x)^2+...
        (p3p4_track_true(i,2)*res_y-p3p4_track_true(i+1,2)*res_y)^2+...
        (p3p4_track_true(i,3)*res_z-p3p4_track_true(i+1,3)*res_z)^2);

end
p3p4_plot_distance = sum(p3p4_track_distance)/4;


f3f4_track = [];
f3f4_track_mirror = [];
%F3-F4 pathing
y = floor(F4_coord);
for z = Cz(3):-1:60
    for x = 30:Cz(1)
        if patient_head(x,y,z) > 50
            f3f4_track = [f3f4_track; x y z];
            break
        end
    end

end
for z = Cz(3):-1:60
    for x = size(patient_head,1)-30:-1:Cz(1)
        if patient_head(x,y,z) > 50
            f3f4_track_mirror = [f3f4_track_mirror; x y z];
            break
        end
    end

end
f3f4_track = flip(f3f4_track);
f3f4_track_true = [f3f4_track; f3f4_track_mirror];
f3f4_track_distance = zeros(size(f3f4_track_true,1),1);
for i = 1:size(f3f4_track_true,1)-1

    f3f4_track_distance(i) = sqrt(...
        (f3f4_track_true(i,1)*res_x-f3f4_track_true(i+1,1)*res_x)^2+...
        (f3f4_track_true(i,2)*res_y-f3f4_track_true(i+1,2)*res_y)^2+...
        (f3f4_track_true(i,3)*res_z-f3f4_track_true(i+1,3)*res_z)^2);

end
f3f4_plot_distance = sum(f3f4_track_distance)/4;

fprintf('Finished all pathing, finding P3,P4,F3,F4 coordinates\n')

ii = ceil(size(p3p4_track_true,1)/2);   %p4x
tot = 0;
while tot < p3p4_plot_distance
    tot = tot + p3p4_track_distance(ii);
    ii=ii-1;
end
EEG_list(20,:) = p3p4_track_true(ii,:);

ii = ceil(size(p3p4_track_true,1)/2);   %p3x
tot = 0;
while tot < p3p4_plot_distance
    tot = tot + p3p4_track_distance(ii);
    ii=ii+1;
end
EEG_list(21,:) = p3p4_track_true(ii,:);

ii = ceil(size(f3f4_track_true,1)/2);   %f3x
tot = 0;
while tot < f3f4_plot_distance
    tot = tot + f3f4_track_distance(ii);
    ii=ii-1;
end
EEG_list(13,:) = f3f4_track_true(ii,:);

ii = ceil(size(f3f4_track_true,1)/2);   %f4x
tot = 0;
while tot < f3f4_plot_distance
    tot = tot + f3f4_track_distance(ii);
    ii=ii+1;
end
EEG_list(8,:) = f3f4_track_true(ii,:);

fprintf('EEG point locating complete\n')

% save 3 tracks point
save scalp_pathing2.mat
end