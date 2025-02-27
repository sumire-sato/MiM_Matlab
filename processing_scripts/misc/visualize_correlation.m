function visualize_correlation(varargin)
parser = inputParser;
parser.KeepUnmatched = true;
% setup defaults in case no arguments specified
addParameter(parser, 'subjects', '')
addParameter(parser, 'group_names', '')
addParameter(parser, 'group_ids', '')
addParameter(parser, 'no_labels', 0)
addParameter(parser, 'save_figures' ,0)
addParameter(parser, 'regressor_variable1', '')
addParameter(parser, 'regressor_variable2', '')
addParameter(parser, 'crunchers_only', '0')
parse(parser, varargin{:})
subjects = parser.Results.subjects;
group_names = parser.Results.group_names;
group_ids = parser.Results.group_ids;
no_labels = parser.Results.no_labels;
save_figures = parser.Results.save_figures;
regressor_variable1 = parser.Results.regressor_variable1;
regressor_variable2 = parser.Results.regressor_variable2;
crunchers_only = parser.Results.crunchers_only;
data_path = pwd;
close all force

group_color_matrix = distinguishable_colors(length(group_names));
% data_path = pwd;
if strcmp(regressor_variable1,'cr_score_mi')
    potential_regressor1_data =  readtable(fullfile(data_path,'spreadsheet_data','cr_score_mi.csv'));
end
if strcmp(regressor_variable1,'cr_score_mi_onlyCrunch')
    potential_regressor1_data =  readtable(fullfile(data_path,'spreadsheet_data','cr_score_mi_onlyCrunch.csv'));
end
if strcmp(regressor_variable1,'maxbeta_score_mi')
    potential_regressor1_data =  readtable(fullfile(data_path,'spreadsheet_data','maxbeta_score_mi.csv'));
end
if strcmp(regressor_variable1,'maxbeta_score_mi_onlyCrunch')
    potential_regressor1_data =  readtable(fullfile(data_path,'spreadsheet_data','maxbeta_score_mi_onlyCrunch.csv'));
end
if strcmp(regressor_variable1,'cr_score_nb')
    potential_regressor1_data =  readtable(fullfile(data_path,'spreadsheet_data','cr_score_nb.csv'));
end
if strcmp(regressor_variable1,'cr_score_nb_onlyCrunch')
    potential_regressor1_data =  readtable(fullfile(data_path,'spreadsheet_data','cr_score_nb_onlyCrunch.csv'));
end
if strcmp(regressor_variable1,'maxbeta_score_nb')
    potential_regressor1_data =  readtable(fullfile(data_path,'spreadsheet_data','maxbeta_score_nb.csv'));
end
if strcmp(regressor_variable1,'maxbeta_score_nb_onlyCrunch')
    potential_regressor1_data =  readtable(fullfile(data_path,'spreadsheet_data','maxbeta_score_nb_onlyCrunch.csv'));
end
if strcmp(regressor_variable1,'400m_walk')
    potential_regressor1_data =  readtable(fullfile(data_path,'spreadsheet_data','400m_walk.csv'));
end
if strcmp(regressor_variable1,'vol_score')
    potential_regressor1_data =  readtable(fullfile(data_path,'spreadsheet_data','vol_score.csv'));
end
if strcmp(regressor_variable1,'within_score')
    potential_regressor1_data =  readtable(fullfile(data_path,'spreadsheet_data','within_score.csv'));
end
if strcmp(regressor_variable1,'between_score')
    potential_regressor1_data =  readtable(fullfile(data_path,'spreadsheet_data','between_score.csv'));
end
if strcmp(regressor_variable1,'seg_score')
    potential_regressor1_data =  readtable(fullfile(data_path,'spreadsheet_data','seg_score.csv'));
end
if strcmp(regressor_variable1,'volTIVcorrected_score')
    potential_regressor1_data =  readtable(fullfile(data_path,'spreadsheet_data','volTIVcorrected_score.csv'));
