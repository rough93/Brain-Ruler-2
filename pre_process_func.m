function [subject_head,subject_brain,subject_skull,subject_scalp,res_x,res_y,res_z,trag,inion,circ,Cz,target_cluster_scalp,target_cluster_brain,rcv2,rcv3,tri2,tri3,FV2,FV3] = pre_process_func(pre_process_all,pre_process_standard,subject_number,subject_prefix_access_T1,subject_prefix_access_c1,subject_prefix_access_c4,subject_prefix_access_c5,z_start)
%function [subject_head,subject_brain,subject_skull,subject_scalp,res_x,res_y,res_z,trag,inion,circ,Cz,target_cluster_scalp,rcv2,tri2,FV2] = pre_process_func(pre_process_all,pre_process_standard,subject_number,subject_prefix_access_T1,subject_prefix_access_c1,subject_prefix_access_c4,subject_prefix_access_c5,z_start)

fprintf('Loading subject MRI data\n')
if isfile(append(subject_prefix_access_T1,'.nii'))
    subject_head = niftiread(subject_prefix_access_T1);
else
    fprintf('Exception 1: No subject head (T1) file detected, using scalp (c5)\n')
    subject_head = niftiread(subject_prefix_access_c5);
end
if isfile(append(subject_prefix_access_c1,'.nii'))
    subject_brain = niftiread(subject_prefix_access_c1);
else
    fprintf('Exception 1: No subject brain (c1) file detected, moving on\n')
    subject_brain = zeros(1,1,1);
end
if isfile(append(subject_prefix_access_c4,'.nii'))
    subject_skull = niftiread(subject_prefix_access_c4);
else
    fprintf('Exception 1: No subject skull (c4) file detected, moving on\n')
    subject_skull = zeros(1,1,1);
end
if isfile(append(subject_prefix_access_c5,'.nii'))
    subject_scalp = niftiread(subject_prefix_access_c5);
else
    fprintf('Exception 1: No subject scalp (c5) file detected, moving on\n')
    subject_scalp = zeros(1,1,1);
end

fprintf('\nEnter MRI Resolution:\n')
res_x = input('Input MRI X voxel size (mm):');
while isempty(res_x)
    res_x = input('Input MRI X voxel size (mm):');
end
res_y = input('Input MRI Y voxel size (mm):');
while isempty(res_y)
    res_y = input('Input MRI Y voxel size (mm):');
end
res_z = input('Input MRI Z voxel size (mm):');
while isempty(res_z)
    res_z = input('Input MRI Z voxel size (mm):');
end

trag = 0;
inion = 0;
circ = 0;
Cz = 0;

if pre_process_all == 1
    trag = input('Input Tragus-Tragus Distance (cm):');
    inion = input('Input Nasion-Inion Distnace (cm):');
    circ = input('Input Circumference (cm):');

    %%% Checkpoint 1 %%%
    [Cz] = Cz_finder(subject_head);
    subject_prefix_save_Cz = fullfile('subjects',subject_number,strcat('main_cz','.mat'));
    save(subject_prefix_save_Cz)

end

%%% Scalp meshing
% crop mri to speed up processing time
target_cluster_scalp = subject_scalp(:,:,z_start:end);

% find indices of all points at threshold value
[r,c,v] = ind2sub(size(target_cluster_scalp),find(target_cluster_scalp==255));
rcv = [r c v];
fprintf('Thesholding Complete - Scalp\n');

% delete artifacts (points with less than 7/7 points in close proximity)
[~,mD] = knnsearch(rcv,rcv,'K',7);
%Check which rows from the given range in mD have more than 0 values
%greater than y
idx = sum(mD(1:size(rcv,1),:)>1.4, 2)>0;
%perform deletion
rcv(idx,:) = [];

rcv = rcv(1:10:size(rcv,1),:);
fprintf('Artifact Removal Complete - Scalp\n');

DT = delaunayTriangulation(rcv);
[K,~] = convexHull(DT);
tri = trisurf(K,DT.Points(:,1),DT.Points(:,2),DT.Points(:,3));

FV.faces = tri.Faces;
FV.vertices = tri.Vertices;

% Find vertices without face
NVert = size(FV.vertices,1);
has_faces = ismember(1:NVert, FV.faces);
% Remove vertices without face
FV2.vertices = FV.vertices(has_faces,:);
new_ind = cumsum(has_faces);
FV2.faces = FV.faces;
for iVert = 1:NVert
    FV2.faces(FV2.faces==iVert) = new_ind(iVert);
end
rcv2 = rcv;
tri2 = tri;

%%% Brain meshing
% crop mri to speed up processing time
target_cluster_brain = subject_brain(:,:,z_start:end);

% find indices of all points at threshold value
[r,c,v] = ind2sub(size(target_cluster_brain),find(target_cluster_brain>=245));
rcv = [r c v];
fprintf('Thesholding Complete - Brain\n');

% delete artifacts (points with less than 7/7 points in close proximity)
[~,mD] = knnsearch(rcv,rcv,'K',7);
%Check which rows from the given range in mD have more than 0 values
%greater than y
idx = sum(mD(1:size(rcv,1),:)>1.4, 2)>0;
%perform deletion
rcv(idx,:) = [];

rcv = rcv(1:10:size(rcv,1),:);
fprintf('Artifact Removal Complete - Brain\n');

DT = delaunayTriangulation(rcv);
[K,~] = convexHull(DT);
tri = trisurf(K,DT.Points(:,1),DT.Points(:,2),DT.Points(:,3));

FV.faces = tri.Faces;
FV.vertices = tri.Vertices;

% Find vertices without face
NVert = size(FV.vertices,1);
has_faces = ismember(1:NVert, FV.faces);
% Remove vertices without face
FV3.vertices = FV.vertices(has_faces,:);
new_ind = cumsum(has_faces);
FV3.faces = FV.faces;
for iVert = 1:NVert
    FV3.faces(FV3.faces==iVert) = new_ind(iVert);
end
rcv3 = rcv;
tri3 = tri;

subject_prefix_save_pre_process = fullfile('subjects',subject_number,strcat(subject_number,'_preprocessed','.mat'));
save(subject_prefix_save_pre_process)

end
