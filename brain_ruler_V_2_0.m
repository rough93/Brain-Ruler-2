    clc;clear;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% BRAIN RULER %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% START HERE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% PRE-PROCESSING %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% You can speed up using this program by pre-processing the subjects MRI,
% adjust the settings below according to what you'll want to do with the
% subject. To enable a setting, set it '1' and the remainder to '0'
    % IMPORTANT - change subject files accordingly:
    % rename T1 file to 'subject_head.nii'
    % rename c1 file to 'subject_brain.nii'
    % rename c4 file to 'subject_skull.nii'
    % rename c5 file to 'subject_scalp.nii'
    pre_process_all = 0;        % EEG 10-20 Points, scalp-starting SCD search, cortex starting SCD search (very long, not recommended if you don't need EEG 10-20 locations)
    pre_process_standard = 0;   % Direct and inverse search mapping of the MRI (recommended for most standard users)
    load_existing = 1;          % Load existing pre-processed file
    % Crop MRI Z-Axis (use this to select the starting Z-point ro remove the
    % MRI below a certain point such as the nose)
    z_start = 80;   % IMPORTANT: You'll need to adjust your coordinate inputs for the inverse search only to account for the new MRI Z-dimension

%%% PROCESSING %%%
% Select which routines you would like to run
    eeg_run = 0;    % EEG 10-20 Points
    dir_search = 1; % Direct Search (define points on scalp, get cortex points and distance)
    inv_search = 1; % Inverse Search (define points in cortex, get points on scalp and distance)

%%%%%%%%%%%%%%%%%%%%%%%%%%%% END OF SELECTIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%


fprintf('Beginning BrainRuler2 Program\n')
fprintf('Loading global variables\n')
% create global variables
start_time = tic; % Track exectution speed
st = tic;

subject_number = input('Input subject number (number where files are stored):\n','s');
 while isempty(subject_number)
     subject_number = input('Error, subject number cannot be blank! Please enter a valid subject number:\n','s');
 end

 subject_prefix_access_c1 = fullfile('subjects',subject_number,'subject_brain'); % Brain only
 subject_prefix_access_T1 = fullfile('subjects',subject_number,'subject_head'); % Whole Head
 subject_prefix_access_c4 = fullfile('subjects',subject_number,'subject_skull'); % Skull Only
 subject_prefix_access_c5 = fullfile('subjects',subject_number,'subject_scalp'); % Scalp Only (some skull artifacts)
 subject_prefix_save = fullfile('subjects',subject_number,strcat('BrainRuler2_',subject_number,'.mat'));

 % Load or pre-process files
 fprintf('Processing subject files\n')
 if load_existing == 1
     load (fullfile('subjects',subject_number,strcat(subject_number,'_preprocessed','.mat')))
 else
     [subject_head,subject_brain,subject_skull,subject_scalp,res_x,res_y,res_z,trag,inion,circ,Cz,target_cluster,rcv,tri,FV2] = pre_process_func(pre_process_all,...
     pre_process_standard,...
     subject_number,...
     subject_prefix_access_T1,...
     subject_prefix_access_c1,...
     subject_prefix_access_c4,...
     subject_prefix_access_c5);
 end


fprintf('\nInputs and preloading complete, beginning data processing at %f seconds\n\n',toc(start_time))

% Inverse Search
if inv_search == 1
    fprintf('\nCortex starting SCD:\n')
    continue_flag = 'Y';
    while continue_flag == 'Y'
        target_coord_x = input('Enter target X coordinate\n');
        target_coord_y = input('Enter target Y coordinate\n');
        target_coord_z = input('Enter target Z coordinate\n');
        target_coords = [target_coord_x, target_coord_y, target_coord_z];
        [distances, surface_points] = inverse_search(FV2,target_coords);
        fprintf('Coordinate: %f,%f,%f\nDistance: %f\n\n',surface_points(1),surface_points(2),surface_points(3),abs(distances))
        continue_flag = input('Search another coordinate (Y/N)?:\n', 's');
    end
end

% Direct Search
if dir_search == 1
    fprintf('\nScalp starting SCD:\n')
    searchend = 1;
    continue_flag = 'Y';
    while continue_flag == 'Y'
        target_coord_x = input('Enter target X coordinate\n');
        target_coord_y = input('Enter target Y coordinate\n');
        target_coord_z = input('Enter target Z coordinate\n');
        target_coords = [target_coord_x, target_coord_y, target_coord_z];
        [point,~] = search(subject_brain,target_coords,res_x,res_y,res_z,searchend);
        distance = sqrt((target_coord_x-point(1,1))^2+(target_coord_y-point(1,2))^2+(target_coord_z-point(1,3))^2);
        fprintf('Coordinate: %f,%f,%f\nDistance: %f\n',point(1,1),point(1,2),point(1,3),abs(distance))
        continue_flag = input('Search another coordinate (Y/N)?:\n', 's');
    end
end

% EEG Point Mapping
if eeg_run == 1
    searchend = 21;
    %%% Checkpoint 1 %%%
    fprintf('Task 1 starting - locate EEG 10-20 points: %f seconds\n', toc(start_time));
    [EEG_list,tragus_track_true, inion_track_true, nasion_circumference_true, inion_circumference_true, tragus_circumference_true, p3p4_track_true, f3f4_track_true] = scalp_pathing(Cz,subject_head,trag,inion,circ,res_x,res_y,res_z);
    fprintf('Complete: %f seconds\n',toc(start_time))
    subject_prefix_save_scalp = fullfile('subjects',subject_number,strcat('main_scalp','.mat'));
    save(subject_prefix_save_scalp)
    
    %%% Checkpoint 3 %%%
    fprintf('Task 2 starting - searching for nearest cortex locations: %f seconds\n', toc(start_time)')
    [point,distance] = search(subject_brain,EEG_list,res_x,res_y,res_z,searchend);
    fprintf('Complete: %f seconds\n',toc(start_time))
    subject_prefix_save_search = fullfile('subjects',subject_number,strcat('main_search','.mat'));
    save(subject_prefix_save_search)
    
    %%% Checkpoint 4 %%%
    fprintf('Task 3 starting - plot subject head tracks, EEG points, cortex points, EEG-cortex tracks, output data to command window: %f seconds\n', toc(start_time)')
    plot3(tragus_track_true(:,1),tragus_track_true(:,2),tragus_track_true(:,3),'-o')
    hold on
    plot3(inion_track_true(:,1),inion_track_true(:,2),inion_track_true(:,3),'-o')
    plot3(nasion_circumference_true(:,1),nasion_circumference_true(:,2),nasion_circumference_true(:,3),'-o') % lower
    plot3(inion_circumference_true(:,1),inion_circumference_true(:,2),inion_circumference_true(:,3),'-o') % upper
    plot3(tragus_circumference_true(:,1),tragus_circumference_true(:,2),tragus_circumference_true(:,3),'-o')
    plot3(p3p4_track_true(:,1),p3p4_track_true(:,2),p3p4_track_true(:,3),'-o')
    plot3(f3f4_track_true(:,1),f3f4_track_true(:,2),f3f4_track_true(:,3),'-o')
    plot3(EEG_list(:,1),EEG_list(:,2),EEG_list(:,3),'o','Color','red','MarkerSize',10,'MarkerFaceColor','red')
    plot3(point(:,1),point(:,2),point(:,3),'o','Color','blue','MarkerSize',5,'MarkerFaceColor','blue')
    for i = 1:21
        plot3([EEG_list(i,1) point(i,1)],[EEG_list(i,2) point(i,2)],[EEG_list(i,3) point(i,3)])
    end
    
    subject_prefix_save_fig = fullfile('subjects',subject_number,strcat('subjectprocessed','.fig'));
    savefig(subject_prefix_save_fig)
    
    EEG_name = ["Cz";"Fz";"Fpz";"C4";"T4";"F8";"Fp2";"F4";"C3";"T3";"Fp1";"F7";"F3";"Pz";"Oz";"T6";"O2";"O2";"T5";"P3";"P4"];
    EEG_point = EEG_list;
    Cortex_point = point;
    SCD = distance;

    table(EEG_name,EEG_point,Cortex_point,SCD)
    fprintf('Complete: %f seconds\n',toc(start_time))
end



program_runtime = toc(st);
fprintf('Program finished in %f minutes\n',program_runtime/60)
save(subject_prefix_save)

%end

% EEG Point Order
% point 1 - Cz
% point 2 - Fz
% point 3 - Fpz
% point 4 - C4
% point 5 - T4
% point 6 - F8
% point 7 - Fp2
% point 8 - F4
% point 9 - C3
% point 10 - T3
% point 11 - Fp1
% point 12 - F7
% point 13 - F3
% point 14 - Pz
% point 15 - Oz
% point 16 - T6
% point 17 - O2
% point 18 - O1
% point 19 - T5
% point 20 - P3
% point 21 - P4


% test brain ruler program
% changelog 2.0.1 - 2/15/2024
% - Update direct search to output correct point and distance calculation
% - Changed inverse search distance to display as positive (changed to absolute value of the vector)
% - Minor UX changes
%
% changelog 0.0.4 - 7/22/2022
% changelog 0.0.3 - 7/13/2022
%
% changelog 0.0.2 - 7/8/2022
% - distance-physical distance conversion added
%
% changelog 0.0.1 - 7/7/2022
% - initial creation
% - created test matrices
% - implemented initial written code (adjusted)
% - created initial point search function
% - added function for distance conversion
% - added time to execute tracking, checkpoint and failure gates
