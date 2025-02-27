% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <http://www.gnu.org/licenses/>.

clear, clc
data_path = pwd;
clear matlabbatch
spm('Defaults','fMRI');
spm_jobman('initcfg');
spm_get_defaults('cmdline',true);

data_path = pwd;

%----------------------------------------------------------------------------------------------------------------------------------------
% Select the GM, WM, and mask files 
%----------------------------------------------------------------------------------------------------------------------------------------
% GM = spm_select('FPList', data_path, '^coregToT1_GM_mask.nii');		 				% GM mask
% WM = spm_select('FPList', data_path, '^coregToT1_WM_mask.nii'); 		 				% WM mask 
% CBmask = spm_select('FPList', data_path, '^coregToT1_CB_mask.nii'); 	 			% Whole CB mask  
% GM = spm_select('FPList', data_path, '^GM_mask.nii');		 				% GM mask
% WM = spm_select('FPList', data_path, '^WM_mask.nii'); 		 				% WM mask 
% CBmask = spm_select('FPList', data_path, '^CB_mask.nii'); 	 			% Whole CB mask  

GM = spm_select('FPList', data_path, '^coregToSUIT_coregToT1_GM_mask.nii');		 				% GM mask
WM = spm_select('FPList', data_path, '^coregToSUIT_coregToT1_WM_mask.nii'); 		 				% WM mask 
CBmask = spm_select('FPList', data_path, '^coregToSUIT_coregToT1_CB_mask.nii'); 	 			% Whole CB mask  

% template = spm_select('FPList', data_path, '^SUIT_Nobrainstem_2mm.nii');
%----------------------------------------------------------------------------------------------------------------------------------------
% Run SUIT Normalize Dartel 
%----------------------------------------------------------------------------------------------------------------------------------------
clear matlabbatch
matlabbatch{1}.spm.tools.suit.normalise_dartel.subjND.gray = cellstr(GM); 				% GM mask 
matlabbatch{1}.spm.tools.suit.normalise_dartel.subjND.white = cellstr(WM); 				% WM mask 
matlabbatch{1}.spm.tools.suit.normalise_dartel.subjND.isolation = cellstr(CBmask); 		% Whole CB mask 
% matlabbatch{1}.spm.tools.suit.normalise_dartel.template.template = cellstr(template);

% spm_jobman('run',matlabbatch, 'template', template);
spm_jobman('run',matlabbatch)