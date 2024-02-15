# Brain-Ruler-2
Repository for the Brain Ruler 2 program. Wiki at the [Brain Ruler 2 Notion](https://www.notion.so/brainruler/Brain-Ruler-Wiki-a59eebccfc844317acb4a300cddc4e6b)

# Changelog

## 2.0.1 - 02/15/2024
- Update direct search to output correct point and distance calculation
- Changed inverse search distance to display as positive (changed to absolute value of the vector)
- Minor UX changes

## 2.0.0 - 02/04/2024
- Initial commit


# Getting Started
This wiki section walks through the basic program operation for finding Scalp to Cortex Distance and corresponding cortical locations for EEG 10-20 points. For a deeper dive into the theory behind it’s operation, visit [@Program Theory on Notion](https://www.notion.so/Program-Theory-a51a72dfdadf4f99a493b59b0b4bc036?pvs=24).

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
'subjects/1234/patient_head.nii'
'subjects/1234/patient_brain.nii'
