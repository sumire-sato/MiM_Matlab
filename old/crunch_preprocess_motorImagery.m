% Toggle on and off different preprocessing steps
VDM = 1;
Realign = 1;
Slicetiming = 1;
Coregister = 1;
Segment = 1;
Normalise = 1;
Smooth = 1;

data_path = pwd;

%--------------------------------------------------------------------------
spm('Defaults','fMRI');
spm_jobman('initcfg');
spm_get_defaults('cmdline',true);
% spm fmri


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SPATIAL PREPROCESSING
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if VDM
    % TF: Need to figure out this bug..
    fieldmap_file = spm_select('FPList',fullfile(data_path,'Processed/MRI_files/03_Fieldmaps/Fieldmap_imagery'), '^fpm.*\.img$');
    epi_file = spm_select('FPList',fullfile(data_path,'Processed/MRI_files/03_Fieldmaps/Fieldmap_imagery'), '^se.*\.nii$');
    magnitude_file = spm_select('FPList',fullfile(data_path,'Processed/MRI_files/03_Fieldmaps/Fieldmap_imagery'), '^my_fieldmap_mag.*\.nii$');
    matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.data.precalcfieldmap.precalcfieldmap = {fieldmap_file};
    matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.session.epi = {epi_file};
    matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.data.precalcfieldmap.magfieldmap ={magnitude_file}';
    matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.defaults.defaultsfile = {'Ugrant_defaults.m'};
    matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.matchvdm = 0;
    matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.sessname = 'session';
    matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.anat = '';
    matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.matchanat = 0;
    matlabbatch{1}.spm.tools.fieldmap.calculatevdm.subj.writeunwarped = 1;
    spm_jobman('run',matlabbatch);
    clear matlabbatch
end


functional_files = spm_select('ExtFPList', fullfile(data_path,'Processed/MRI_files/05_MotorImagery'), '^201906.*\.nii$');
structural_files = spm_select('FPList', fullfile(data_path,'Processed/MRI_files/02_T1'), '^201906.*\.nii$');
vdm_imagery_files = spm_select('FPList', fullfile(data_path,'Processed/MRI_files/03_Fieldmaps/Fieldmap_imagery'), '^vdm5.*\img$');

functional_imagery_files1 = functional_files(1:168,:);
functional_imagery_files2 = functional_files(169:336,:);

if Realign
    % Realign:
    % The goal is to find the best possible alignment between an input image and some target image (�model�?? To all images)
    % Determine the rigid body transformation that minimizes some cost function (SPM: least-square; FSL: normalized correlation ratio).
    % Rigid Body Transformation: defined by 3 translations in x,y, and z directions and 3 rotations, around the x, y, and z axes.
    %-------------------------------------------------------------------------
    matlabbatch{1}.spm.spatial.realign.estwrite.data = {cellstr(functional_imagery_files1) cellstr(functional_imagery_files2)};
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.quality = 0.9;
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.sep = 4;
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.fwhm = 5;
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.rtm = 1;
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.interp = 2;
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.wrap = [0 0 0];
    matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.weight = '';
    matlabbatch{1}.spm.spatial.realign.estwrite.roptions.which = [2 1];
    matlabbatch{1}.spm.spatial.realign.estwrite.roptions.interp = 4;
    matlabbatch{1}.spm.spatial.realign.estwrite.roptions.wrap = [0 0 0];
    matlabbatch{1}.spm.spatial.realign.estwrite.roptions.mask = 1;
    matlabbatch{1}.spm.spatial.realign.estwrite.roptions.prefix = 'realigned_';
    spm_jobman('run',matlabbatch);
    clear matlabbatch
    matlabbatch{1}.spm.spatial.realignunwarp.data.scans =  cellstr(functional_imagery_files1);
    matlabbatch{1}.spm.spatial.realignunwarp.data.pwscan = cellstr(vdm_imagery_files);
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.quality = 0.9;
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.sep = 4;
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.fwhm = 5;
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.rtm = 0;
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.einterp = 2;
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.ewrap = [0 0 0];
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.weight = '';
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.basfcn = [12 12];
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.regorder = 1;
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.lambda = 100000;
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.jm = 0;
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.fot = [4 5];
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.sot = [];
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.uwfwhm = 4;
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.rem = 1;
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.noi = 5;
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.expround = 'Average';
    matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.uwwhich = [2 1];
    matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.rinterp = 4;
    matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.wrap = [0 0 0];
    matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.mask = 1;
    matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.prefix = 'unwarpedRealigned_';
    spm_jobman('run',matlabbatch);
    clear matlabbatch
    
    matlabbatch{1}.spm.spatial.realignunwarp.data.scans =  cellstr(functional_imagery_files2);
    matlabbatch{1}.spm.spatial.realignunwarp.data.pwscan = cellstr(vdm_imagery_files);
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.quality = 0.9;
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.sep = 4;
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.fwhm = 5;
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.rtm = 0;
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.einterp = 2;
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.ewrap = [0 0 0];
    matlabbatch{1}.spm.spatial.realignunwarp.eoptions.weight = '';
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.basfcn = [12 12];
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.regorder = 1;
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.lambda = 100000;
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.jm = 0;
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.fot = [4 5];
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.sot = [];
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.uwfwhm = 4;
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.rem = 1;
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.noi = 5;
    matlabbatch{1}.spm.spatial.realignunwarp.uweoptions.expround = 'Average';
    matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.uwwhich = [2 1];
    matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.rinterp = 4;
    matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.wrap = [0 0 0];
    matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.mask = 1;
    matlabbatch{1}.spm.spatial.realignunwarp.uwroptions.prefix = 'unwarpedRealigned_';
    spm_jobman('run',matlabbatch);
    clear matlabbatch
    