end
% if strcmp(regressor_variable1,'TM_ml1')
%     potential_regressor1_data =  readtable(fullfile(data_path,'spreadsheet_data','TM_ml1.csv'));
% %       potential_regressor2_data =  readtable(fullfile(data_path,'spreadsheet_data','TM_ml1.csv'));
%     converting_data_pre = table2cell(potential_regressor1_data);
%     clear potential_regressor2_data
%     converting_data_post = [];
%     for i_data_entry = 1:size(converting_data_pre,1) %just chose a condition.. doesnt matter
%         
%         idx = isnan(cell2mat(converting_data_pre(i_data_entry,2:end)));
%         idx = [0 idx];
%         coefs = polyfit(1:sum(~idx),cell2mat(converting_data_pre(i_data_entry,~idx)),1);
%         
%         converting_data_post = [converting_data_post; coefs(1)];
%     end
%     potential_regressor1_data = table(converting_data_pre(:,1), converting_data_post);
%     potential_regressor1_data.Properties.VariableNames = {'subject_ids', 'slope_ml_ptp'};
% end
% if strcmp(regressor_variable1,'TM_ml2')
%     potential_regressor1_data =  readtable(fullfile(data_path,'spreadsheet_data','TM_ml2.csv'));
%     converting_data_pre = table2cell(potential_regressor1_data);
%     clear potential_regressor2_data
%     converting_data_post = [];
%     for i_data_entry = 1:size(converting_data_pre,1) %just chose a condition.. doesnt matter
%         
%         idx = isnan(cell2mat(converting_data_pre(i_data_entry,2:end)));
%         idx = [0 idx];
%         coefs = polyfit(1:sum(~idx),cell2mat(converting_data_pre(i_data_entry,~idx)),1);
%         
%         converting_data_post = [converting_data_post; coefs(1)];
%     end
%     potential_regressor1_data = table(converting_data_pre(:,1), converting_data_post);
%     potential_regressor1_data.Properties.VariableNames = {'subject_ids', 'slope_ml_ptp'};
%     
% end
if strcmp(regressor_variable1,'pain_thresh')
    headers = {'subject_id','PainThreshold_Average','PainInventory_Average','Tactile_Mono','Tactile_Dual'};
    potential_regressor1_data = xlsread('sensory_data.xlsx');
end

if strcmp(regressor_variable2,'cr_score_mi')
    potential_regressor2_data =  readtable(fullfile(data_path,'spreadsheet_data','cr_score_mi.csv'));
end
if strcmp(regressor_variable2,'cr_score_mi_onlyCrunch')
    potential_regressor2_data =  readtable(fullfile(data_path,'spreadsheet_data','cr_score_mi_onlyCrunch.csv'));
end
if strcmp(regressor_variable2,'maxbeta_score_mi')
    potential_regressor2_data =  readtable(fullfile(data_path,'spreadsheet_data','maxbeta_score_mi.csv'));
end
if strcmp(regressor_variable2,'maxbeta_score_mi_onlyCrunch')
    potential_regressor2_data =  readtable(fullfile(data_path,'spreadsheet_data','maxbeta_score_mi_onlyCrunch.csv'));
end
if strcmp(regressor_variable2,'cr_score_nb')
    potential_regressor2_data =  readtable(fullfile(data_path,'spreadsheet_data','cr_score_nb.csv'));
end
if strcmp(regressor_variable2,'cr_score_nb_onlyCrunch')
    potential_regressor2_data =  readtable(fullfile(data_path,'spreadsheet_data','cr_score_nb_onlyCrunch.csv'));
end
if strcmp(regressor_variable2,'maxbeta_score_nb')
    potential_regressor2_data =  readtable(fullfile(data_path,'spreadsheet_data','maxbeta_score_nb.csv'));
end
if strcmp(regressor_variable2,'400m_walk')
    potential_regressor2_data = readtable(fullfile(data_path,'spreadsheet_data','400m_walk.csv'));
    for i_data_entry = 1:length(potential_regressor2_data.time_to_walk_400_meters)
        this_data_entry = potential_regressor2_data.time_to_walk_400_meters{i_data_entry}; 
        split_data_entry = strsplit(this_data_entry, ':');
        if ~(length(split_data_entry) == 1)
            potential_regressor2_data.time_to_walk_400_meters(i_data_entry) = {(str2num(split_data_entry{1}) * 60) + str2num(split_data_entry{2})};
        end
    end
end
if strcmp(regressor_variable2,'vol_score')
    potential_regressor2_data =  readtable(fullfile(data_path,'spreadsheet_data','vol_score.csv'));
end
if strcmp(regressor_variable2,'within_score')
    potential_regressor2_data =  readtable(fullfile(data_path,'spreadsheet_data','within_score.csv'));
end
if strcmp(regressor_variable2,'between_score')
    potential_regressor2_data =  readtable(fullfile(data_path,'spreadsheet_data','between_score.csv'));
end
if strcmp(regressor_variable2,'seg_score')
    potential_regressor2_data =  readtable(fullfile(data_path,'spreadsheet_data','seg_score.csv'));
