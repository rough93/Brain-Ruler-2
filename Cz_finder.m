function [Cz] = Cz_finder(patient_head)

it = 1;
stop = 0;
%save_point = zeros(2000,3);
save_point = [];

for i = 1:size(patient_head,1)
    for j = 1:size(patient_head,2)*2/3
        for k = 1:size(patient_head,3)
            if patient_head(i,j,k) > 200 % threshold for soft tissue
                if isempty(save_point)%save_point(1) == 0%
                    %save_point(1,:) = [i j k];
                    save_point = [i j k];
                    it = 2;
                else
                    if sqrt((i-save_point(size(save_point,1),1))^2+...
                            (j-save_point(size(save_point,1),2))^2+...
                            (k-save_point(size(save_point,1),3))^2) < 60
                        it = it+1;
                        save_point = [save_point; i j k];
                        %save_point(it,:) = [i j k];
                    else
                        stop = 1;
                        break
                    end
                end
            end
        end
        if stop == 1
            break
        end
    end
    if stop == 1
        break
    end
end

%ind = find(sum(save_point,2)==0) ;
%save_point(ind,:) = [];

trag_point = save_point(size(save_point,1),:);
% trag_plane = [trag_point;...
%    trag_point(1)+1,trag_point(2),trag_point(3);...
%    trag_point(1),trag_point(2),trag_point(3)+1]; % 3 points to define plane
AB = [1,0,0];
AC = [0,0,1];
crossABC = cross(AB,AC);
a = crossABC(1);
b = crossABC(2);
c = crossABC(3);
d = -(a*trag_point(1)+b*trag_point(2)+c*trag_point(3));
syms x y z
plane1 = a*x+b*y+c*z+d==0;

inion_point = [size(patient_head,1)/2,1,1];
% inion_plane = [inion_point;...
%     inion_point(1),inion_point(2)+1,inion_point(3);...
%     inion_point(1),inion_point(2),inion_point(3)+1]; % 3 points to define plane
AB = [0,1,0];
AC = [0,0,1];
crossABC = cross(AB,AC);
a = crossABC(1);
b = crossABC(2);
c = crossABC(3);
d = -(a*inion_point(1)+b*inion_point(2)+c*inion_point(3));
plane2 = a*x+b*y+c*z+d==0;

xyz = solve([plane1, plane2]);
x = xyz.x;
y = xyz.y;

for z = size(patient_head,3):-1:1
    if patient_head(x,y,z) > 25
        Cz = [x y z];
        break
    end
end
save cz_finder.mat
end