end

if Slicetiming
    % Slice timing: Temporal interpolation: use information from nearby time points to estimate the
    % amplitude of the MR signal at the onset of each TR. Put all volumes at the same time.
    % Like each slice had been acquired at the same time.
    
    files_to_slicetime = spm_select('ExtFPList', fullfile(data_path,'Processed/MRI_files/05_MotorImagery'), '^unwarpedRealigned_.*\.nii$');
    
    files_to_slicetime1 = files_to_slicetime(1:168,:);
    files_to_slicetime2 = files_to_slicetime(169:336,:);
    
    matlabbatch{1}.spm.temporal.st.scans = {cellstr(files_to_slicetime1) cellstr(files_to_slicetime2)};
    matlabbatch{1}.spm.temporal.st.nslices = 66;
    matlabbatch{1}.spm.temporal.st.tr = 1.5;
    matlabbatch{1}.spm.temporal.st.ta = 1.4375; % TR - (TR/nslices)
    matlabbatch{1}.spm.temporal.st.so = [1     3     5     7     9    11    13    15    17    19    21    23    25    27    29    31    33    35    37 ...
        39    41    43    45    47    49    51    53    55    57    59    61    63    65  2     4     6     8    10    12    14    16    18    20    22 ...
        24    26    28    30    32    34    36    38    40    42    44    46    48    50    52    54    56    58    60    62    64    66];
    matlabbatch{1}.spm.temporal.st.refslice = 12;
    matlabbatch{1}.spm.temporal.st.prefix = 'slicetimed_';
    
    spm_jobman('run',matlabbatch);
    clear matlabbatch
    
    files_to_slicetime = spm_select('ExtFPList', fullfile(data_path,'Processed/MRI_files/05_MotorImagery'), '^realigned_.*\.nii$');
    
    files_to_slicetime1 = files_to_slicetime(1:168,:);
    files_to_slicetime2 = files_to_slicetime(169:336,:);
    
    matlabbatch{1}.spm.temporal.st.scans = {cellstr(files_to_slicetime1) cellstr(files_to_slicetime2)};
    matlabbatch{1}.spm.temporal.st.nslices = 66;
    matlabbatch{1}.spm.temporal.st.tr = 1.5;
    matlabbatch{1}.spm.temporal.st.ta = 1.4375; % TR - (TR/nslices)
    matlabbatch{1}.spm.temporal.st.so = [1     3     5     7     9    11    13    15    17    19    21    23    25    27    29    31    33    35    37 ...
        39    41    43    45    47    49    51    53    55    57    59    61    63    65  2     4     6     8    10    12    14    16    18    20    22 ...
        24    26    28    30    32    34    36    38    40    42    44    46    48    50    52    54    56    58    60    62    64    66];
    matlabbatch{1}.spm.temporal.st.refslice = 12;
    matlabbatch{1}.spm.temporal.st.prefix = 'slicetimed_';
    
    spm_jobman('run',matlabbatch);
    clear matlabbatch
