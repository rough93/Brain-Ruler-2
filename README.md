# Brain-Ruler-2 
[Current Release](https://github.com/rough93/Brain-Ruler-2/releases/latest)

Repository for the Brain Ruler 2 program. Wiki at the [Brain Ruler 2 Notion](https://www.notion.so/brainruler/Brain-Ruler-Wiki-a59eebccfc844317acb4a300cddc4e6b)

# Changelog

## 2.0.3 - 02/16/2024
- Major implementation of brain meshing to complete accurate and quick direct search measurements
- General improvements to code functionality and UX across all functions
> [!NOTE]
> You will need to re-run pre_processing on subjects to take advantage of the improved direct search functionality

## 2.0.2 - 02/15/2024
- Minor code fixes related to EEG preprocessing and search
- Added import of Z-start for preprocessing

## 2.0.1 - 02/15/2024
- Update direct search to output correct point and distance calculation
- Changed inverse search distance to display as positive (changed to absolute value of the vector)
- Minor UX changes

## 2.0.0 - 02/04/2024
- Initial commit


# Getting Started
This wiki section walks through the basic program operation for finding Scalp to Cortex Distance and corresponding cortical or scalp locations for Euser specified and EG 10-20 points. For a deeper dive into the theory behind it’s operation, visit [@Program Theory on Notion](https://www.notion.so/Program-Theory-a51a72dfdadf4f99a493b59b0b4bc036?pvs=24).

## Program Requirements

### Runtime
* EEG required MRI files: T1, c1
* Inverse Search required MRI files: c1,c4,c5
* Importing & reading MRI files T1, c1, c4, c5 into MATLAB space: ~ 36 seconds

### Software
Brain Ruler 2 runs on MATLAB and utilizes the Image Processing Toolbox. The program runs from a primary file, and runs functions stored in other files for clarity. The program structure is as follows:
- Brain Ruler 2 main program
  - User inputs
  - Loading global variables
  - Preprocessing function
  - Inverse search function
  - Direct search function
  - EEG search function set
    - locating EEG 10-20 point function
    - SCD search function
    - Results graphing

The included file structure is fixed to allow the program to locate expected files (pending expanded user interface functions):
- brain_ruler_V_X_X.m - Brain Ruler 2 main program
- Cz_finder.m - cz point finder
- inverse_search.m - cortex to scalp locating
- point2trimesh.m - inverse point locating subfunction
- pre_process_func.m - preprocessing function file
- scalp_pathing.m - scalp mapping function
- search.m - scalp to cortex locating
- Subjects
  - [subject_number]
 
### Prerequisite Data
You’ll need to provide the program with subject data before and during operation:

- Processed patient MRI files (renamed per file structure above)
  - Complete raw head MRI (T1)
  - Grey Matter MRI (c1)
  - Skull (c4)
  - Scalp (c5)
- Subject head measurements (only for EEG)
  - Nasion-Inion Distance
  - Tragus-Tragus Distance
  - Circumference

Subjects should have an assigned number in your roster and their files should be placed in the directory as:
'subjects/[subject_number_here]/'
An example with patient 1234:
```
subjects/1234/patient_head.nii
subjects/1234/patient_brain.nii
```

## Setting Up the Program

### Adding files & Selecting Run Type
As long as the files are named and located in the correct place, the program will locate and load them automatically when the patient ID is provided. When the program is started the user will be queried for the patient ID and output console responses for any files it cannot locate.

The user will need to adjust the settings for the program at the top of the script to enable or disable running certain functions, as well as select whether preprocessing of the subject has already occurred.  Enable functions by changing the value of the associated variable from `0` to `1`. The following code preprocesses a new subject for direct and inverse searches (no EEG coordinates required) and executes direct and inverse search programs for the user after preprocessing. It also elects a Z-cutoff of 80.
```
    pre_process_all = 0;        % EEG 10-20 Points, scalp-starting SCD search, cortex starting SCD search (very long, not recommended if you don't need EEG 10-20 locations)
    pre_process_standard = 1;   % Direct and inverse search mapping of the MRI (recommended for most standard users)
    load_existing = 0;          % Load existing pre-processed file
    % Crop MRI Z-Axis (use this to select the starting Z-point ro remove the
    % MRI below a certain point such as the nose)
    z_start = 80;

%%% PROCESSING %%%
% Select which routines you would like to run
    eeg_run = 0;    % EEG 10-20 Points
    dir_search = 1; % Direct Search (define points on scalp, get cortex points and distance)
    inv_search = 1; % Inverse Search (define points in cortex, get points on scalp and distance)
```

## Running the Program
Once the MRI files have been added, click Run in the MATLAB Editor. The program will ask for the subject ID and, if required, the respective head measurements in centimeters. 

### Important Notes
> [!IMPORTANT]
> 1. MATLAB and Brain Ruler 2 are one-indexed, if you are importing coordinates from zero-index programs such as FSL, you’ll need to add one to your indexes here.
> 2. Make sure the subject ID entered matches the directory where you placed the patient files, or the program will not be able to access them.
> 3. Make sure to account for the z-cutoff if converting back into the MRI coordinate space (you’ll need to add back the Z-cutoff number)

Each step is reported to the user to track program and task execution, as well as a timer for overall program steps.

### Inverse Search
The inverse search function will ask for your desired cortical X, Y, and Z coordinates and provide the nearest point on the scalp as well as the distance between the two points. Keep in mind the above notes on indexing and the Z-cutoff.

### Direct Search
Similarly to the inverse search function, the direct search function will ask for your desired scalp X, Y, and Z coordinates and provide the nearest point on the cortex as well as the distance between the two points. Keep in mind the above notes on indexing and the Z-cutoff.

### EEG 10-20
**Cz Finder**

The Cz finder generally takes under 30 seconds, and locates the Cz EEG point at the top of the head

**Scalp Pathing**

The scalp pathing routine can take up to 40 minutes to process, and creates paths around the head to accurately find EEG locations on the scalp. A development objective to reduce the time taken for this step is underway.

**Search**

The search routine can take up to 15 minutes, and is responsible for searching predefined boxes around each EEG point to locate the nearest cortical location based on the shortest distance.

### Program Outputs
Each step in the program generates a large amount of data, some of which is used by other routines in the program, and a large amount of which can be used to troubleshoot program errors. Thus each routine, and often subroutine, saves the generated data as .mat files within the subject id folder periodically throughout the script.

The final outputs (the EEG point, cortical point, and distance table; and the 3D figure) are saved into the subject id folder as BrainRuler2_subjectid.mat and patient_processed.mat, respectively.