end
if strcmp(regressor_variable2,'TM_ml1')
    potential_regressor2_data =  readtable(fullfile(data_path,'spreadsheet_data','TM_ml1.csv'));
    converting_data_pre = table2cell(potential_regressor2_data);
    clear potential_regressor2_data
    converting_data_post = [];
    for i_data_entry = 1:size(converting_data_pre,1) %just chose a condition.. doesnt matter
        
        idx = isnan(cell2mat(converting_data_pre(i_data_entry,2:end)));
        idx = [0 idx];
        coefs = polyfit(1:sum(~idx),cell2mat(converting_data_pre(i_data_entry,~idx)),1);
        
        converting_data_post = [converting_data_post; coefs(1)];
    end
    potential_regressor2_data = table(converting_data_pre(:,1), converting_data_post);
    potential_regressor2_data.Properties.VariableNames = {'subject_ids', 'slope_ml_ptp'};
    
end
if strcmp(regressor_variable2,'TM_ml2')
    potential_regressor2_data =  readtable(fullfile(data_path,'spreadsheet_data','TM_ml2.csv'));
    converting_data_pre = table2cell(potential_regressor2_data);
    clear potential_regressor2_data
    converting_data_post = [];
    for i_data_entry = 1:size(converting_data_pre,1) %just chose a condition.. doesnt matter
        
        idx = isnan(cell2mat(converting_data_pre(i_data_entry,2:end)));
        idx = [1 idx];
        coefs = polyfit(1:sum(~idx),cell2mat(converting_data_pre(i_data_entry,find(~idx))),1);
        
        converting_data_post = [converting_data_post; coefs(1)];
    end
    potential_regressor2_data = table(converting_data_pre(:,1), converting_data_post);
    potential_regressor2_data.Properties.VariableNames = {'subject_ids', 'slope_ml_ptp'};
    
end
if strcmp(regressor_variable2,'pain_thresh')
    headers = {'subject_id','PainThreshold_Average','PainInventory_Average','Tactile_Mono','Tactile_Dual'};
    potential_regressor2_data = xlsread('sensory_data.xlsx');
end
xlabel_text = potential_regressor1_data.Properties.VariableNames(2:end);
ylabel_text = potential_regressor2_data.Properties.VariableNames(2:end);

% adjust group ids based on which data is available
adjust_group_id_indices = [];
inclusion_counter = 1;
for this_subject_index = 1 : length(subjects)
   this_subject_row_data_reg1 = find(strcmp(string(table2cell(potential_regressor1_data(:,1))), subjects{this_subject_index}));
   this_subject_row_data_reg2 = find(strcmp(string(table2cell(potential_regressor2_data(:,1))), subjects{this_subject_index}));
   if isempty(this_subject_row_data_reg1) || isempty(this_subject_row_data_reg2) || isempty(table2cell(potential_regressor2_data(this_subject_row_data_reg2,2:end))) || isempty(table2cell(potential_regressor1_data(this_subject_row_data_reg1,2:end))) || ... 
           any(isnan(cell2mat(table2cell(potential_regressor2_data(this_subject_row_data_reg2,2:end))))) || any(isnan(cell2mat(table2cell(potential_regressor1_data(this_subject_row_data_reg1,2:end)))));
       adjust_group_id_indices = [adjust_group_id_indices this_subject_index];
   else
       this_regressor1_data(inclusion_counter,:) = table2cell(potential_regressor1_data(this_subject_row_data_reg1,2:end));
       this_regressor2_data(inclusion_counter,:) = table2cell(potential_regressor2_data(this_subject_row_data_reg2,2:end));
       inclusion_counter = inclusion_counter + 1;
   end
end
group_ids(adjust_group_id_indices) = [];
subjects(adjust_group_id_indices) = [];
this_reg = 1;
for this_reg1_index = 1 : size(potential_regressor1_data,2)-1
    for this_reg2_index = 1 : size(potential_regressor2_data,2)-1