end

if Coregister
    % Coregister
    %--------------------------------------------------------------------------
    %                 matlabbatch{1}.spm.spatial.coreg.estimate.ref    = cellstr(spm_file(functional_imagery_files(1,:),'prefix','meanunwarped_'));
    mean_functional_image = (spm_file(functional_files,'prefix','meanunwarpedRealigned_'));
    mean_functional_image1 = mean_functional_image(1,1:end-4);
    mean_functional_image2 = mean_functional_image(2,1:end-4);
    
    matlabbatch{1}.spm.spatial.coreg.estimate.ref    = cellstr(mean_functional_image1);
    matlabbatch{1}.spm.spatial.coreg.estimate.source = cellstr(structural_files);
    matlabbatch{1}.spm.spatial.coreg.estimate.other = {''};
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
    
    spm_jobman('run',matlabbatch);
    clear matlabbatch
    
    matlabbatch{1}.spm.spatial.coreg.estimate.ref    = cellstr(mean_functional_image2);
    matlabbatch{1}.spm.spatial.coreg.estimate.source = cellstr(structural_files);
    matlabbatch{1}.spm.spatial.coreg.estimate.other = {''};
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
    
    spm_jobman('run',matlabbatch);
    clear matlabbatch
    
    mean_functional_image = (spm_file(functional_files,'prefix','meanrealigned_'));
    mean_functional_image1 = mean_functional_image(1,1:end-4);
    mean_functional_image2 = mean_functional_image(2,1:end-4);
    
    matlabbatch{1}.spm.spatial.coreg.estimate.ref    = cellstr(mean_functional_image1);
    matlabbatch{1}.spm.spatial.coreg.estimate.source = cellstr(structural_files);
    matlabbatch{1}.spm.spatial.coreg.estimate.other = {''};
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
    
    spm_jobman('run',matlabbatch);
    clear matlabbatch
    
    matlabbatch{1}.spm.spatial.coreg.estimate.ref    = cellstr(mean_functional_image2);
    matlabbatch{1}.spm.spatial.coreg.estimate.source = cellstr(structural_files);
    matlabbatch{1}.spm.spatial.coreg.estimate.other = {''};
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
    matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
    
    spm_jobman('run',matlabbatch);
    clear matlabbatch
end
if Segment
    % Segment
    % TF: manually adjust template??
    %--------------------------------------------------------------------------
    matlabbatch{1}.spm.spatial.preproc.channel.vols  = cellstr(structural_files);
    matlabbatch{1}.spm.spatial.preproc.channel.biasreg = 0.001;
    matlabbatch{1}.spm.spatial.preproc.channel.biasfwhm = 60;
    matlabbatch{1}.spm.spatial.preproc.channel.write = [0 1];
    matlabbatch{1}.spm.spatial.preproc.tissue(1).tpm = {'Code/Spm/helper/TPM.nii,1'};
    matlabbatch{1}.spm.spatial.preproc.tissue(1).ngaus = 1;
    matlabbatch{1}.spm.spatial.preproc.tissue(1).native = [1 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(1).warped = [0 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(2).tpm = {'Code/Spm/helper/TPM.nii,2'};
    matlabbatch{1}.spm.spatial.preproc.tissue(2).ngaus = 1;
    matlabbatch{1}.spm.spatial.preproc.tissue(2).native = [1 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(2).warped = [0 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(3).tpm = {'Code/Spm/helper/TPM.nii,3'};
    matlabbatch{1}.spm.spatial.preproc.tissue(3).ngaus = 2;
    matlabbatch{1}.spm.spatial.preproc.tissue(3).native = [1 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(3).warped = [0 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(4).tpm = {'Code/Spm/helper/TPM.nii,4'};
    matlabbatch{1}.spm.spatial.preproc.tissue(4).ngaus = 3;
    matlabbatch{1}.spm.spatial.preproc.tissue(4).native = [1 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(4).warped = [0 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(5).tpm = {'Code/Spm/helper/TPM.nii,5'};
    matlabbatch{1}.spm.spatial.preproc.tissue(5).ngaus = 4;
    matlabbatch{1}.spm.spatial.preproc.tissue(5).native = [1 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(5).warped = [0 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(6).tpm = {'Code/Spm/helper/TPM.nii,6'};
    matlabbatch{1}.spm.spatial.preproc.tissue(6).ngaus = 2;
    matlabbatch{1}.spm.spatial.preproc.tissue(6).native = [0 0];
    matlabbatch{1}.spm.spatial.preproc.tissue(6).warped = [0 0];
    matlabbatch{1}.spm.spatial.preproc.warp.mrf = 1;
    matlabbatch{1}.spm.spatial.preproc.warp.cleanup = 1;
    matlabbatch{1}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
    matlabbatch{1}.spm.spatial.preproc.warp.affreg = 'mni';
    matlabbatch{1}.spm.spatial.preproc.warp.fwhm = 0;
    matlabbatch{1}.spm.spatial.preproc.warp.samp = 3;
    matlabbatch{1}.spm.spatial.preproc.warp.write = [0 1];
    
    spm_jobman('run',matlabbatch);
    clear matlabbatch
end
if Normalise
    % Normalise: Write
    %--------------------------------------------------------------------------
    matlabbatch{1}.spm.spatial.normalise.write.subj.def  = cellstr(spm_file(structural_files,'prefix','y_','ext','nii'));
    %         matlabbatch{1}.spm.spatial.normalise.write.subj.resample = cellstr(spm_select('FPList', fullfile(data_path,'functional'), '^r.*\.nii$')); %cellstr(f); % normalize the realigned image
    %         matlabbatch{1}.spm.spatial.normalise.write.subj.resample = cellstr(spm_select('FPList', fullfile(data_path,'functional'), '^u.*\.nii$'));
    files_to_normalise = spm_select('ExtFPList', fullfile(data_path,'Processed/MRI_files/05_MotorImagery'), '^slicetimed_unwarpedRealigned.*\.nii$');
    
    files_to_normalise1 = files_to_normalise(1:168,:);
    files_to_normalise2 = files_to_normalise(169:336,:);
    
    matlabbatch{1}.spm.spatial.normalise.write.subj.resample = cellstr(files_to_normalise1);
    %         matlabbatch{1}.spm.spatial.normalise.write.subj.prefix =  'normalized_';
    matlabbatch{1}.spm.spatial.normalise.write.woptions.vox  = [3 3 3];
    %         matlabbatch{1}.spm.spatial.normalise.prefix = 'normalized_';
    
    % This is superimposing subject's functional activations on their own
    % anatomy... how? grabbing specific files?
    % What do we actually do?
    % matlabbatch{5}.spm.spatial.normalise.write.subj.def      = cellstr(spm_file(a,'prefix','y_','ext','nii'));
    % matlabbatch{5}.spm.spatial.normalise.write.subj.resample = cellstr(spm_file(a,'prefix','m','ext','nii'));
    % matlabbatch{5}.spm.spatial.normalise.write.woptions.vox  = [1 1 3];
    
    spm_jobman('run',matlabbatch);
    clear matlabbatch
    
    
    matlabbatch{1}.spm.spatial.normalise.write.subj.def  =cellstr(spm_file(structural_files,'prefix','y_','ext','nii'));
    
    matlabbatch{1}.spm.spatial.normalise.write.subj.resample = cellstr(files_to_normalise2);
    
    matlabbatch{1}.spm.spatial.normalise.write.woptions.vox  = [3 3 3];
    %         matlabbatch{1}.spm.spatial.normalise.write.prefix = 'normalized_';
    
    % This is superimposing subject's functional activations on their own
    % anatomy... how? grabbing specific files?
    % What do we actually do?
    % matlabbatch{5}.spm.spatial.normalise.write.subj.def      = cellstr(spm_file(a,'prefix','y_','ext','nii'));
    % matlabbatch{5}.spm.spatial.normalise.write.subj.resample = cellstr(spm_file(a,'prefix','m','ext','nii'));
    % matlabbatch{5}.spm.spatial.normalise.write.woptions.vox  = [1 1 3];
    
    spm_jobman('run',matlabbatch);
    clear matlabbatch
    
    
    matlabbatch{1}.spm.spatial.normalise.write.subj.def  = cellstr(spm_file(structural_files,'prefix','y_','ext','nii'));
    %         matlabbatch{1}.spm.spatial.normalise.write.subj.resample = cellstr(spm_select('FPList', fullfile(data_path,'functional'), '^r.*\.nii$')); %cellstr(f); % normalize the realigned image
    %         matlabbatch{1}.spm.spatial.normalise.write.subj.resample = cellstr(spm_select('FPList', fullfile(data_path,'functional'), '^u.*\.nii$'));
    files_to_normalise = spm_select('ExtFPList', fullfile(data_path,'Processed/MRI_files/05_MotorImagery'), '^slicetimed_realigned.*\.nii$');
    
    files_to_normalise1 = files_to_normalise(1:168,:);
    files_to_normalise2 = files_to_normalise(169:336,:);
    
    matlabbatch{1}.spm.spatial.normalise.write.subj.resample = cellstr(files_to_normalise1);
    %         matlabbatch{1}.spm.spatial.normalise.write.subj.prefix =  'normalized_';
    matlabbatch{1}.spm.spatial.normalise.write.woptions.vox  = [3 3 3];
    %         matlabbatch{1}.spm.spatial.normalise.prefix = 'normalized_';
    
    % This is superimposing subject's functional activations on their own
    % anatomy... how? grabbing specific files?
    % What do we actually do?
    % matlabbatch{5}.spm.spatial.normalise.write.subj.def      = cellstr(spm_file(a,'prefix','y_','ext','nii'));
    % matlabbatch{5}.spm.spatial.normalise.write.subj.resample = cellstr(spm_file(a,'prefix','m','ext','nii'));
    % matlabbatch{5}.spm.spatial.normalise.write.woptions.vox  = [1 1 3];
    
    spm_jobman('run',matlabbatch);
    clear matlabbatch
    
    
    matlabbatch{1}.spm.spatial.normalise.write.subj.def  =cellstr(spm_file(structural_files,'prefix','y_','ext','nii'));
    
    matlabbatch{1}.spm.spatial.normalise.write.subj.resample = cellstr(files_to_normalise2);
    
    matlabbatch{1}.spm.spatial.normalise.write.woptions.vox  = [3 3 3];
    %         matlabbatch{1}.spm.spatial.normalise.write.prefix = 'normalized_';
    
    % This is superimposing subject's functional activations on their own
    % anatomy... how? grabbing specific files?
    % What do we actually do?
    % matlabbatch{5}.spm.spatial.normalise.write.subj.def      = cellstr(spm_file(a,'prefix','y_','ext','nii'));
    % matlabbatch{5}.spm.spatial.normalise.write.subj.resample = cellstr(spm_file(a,'prefix','m','ext','nii'));
    % matlabbatch{5}.spm.spatial.normalise.write.woptions.vox  = [1 1 3];
    
    spm_jobman('run',matlabbatch);
    clear matlabbatch
end
if Smooth
    % Smooth
    %--------------------------------------------------------------------------
    files_to_smooth = spm_file(functional_files,'prefix','wslicetimed_unwarped_');
    
    files_to_smooth1 = files_to_smooth(1:168,:);
    files_to_smooth2 = files_to_smooth(169:336,:);
    
    matlabbatch{1}.spm.spatial.smooth.data = cellstr(files_to_smooth1);
    matlabbatch{1}.spm.spatial.smooth.fwhm = [6 6 6];
    matlabbatch{1}.spm.spatial.smooth.prefix = 'smooth_';
    spm_jobman('run',matlabbatch);
    clear matlabbatch
    
    matlabbatch{1}.spm.spatial.smooth.data =  cellstr(files_to_smooth2);
    matlabbatch{1}.spm.spatial.smooth.fwhm = [6 6 6];
    matlabbatch{1}.spm.spatial.smooth.prefix = 'smooth_';
    
    spm_jobman('run',matlabbatch);
    clear matlabbatch
end