%         allYLim = [];
        figure; hold on;
        for this_group_index = 1 : length(group_names)
            this_group_subjectindices{this_group_index,:} = find(group_ids==this_group_index);
            plot(cell2mat(this_regressor1_data(this_group_subjectindices{this_group_index,:},this_reg1_index))', cell2mat(this_regressor2_data(this_group_subjectindices{this_group_index,:},this_reg2_index))', 'o', 'MarkerEdge', 'k', 'MarkerFace', group_color_matrix(this_group_index, :))
        end
        xLimits = get(gca,'XLim');
        T = [];
        for this_group_index = 1 : length(group_names)     
            if length(this_group_subjectindices{this_group_index,:}) >= 3
                [r , p] = corr(cell2mat(this_regressor1_data(this_group_subjectindices{this_group_index,:},this_reg1_index)), cell2mat(this_regressor2_data(this_group_subjectindices{this_group_index,:},this_reg2_index)));
                r2 = r^2;
                [coefs,S] = polyfit(cell2mat(this_regressor1_data(this_group_subjectindices{this_group_index,:},this_reg1_index)), cell2mat(this_regressor2_data(this_group_subjectindices{this_group_index,:},this_reg2_index)),1);
                
                 fittedX=linspace(min(cell2mat(this_regressor1_data(this_group_subjectindices{this_group_index,:},this_reg1_index))), max(cell2mat(this_regressor1_data(this_group_subjectindices{this_group_index,:},this_reg1_index))), 100);
                 
                [fittedY,fittedY_delta] = polyconf(coefs,fittedX,S);

                shadedErrorBar(fittedX, fittedY, fittedY_delta, {'color', group_color_matrix(this_group_index, :), 'linewidth', 1}, 1);
                
                r_scores(this_reg,this_group_index) = round(r,2);
                slope_scores(this_reg,this_group_index) = round(coefs(1),2);
                
                str=[group_names{this_group_index}, ': ', 'r=',num2str(round(r,2))];
                T = strvcat(T, str);
            end
        end
        legend(group_names)
        coef_text = text(0.1,0.9,T,'Units','normalized','FontSize',12);
        title(strcat(regressor_variable1, '(x)', {' '}, 'vs.', {' '}, regressor_variable2, '(y)') ,'interpreter','latex')
        xlabel(xlabel_text{this_reg1_index},'interpreter','latex')
        ylabel(ylabel_text{this_reg2_index},'interpreter','latex')
        
        d_reg1(this_reg1_index) = computeCohen_d(cell2mat(this_regressor1_data(this_group_subjectindices{1,:},this_reg1_index)), [cell2mat(this_regressor1_data(this_group_subjectindices{2,:},this_reg1_index));cell2mat(this_regressor1_data(this_group_subjectindices{3,:},this_reg1_index))]);
        [p1(this_reg1_index),t1,s1,x1] = anovan(cell2mat(this_regressor1_data(:,1)),{num2str(group_ids')},'varnames', {'Group'});
        
        d_reg2(this_reg2_index) = computeCohen_d(cell2mat(this_regressor2_data(this_group_subjectindices{1,:},this_reg2_index)), [cell2mat(this_regressor2_data(this_group_subjectindices{2,:},this_reg2_index));cell2mat(this_regressor2_data(this_group_subjectindices{3,:},this_reg2_index))]);
        [p2(this_reg2_index),t2,s2,x2] = anovan(cell2mat(this_regressor2_data(:,1)),{num2str(group_ids')},'varnames', {'Group'});
    
        reg_table = table(cell2mat(this_regressor1_data(:,this_reg1_index)), cell2mat(this_regressor2_data(:,this_reg2_index)),num2str(group_ids'));
        reg_table.Properties.VariableNames = {'reg1','reg2','group'};
        
        model = fitlme(reg_table,'reg1~reg2 + group');
        coefTest_p(this_reg) = coefTest(model);
        
        this_reg = this_reg + 1;
        
        if no_labels
            set(get(gca, 'xlabel'), 'visible', 'off');
            set(get(gca, 'ylabel'), 'visible', 'off');
            set(get(gca, 'title'), 'visible', 'off');
%             delete(coef_text);
            legend(gca, 'hide');
        end
        if save_figures
            fig_title = strcat(xlabel_text{this_reg1_index},'_',ylabel_text{this_reg2_index});
            filename =  fullfile(data_path, 'figures', fig_title);
            saveas(gca, filename, 'tiff')
        end
    end
end


display(['reg1 cohen d =', num2str(mean(d_reg1))])
display(['reg2 cohen d =', num2str(mean(d_reg2))])
display(['reg1-reg2 coeff p =', num2str(mean(coefTest_p))])

display(['YA r:' num2str(mean(r_scores(:,1))) ' hOA r:' num2str(mean(r_scores(:,2))) ' lOA r:' num2str(mean(r_scores(:,3)))])
display(['YA m:' num2str(mean(slope_scores(:,1))) ' hOA m:' num2str(mean(slope_scores(:,2))) ' lOA m:' num2str(mean(slope_scores(:,3)))])


end