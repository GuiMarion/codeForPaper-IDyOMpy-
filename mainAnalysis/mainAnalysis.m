%%
cd ..
addpath(genpath('codeForPaper-IDyOMpy-'))
cd codeForPaper-IDyOMpy-

%%
clear;
clc;

folder_IDyOMLisp = "forBenchmark_lisp";
folder_IDyOMpy = "forBenchmark_idyompy";
folder_IDyOMpy_PPM = "forBenchmark_idyompy_ppm";
folder_IDyOMpy_Genuine = "forBenchmark_idyompy_genuine";

%% Load all the files 

% IDyOMpy
Cc_py = load(folder_IDyOMpy + "/Chinese_train_cross_val.mat");
Cb_py = load(folder_IDyOMpy + "/Chinese_train_trained_on_Bach_Pearce.mat");
Bc_py = load(folder_IDyOMpy + "/Bach_Pearce_cross_eval.mat");
Bch_py = load(folder_IDyOMpy + "/Bach_Pearce_trained_on_Chinese_train.mat");
Mm_py = load(folder_IDyOMpy + "/Mixed2_cross_eval.mat");

% Check if exists
if ~exist(fullfile(folder_IDyOMpy, "evolution_Bach_Pearce.mat"), 'file') || ...
   ~exist(fullfile(folder_IDyOMpy, "Jneurosci_trained_on_mixed2.mat"), 'file') || ...
   ~exist(fullfile(folder_IDyOMpy, "eLife_trained_on_mixed2.mat"), 'file')
    disp("One file doesn't exist (IDyOMpy)!!!!")
    return;
end

% IDyOM Lisp
Cc_lisp = load(folder_IDyOMLisp + "/Chinese_train_cross_val.mat");
Cb_lisp = load(folder_IDyOMLisp + "/Chinese_train_trained_on_Bach_Pearce.mat");
Bc_lisp = load(folder_IDyOMLisp + "/Bach_Pearce_cross_eval.mat");
Bch_lisp = load(folder_IDyOMLisp + "/Bach_Pearce_trained_on_Chinese_train.mat");
Mm_lisp = load(folder_IDyOMLisp + "/Mixed2_cross_eval.mat");

% Check if exists
if ~exist(fullfile(folder_IDyOMLisp, "Jneurosci_trained_on_mixed2.mat"), 'file') || ...
   ~exist(fullfile(folder_IDyOMLisp, "eLife_trained_on_mixed2.mat"), 'file')
    disp("One file doesn't exist (LISP)!!!!")
    return;
end

% IDyOMpy PPM
Cc_ppm = load(folder_IDyOMpy_PPM + "/Chinese_train_cross_val.mat");
Cb_ppm = load(folder_IDyOMpy_PPM + "/Chinese_train_trained_on_Bach_Pearce.mat");
Bc_ppm = load(folder_IDyOMpy_PPM + "/Bach_Pearce_cross_eval.mat");
Bch_ppm = load(folder_IDyOMpy_PPM + "/Bach_Pearce_trained_on_Chinese_train.mat");
Mm_ppm = load(folder_IDyOMpy_PPM + "/Mixed2_cross_eval.mat");

% Check if exists
if ~exist(fullfile(folder_IDyOMpy_PPM, "Jneurosci_trained_on_mixed2.mat"), 'file') || ...
   ~exist(fullfile(folder_IDyOMpy_PPM, "eLife_trained_on_mixed2.mat"), 'file')
    disp("One file doesn't exist (IDyOMpy PPM)!!!!")
    return;
end

% IDyOMpy Genuine
Cc_genuine = load(folder_IDyOMpy_Genuine + "/Chinese_train_cross_val.mat");
Cb_genuine = load(folder_IDyOMpy_Genuine + "/Chinese_train_trained_on_Bach_Pearce.mat");
Bc_genuine = load(folder_IDyOMpy_Genuine + "/Bach_Pearce_cross_eval.mat");
Bch_genuine = load(folder_IDyOMpy_Genuine + "/Bach_Pearce_trained_on_Chinese_train.mat");
Mm_genuine = load(folder_IDyOMpy_Genuine + "/Mixed2_cross_eval.mat");

% Check if exists
if ~exist(fullfile(folder_IDyOMpy_Genuine, "Jneurosci_trained_on_mixed2.mat"), 'file') || ...
   ~exist(fullfile(folder_IDyOMpy_Genuine, "eLife_trained_on_mixed2.mat"), 'file')
    disp("One file doesn't exist (IDyOMpy Genuine)!!!!")
    return;
end

%% Sort and clean
% 
% Cc_py = sort_and_clean_struct(Cc_py);
% Cb_py = sort_and_clean_struct(Cb_py);
% Bc_py = sort_and_clean_struct(Bc_py);
% Bch_py = sort_and_clean_struct(Bch_py);
% Mm_py = sort_and_clean_struct(Mm_py);
% 
% Cc_lisp = sort_and_clean_struct(Cc_lisp);
% Cb_lisp = sort_and_clean_struct(Cb_lisp);
% Bc_lisp = sort_and_clean_struct(Bc_lisp);
% Bch_lisp = sort_and_clean_struct(Bch_lisp);
% Mm_lisp = sort_and_clean_struct(Mm_lisp);
% 
% Cc_ppm = sort_and_clean_struct(Cc_ppm);
% Cb_ppm = sort_and_clean_struct(Cb_ppm);
% Bc_ppm = sort_and_clean_struct(Bc_ppm);
% Bch_ppm = sort_and_clean_struct(Bch_ppm);
% Mm_ppm = sort_and_clean_struct(Mm_ppm);
% 
% b_genuine_0 = sort_and_clean_struct(b_genuine_0);
% b_genuine_1 = sort_and_clean_struct(b_genuine_1);

%% Compare Genuine and Approximated

% dataset = 'Bach Chorals';
% approximated = Bc_py;
% genuine = Bc_genuine;

% dataset = 'Chinese Songs';
% approximated = Cc_py;
% genuine = Cc_genuine;

dataset = 'Large Western Dataset';
approximated = Mm_py;
genuine = Mm_genuine;

g0_fields = fieldnames(approximated);
g1_fields = fieldnames(genuine);
common_fields = intersect(g0_fields, g1_fields);
common_fields = common_fields(~strcmp(common_fields, 'info'));

g0_all_ic = [];
g1_all_ic = [];

for i = 1:length(common_fields)
    field = common_fields{i};
    
    g0_data = approximated.(field)(1,:);
    g1_data = genuine.(field)(1,:);

    g0_all_ic = [g0_all_ic, g0_data];
    g1_all_ic = [g1_all_ic, g1_data];
end

figure('Position', [100, 100, 600, 500]);
scatter(g0_all_ic, g1_all_ic, 5, 'filled', 'MarkerFaceAlpha', 0.1);
title(sprintf('IC Correlation Between Different Entropy Calculation Methods \nr = %.4f', corr(g0_all_ic', g1_all_ic')));
xlabel('Genuine Entropy Methods');
ylabel('Approximated Entropy Methods');
xlim([0 20]);
ylim([0 20]);
lsline;

fprintf('Correlation between Genuine 0 and Genuine 1: %.4f\n', corr(g0_all_ic', g1_all_ic'));

%% Compare Raw IC and Entropy

surprise_python = getAllofAFeature(Bc_py, 1); 
surprise_lisp = getAllofAFeature(Bc_lisp, 1); 
surprise_python_ppm = getAllofAFeature(Bc_ppm, 1); 

entropy_python = getAllofAFeature(Bc_py, 2); 
entropy_lisp = getAllofAFeature(Bc_lisp, 2); 
entropy_python_ppm = getAllofAFeature(Bc_ppm, 2); 

% ====== python vs lisp ======
figure; 
scatter(reshape(surprise_python,1,[]), reshape(surprise_lisp,1,[]), 1, 'MarkerEdgeColor',"#64add3", 'MarkerFaceColor',"#e8b6d2"); hold on; 
mdl = fitlm(reshape(surprise_python,1,[]), reshape(surprise_lisp,1,[]));
plot(mdl);
xlabel("IC (IDyOMpy)");
ylabel("IC (IDyOM Lisp)");
legend('off')
title("Paired comparison of IC from IDyOMpy and IDyOM Lisp")

xlim([0, 20])
ylim([0, 20])

figure; 
scatter(reshape(entropy_python,1,[]), reshape(entropy_lisp,1,[]), 1, 'MarkerEdgeColor',"#64add3", 'MarkerFaceColor',"#e8b6d2"); hold on; 
mdl = fitlm(reshape(entropy_python,1,[]), reshape(entropy_lisp,1,[]));
plot(mdl);
xlabel("Entropy (IDyOMpy)");
ylabel("Entropy (IDyOM Lisp)");
legend('off')
title("Paired comparison of Entropy from IDyOMpy and IDyOM Lisp")

disp("Corr IC (Python vs Lisp): " + num2str(corr(surprise_python', surprise_lisp')))
disp("Corr Entropy (Python vs Lisp): " + num2str(corr(entropy_python', entropy_lisp')))

% ====== ppm vs python ======
figure; 
scatter(reshape(surprise_python_ppm,1,[]), reshape(surprise_python,1,[]), 1, 'MarkerEdgeColor',"#64add3", 'MarkerFaceColor',"#e8b6d2"); hold on; 
mdl = fitlm(reshape(surprise_python_ppm,1,[]), reshape(surprise_python,1,[]));
plot(mdl);
xlabel("IC (IDyOMpy PPM)");
ylabel("IC (IDyOMpy)");
legend('off')
title("Paired comparison of IC from IDyOMpy PPM and IDyOMpy")
xlim([0, 20])
ylim([0, 20])

figure; 
scatter(reshape(entropy_python_ppm,1,[]), reshape(entropy_python,1,[]), 1, 'MarkerEdgeColor',"#64add3", 'MarkerFaceColor',"#e8b6d2"); hold on; 
mdl = fitlm(reshape(entropy_python_ppm,1,[]), reshape(entropy_python,1,[]));
plot(mdl);
xlabel("Entropy (IDyOMpy PPM)");
ylabel("Entropy (IDyOMpy)");
legend('off')
title("Paired comparison of Entropy from IDyOMpy PPM and IDyOMpy")

disp("Corr IC (PPM vs Python): " + num2str(corr(surprise_python_ppm', surprise_python')))
disp("Corr Entropy (PPM vs Python): " + num2str(corr(entropy_python_ppm', entropy_python')))

% ====== ppm vs lisp ======
figure; 
scatter(reshape(surprise_python_ppm,1,[]), reshape(surprise_lisp,1,[]), 1, 'MarkerEdgeColor',"#64add3", 'MarkerFaceColor',"#e8b6d2"); hold on; 
mdl = fitlm(reshape(surprise_python_ppm,1,[]), reshape(surprise_lisp,1,[]));
plot(mdl);
xlabel("IC (IDyOMpy PPM)");
ylabel("IC (IDyOM Lisp)");
legend('off')
title("Paired comparison of IC from IDyOMpy PPM and IDyOM Lisp")
xlim([0, 20])
ylim([0, 20])

figure; 
scatter(reshape(entropy_python_ppm,1,[]), reshape(entropy_lisp,1,[]), 1, 'MarkerEdgeColor',"#64add3", 'MarkerFaceColor',"#e8b6d2"); hold on; 
mdl = fitlm(reshape(entropy_python_ppm,1,[]), reshape(entropy_lisp,1,[]));
plot(mdl);
xlabel("Entropy (IDyOMpy PPM)");
ylabel("Entropy (IDyOM Lisp)");
legend('off')
title("Paired comparison of Entropy from IDyOMpy PPM and IDyOM Lisp")

disp("Corr IC (PPM vs Lisp): " + num2str(corr(surprise_python_ppm', surprise_lisp')))
disp("Corr Entropy (PPM vs Lisp): " + num2str(corr(entropy_python_ppm', entropy_lisp')))

%% Compare Raw IC and Entropy (r2)

surprise_python = getAllofAFeature(Bc_py, 1); 
surprise_lisp = getAllofAFeature(Bc_lisp, 1); 
surprise_python_ppm = getAllofAFeature(Bc_ppm, 1); 

entropy_python = getAllofAFeature(Bc_py, 2); 
entropy_lisp = getAllofAFeature(Bc_lisp, 2); 
entropy_python_ppm = getAllofAFeature(Bc_ppm, 2); 

% ====== python vs lisp ======
figure; 
scatter(reshape(surprise_python,1,[]), reshape(surprise_lisp,1,[]), 1, 'MarkerEdgeColor',"#64add3", 'MarkerFaceColor',"#e8b6d2"); hold on; 
mdl = fitlm(reshape(surprise_python,1,[]), reshape(surprise_lisp,1,[]));
plot(mdl);
xlabel("IC (IDyOMpy)");
ylabel("IC (IDyOM Lisp)");
legend('off')
title("Paired comparison of IC from IDyOMpy and IDyOM Lisp")
xlim([0, 20])
ylim([0, 20])
disp("Adjusted R² IC (Python vs Lisp): " + num2str(mdl.Rsquared.Adjusted))

figure; 
scatter(reshape(entropy_python,1,[]), reshape(entropy_lisp,1,[]), 1, 'MarkerEdgeColor',"#64add3", 'MarkerFaceColor',"#e8b6d2"); hold on; 
mdl = fitlm(reshape(entropy_python,1,[]), reshape(entropy_lisp,1,[]));
plot(mdl);
xlabel("Entropy (IDyOMpy)");
ylabel("Entropy (IDyOM Lisp)");
legend('off')
title("Paired comparison of Entropy from IDyOMpy and IDyOM Lisp")
disp("Adjusted R² Entropy (Python vs Lisp): " + num2str(mdl.Rsquared.Adjusted))

% ====== ppm vs python ======
figure; 
scatter(reshape(surprise_python_ppm,1,[]), reshape(surprise_python,1,[]), 1, 'MarkerEdgeColor',"#64add3", 'MarkerFaceColor',"#e8b6d2"); hold on; 
mdl = fitlm(reshape(surprise_python_ppm,1,[]), reshape(surprise_python,1,[]));
plot(mdl);
xlabel("IC (IDyOMpy PPM)");
ylabel("IC (IDyOMpy)");
legend('off')
title("Paired comparison of IC from IDyOMpy PPM and IDyOMpy")
xlim([0, 20])
ylim([0, 20])
disp("Adjusted R² IC (PPM vs Python): " + num2str(mdl.Rsquared.Adjusted))

figure; 
scatter(reshape(entropy_python_ppm,1,[]), reshape(entropy_python,1,[]), 1, 'MarkerEdgeColor',"#64add3", 'MarkerFaceColor',"#e8b6d2"); hold on; 
mdl = fitlm(reshape(entropy_python_ppm,1,[]), reshape(entropy_python,1,[]));
plot(mdl);
xlabel("Entropy (IDyOMpy PPM)");
ylabel("Entropy (IDyOMpy)");
legend('off')
title("Paired comparison of Entropy from IDyOMpy PPM and IDyOMpy")

disp("Adjusted R² Entropy (PPM vs Python): " + num2str(mdl.Rsquared.Adjusted))

% ====== ppm vs lisp ======
figure; 
scatter(reshape(surprise_python_ppm,1,[]), reshape(surprise_lisp,1,[]), 1, 'MarkerEdgeColor',"#64add3", 'MarkerFaceColor',"#e8b6d2"); hold on; 
mdl = fitlm(reshape(surprise_python_ppm,1,[]), reshape(surprise_lisp,1,[]));
plot(mdl);
xlabel("IC (IDyOMpy PPM)");
ylabel("IC (IDyOM Lisp)");
legend('off')
title("Paired comparison of IC from IDyOMpy PPM and IDyOM Lisp")
xlim([0, 20])
ylim([0, 20])
disp("Adjusted R² IC (PPM vs Lisp): " + num2str(mdl.Rsquared.Adjusted))

figure; 
scatter(reshape(entropy_python_ppm,1,[]), reshape(entropy_lisp,1,[]), 1, 'MarkerEdgeColor',"#64add3", 'MarkerFaceColor',"#e8b6d2"); hold on; 
mdl = fitlm(reshape(entropy_python_ppm,1,[]), reshape(entropy_lisp,1,[]));
plot(mdl);
xlabel("Entropy (IDyOMpy PPM)");
ylabel("Entropy (IDyOM Lisp)");
legend('off')
title("Paired comparison of Entropy from IDyOMpy PPM and IDyOM Lisp")

disp("Adjusted R² Entropy (PPM vs Lisp): " + num2str(mdl.Rsquared.Adjusted))


%% Corr IC vs ENTOPY

surprise_python = getAllofAFeature(Bc_py, 1); 
surprise_lisp = getAllofAFeature(Bc_lisp, 1); 
surprise_ppm = getAllofAFeature(Bc_ppm, 1); 

entropy_python = getAllofAFeature(Bc_py, 2); 
entropy_lisp = getAllofAFeature(Bc_lisp, 2); 
entropy_ppm = getAllofAFeature(Bc_ppm, 2); 

figure; 
scatter(reshape(surprise_python,1,[]), reshape(entropy_python,1,[]), 1, 'MarkerEdgeColor',"#64add3", 'MarkerFaceColor',"#e8b6d2"); 
xlabel("IC (IDyOMpy)");
ylabel("Entropy (IDyOMpy)");
title("IC vs ENTR - IDyOMpy")
%xlim([0, 20])
%ylim([0, 20])

figure; 
scatter(reshape(surprise_lisp,1,[]), reshape(entropy_lisp,1,[]), 1, 'MarkerEdgeColor',"#64add3", 'MarkerFaceColor',"#e8b6d2");
xlabel("IC (IDyOM Lisp)");
ylabel("Entropy (IDyOM Lisp)");
title("IC vs ENTR - IDyOM Lisp")

figure; 
scatter(reshape(surprise_ppm,1,[]), reshape(entropy_ppm,1,[]), 1, 'MarkerEdgeColor',"#64add3", 'MarkerFaceColor',"#e8b6d2");
xlabel("IC (IDyOMpy PPM)");
ylabel("Entropy (IDyOMpy PPM)");
title("IC vs Entropy - IDyOMpy PPM")

disp("Corr IDyOMpy: " + num2str(corr(surprise_python', entropy_python')))
disp("Corr Lisp: " + num2str(corr(surprise_lisp', entropy_lisp')))
disp("Corr PPM: " + num2str(corr(surprise_ppm', entropy_ppm')))

%% Generalization error

y = [mean(getGeneralizationError(Cc_lisp)) mean(getGeneralizationError(Cc_py)) mean(getGeneralizationError(Cc_ppm)); 
    mean(getGeneralizationError(Bc_lisp)) mean(getGeneralizationError(Bc_py)) mean(getGeneralizationError(Bc_ppm)); 
    mean(getGeneralizationError(Mm_lisp)) mean(getGeneralizationError(Mm_py)) mean(getGeneralizationError(Mm_ppm))];  % first 3 #s are pre-test, second 3 #s are post-test (previous comment)
err = [std(getGeneralizationError(Cc_lisp))/sqrt(length(getGeneralizationError(Cc_lisp))) std(getGeneralizationError(Cc_py))/sqrt(length(getGeneralizationError(Cc_py))) std(getGeneralizationError(Cc_ppm))/sqrt(length(getGeneralizationError(Cc_ppm))); 
    std(getGeneralizationError(Bc_lisp))/sqrt(length(getGeneralizationError(Bc_lisp))) std(getGeneralizationError(Bc_py))/sqrt(length(getGeneralizationError(Bc_py))) std(getGeneralizationError(Bc_ppm))/sqrt(length(getGeneralizationError(Bc_ppm))); 
    std(getGeneralizationError(Mm_lisp))/sqrt(length(getGeneralizationError(Mm_lisp))) std(getGeneralizationError(Mm_py))/sqrt(length(getGeneralizationError(Mm_py))) std(getGeneralizationError(Mm_ppm))/sqrt(length(getGeneralizationError(Mm_ppm)))];

% Plot
figure(); 
hb = bar(y); % get the bar handles
% hb = bar(y, 'grouped');
hold on;

% colors
hb(1).FaceColor = [0.95, 0.70, 0.85];
hb(2).FaceColor = [0.60, 0.75, 0.85]; 
hb(3).FaceColor = [0.7, 0.9, 0.7];   

% error bars
numGroups = size(y, 1);
numBars = size(y, 2);
groupwidth = min(0.8, numBars/(numBars + 1.5));

for i = 1:numBars
    % get x positions per group
    x = (1:numGroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numBars);
    % draw errorbar
    errorbar(x, y(:,i), err(:,i), 'k', 'linestyle', 'none', 'linewidth', 1.5);
end

% axes
set(gca,'xticklabel',{'Chinese Songs'; 'Bach Chorals'; 'Large Western Database'});
legend("IDyOM Lisp", "IDyOMpy", 'IDyOMpy PPM')
ylabel('Mean IC (generalization error)')
%xlabel('Session')
title('Generalization Error on Different Datasets')

ranksum(getGeneralizationError(Cc_lisp), getGeneralizationError(Cc_py))
ranksum(getGeneralizationError(Bc_lisp), getGeneralizationError(Bc_py))
ranksum(getGeneralizationError(Mm_lisp), getGeneralizationError(Mm_py))

%% Entropy
y_entropy = [mean(getEntropy(Cc_lisp)) mean(getEntropy(Cc_py)) mean(getEntropy(Cc_ppm)); 
    mean(getEntropy(Bc_lisp)) mean(getEntropy(Bc_py)) mean(getEntropy(Bc_ppm)); 
    mean(getEntropy(Mm_lisp)) mean(getEntropy(Mm_py)) mean(getEntropy(Mm_ppm))];

err_entropy = [std(getEntropy(Cc_lisp))/sqrt(length(getEntropy(Cc_lisp))) std(getEntropy(Cc_py))/sqrt(length(getEntropy(Cc_py))) std(getEntropy(Cc_ppm))/sqrt(length(getEntropy(Cc_ppm))); 
    std(getEntropy(Bc_lisp))/sqrt(length(getEntropy(Bc_lisp))) std(getEntropy(Bc_py))/sqrt(length(getEntropy(Bc_py))) std(getEntropy(Bc_ppm))/sqrt(length(getEntropy(Bc_ppm))); 
    std(getEntropy(Mm_lisp))/sqrt(length(getEntropy(Mm_lisp))) std(getEntropy(Mm_py))/sqrt(length(getEntropy(Mm_py))) std(getEntropy(Mm_ppm))/sqrt(length(getEntropy(Mm_ppm)))];

% Plot
figure(); 
hb = bar(y_entropy); 
hold on;

% colors
hb(1).FaceColor = [0.95, 0.70, 0.85];  % Pink for Lisp
hb(2).FaceColor = [0.60, 0.75, 0.85];  % Blue for Python
hb(3).FaceColor = [0.7, 0.9, 0.7];     % Green for PPM

% error bars
numGroups = size(y_entropy, 1);
numBars = size(y_entropy, 2);
groupwidth = min(0.8, numBars/(numBars + 1.5));

for i = 1:numBars
    % get x positions per group
    x = (1:numGroups) - groupwidth/2 + (2*i-1) * groupwidth / (2*numBars);
    % draw errorbar
    errorbar(x, y_entropy(:,i), err_entropy(:,i), 'k', 'linestyle', 'none', 'linewidth', 1.5);
end

% axes
set(gca,'xticklabel',{'Chinese Songs'; 'Bach Chorals'; 'Large Western Database'});
legend("IDyOM Lisp", "IDyOMpy", 'IDyOMpy PPM')
ylabel('Mean Entropy')
title('Entropy Approximation on Different Datasets')

% Statistical tests
ranksum(getEntropy(Cc_lisp), getEntropy(Cc_py))
ranksum(getEntropy(Bc_lisp), getEntropy(Bc_py))
ranksum(getEntropy(Mm_lisp), getEntropy(Mm_py))
% 
% y = [mean(getGeneralizationError(Cc_lisp)) mean(getGeneralizationError(Cc_py)); mean(getGeneralizationError(Bc_lisp)) mean(getGeneralizationError(Bc_py)); mean(getGeneralizationError(Mm_lisp)) mean(getGeneralizationError(Mm_py))];  % first 3 #s are pre-test, second 3 #s are post-test
% err = [std(getGeneralizationError(Cc_lisp))/sqrt(length(getGeneralizationError(Cc_lisp))) std(getGeneralizationError(Cc_py))/sqrt(length(getGeneralizationError(Cc_py))); std(getGeneralizationError(Bc_lisp))/sqrt(length(getGeneralizationError(Bc_lisp))) std(getGeneralizationError(Bc_py))/sqrt(length(getGeneralizationError(Bc_py))); std(getGeneralizationError(Mm_lisp))/sqrt(length(getGeneralizationError(Mm_lisp))) std(getGeneralizationError(Mm_py))/sqrt(length(getGeneralizationError(Mm_py)))];
% 
% % Plot
% figure(); 
% hb = bar(y); % get the bar handles
% hold on;
% for k = 1:size(y,2)
%     % get x positions per group
%     xpos = hb(k).XData + hb(k).XOffset;
%     % draw errorbar
%     errorbar(xpos, y(:,k), err(:,k), 'LineStyle', 'none', ... 
%         'Color', 'k', 'LineWidth', 1);
% end
% 
% % Set Axis properties
% set(gca,'xticklabel',{'Chinese Songs'; 'Bach Chorals'; 'Large Western Database'});
% legend("IDyOM Lisp", "IDyOMpy")
% %ylim([200 360])
% ylabel('Generalization Error (-log(p)')
% %xlabel('Session')
% 
% ranksum(getGeneralizationError(Cc_lisp), getGeneralizationError(Cc_py))
% ranksum(getGeneralizationError(Bc_lisp), getGeneralizationError(Bc_py))
% ranksum(getGeneralizationError(Mm_lisp), getGeneralizationError(Mm_py))

%% Generalization Error Over Training

load(folder_IDyOMpy+"/evolution_Bach_Pearce.mat")

figure;
errorbar(note_counter, mean(matrix, 2), std(matrix, [], 2)/sqrt(size(matrix, 2)), 'Color','#64ADD3')
title("Evolution of the mean IC during Learning")
ylabel("Mean IC (generlization error)")
xlabel("Learning (in notes)")
yline(mean(getGeneralizationError(Bc_lisp)), 'Color','#E8B6D2')

legend("IDyOMpy", "IDyOM Lisp")

%% Cultural Clustering

score_idyompy = clustering_eval(Cc_py, Cb_py, Bc_py, Bch_py,'Cultural Clustering for IDyOMPy');
score_idyom_lisp= clustering_eval(Cc_lisp, Cb_lisp, Bc_lisp, Bch_lisp, 'Cultural Clustering for IDyOM Lisp');
score_idyompy_ppm= clustering_eval(Cc_ppm, Cb_ppm, Bc_ppm, Bch_ppm, 'Cultural Clustering for IDyOMPy PPM');
score_idyompy_genuine = clustering_eval(Cc_genuine, Cb_genuine, Bc_genuine, Bch_genuine, 'Cultural Clustering for IDyOMPy Genuine');

%% Show Cultural Clustering table
results_table = table();
results_table = [results_table; {score_idyompy.Inter_Cultural_Distance, score_idyompy.Intra_Cultural_Distance_A, score_idyompy.Intra_Cultural_Distance_B, score_idyompy.Clustering_Index}];
results_table = [results_table; {score_idyom_lisp.Inter_Cultural_Distance, score_idyom_lisp.Intra_Cultural_Distance_A, score_idyom_lisp.Intra_Cultural_Distance_B, score_idyom_lisp.Clustering_Index}];
results_table = [results_table; {score_idyompy_ppm.Inter_Cultural_Distance, score_idyompy_ppm.Intra_Cultural_Distance_A, score_idyompy_ppm.Intra_Cultural_Distance_B, score_idyompy_ppm.Clustering_Index}];
results_table = [results_table; {score_idyompy_genuine.Inter_Cultural_Distance, score_idyompy_genuine.Intra_Cultural_Distance_A, score_idyompy_genuine.Intra_Cultural_Distance_B, score_idyompy_genuine.Clustering_Index}];
results_table.Properties.VariableNames = {'Inter-Cultural Distance', 'Intra-Cultural Distance on A', 'Intra-Cultural Distance on B', 'Clustering Index'};

% show table
disp(results_table);

% plot
figure('Position', [100, 100, 600, 200]);

t = uitable('Data', table2cell(results_table), ...
            'ColumnName', results_table.Properties.VariableNames, ...
            'RowName', {'IDyOMPy', 'IDyOM Lisp', 'IDyOMPy PPM', 'IDyOMPy Genuine'}, ...
            'Units', 'Normalized', ...
            'Position', [0, 0, 1, 1]);

t.ColumnWidth = {150, 150, 150, 150};

title('Table 1: Cultural Classification Metrics for Both Models.');

%% EEG Decoding

% r_idyompy_JNeurosci = corrJNeurosci(folder_IDyOMpy+"/Jneurosci_trained_on_mixed2.mat");
idyompy_JNeurosci = load(folder_IDyOMpy + "/Jneurosci_trained_on_mixed2.mat");
r_idyompy_JNeurosci = corrJNeurosci(idyompy_JNeurosci);

% r_idyom_lisp_JNeurosci = corrJNeurosci(folder_IDyOMLisp+"/Jneurosci_trained_on_mixed2.mat");
idyom_lisp_JNeurosci = load(folder_IDyOMLisp + "/Jneurosci_trained_on_mixed2.mat");
r_idyom_lisp_JNeurosci = corrJNeurosci(folder_IDyOMLisp);

%% Save
save("savings/"+date+"_"+folder_IDyOMpy+"_"+folder_IDyOMLisp+".mat", "score_idyompy" ,"r_idyompy_JNeurosci", "score_idyom_lisp", "r_idyom_lisp_JNeurosci")

%% Plots

color1 = sscanf("E8B6D2",'%2x%2x%2x',[1 3])/255;
color2 = sscanf("64ADD3",'%2x%2x%2x',[1 3])/255;

figure; 
violinplot([mean(r_idyom_lisp_JNeurosci, [2, 3]), mean(r_idyompy_JNeurosci, [2, 3])], ["IDyOM Lisp", "IDyOMpy"],  'ViolinColor', [color1; color2]); hold on; 
ylabel("Pearson's correlation")
title("JNeurosci (on mixed2)")

% figure; 
% violinplot([mean(r_idyom_lisp_eLife, [2,3]), mean(r_idyompy_eLife, [2,3])], ["IDyOM Lisp", "IDyOMpy"],  'ViolinColor', [color1; color2]); hold on; 
% ylabel("Pearson's correlation")
% title("eLife (on mixed2)")

disp("Trained on Mixed 2")
ranksum(reshape(r_idyom_lisp_JNeurosci,1,[]), reshape(r_idyompy_JNeurosci,1,[]))
%ranksum(reshape(r_idyom_lisp_eLife,1,[]),reshape(r_idyompy_eLife,1,[]))

%% Plot Bach Pearce

figure; 
violinplot([mean(r_idyom_lisp_JNeurosci_bach_pearce, [2, 3]), mean(r_idyompy_JNeurosci_bach_pearce, [2, 3])], ["IDyOM Lisp", "IDyOMpy"],  'ViolinColor', [color1; color2]); hold on; 
ylabel("Pearson's correlation")
title("JNeurosci (bach pearce)")


disp("Trained on Bach Pearce")
ranksum(reshape(r_idyom_lisp_JNeurosci_bach_pearce,1,[]), reshape(r_idyompy_JNeurosci_bach_pearce,1,[]))

%% Comparision 

figure; 
scatter(reshape(r_idyom_lisp_JNeurosci,1,[]), reshape(r_idyompy_JNeurosci,1,[])); 
xlabel("IDyOM Lisp Pearson's r");
ylabel("IDyOMpy Pearson's r");
title("JNeurosci")

%% Plot Final eLife (from Gio)

color1 = sscanf("E8B6D2",'%2x%2x%2x',[1 3])/255;
color2 = sscanf("64ADD3",'%2x%2x%2x',[1 3])/255;

figure; 
violinplot([mean(resR(:,:,2), [2,3]), mean(resR(:,:,3), [2,3])], ["IDyOM Lisp", "IDyOMpy"],  'ViolinColor', [color1; color2]); hold on; 
% for i=1:20
%     plot([1, 2], [mean(resR(i,:,2), [2,3]), mean(resR(i,:,2), [2,3])]); hold on; 
% end

ylabel("Pearson's correlation")
title("eLife (on mixed2)")

disp("Trained on Mixed 2")
ranksum(reshape(resR(:,:,2),1,[]),reshape(resR(:,:,3),1,[]))

%% Final JNeuro
color1 = sscanf("E8B6D2",'%2x%2x%2x',[1 3])/255;
color2 = sscanf("64ADD3",'%2x%2x%2x',[1 3])/255;

figure; 
violinplot([mean(r_idyom_lisp_JNeurosci, [2, 3]), mean(r_idyompy_JNeurosci, [2, 3])], ["IDyOM Lisp", "IDyOMpy"],  'ViolinColor', [color1; color2]); hold on; 
for i=1:20
    plot([1, 2], [mean(r_idyom_lisp_JNeurosci, [2,3]), mean(r_idyom_lisp_JNeurosci, [2,3])]); hold on; 
end
ylabel("Pearson's correlation")
title("JNeurosci (on mixed2)")



%%
function sorted_struct = sort_and_clean_struct(input_struct)
    % remove info field
    if isfield(input_struct, 'info')
        input_struct = rmfield(input_struct, 'info');
    end
    % get field names
    field_names = fieldnames(input_struct);
    sorted_fields = sort(field_names);
    % new struct with sorted fields
    sorted_struct = orderfields(input_struct, sorted_fields);
    % remove fields with infinite values
    is_finite = structfun(@(x) all(isfinite(x(:))), sorted_struct);
    sorted_struct = rmfield(sorted_struct, sorted_fields(~is_finite));
end


function print_non_matched_fields(lisp_fields, ppm_fields, py_fields, common_fields)
    all_fields = unique([lisp_fields; ppm_fields; py_fields]);
    non_matched = setdiff(all_fields, common_fields);
    if ~isempty(non_matched)
        fprintf('Error: there are unmatched fields:\n');
        for i = 1:length(non_matched)
            field = non_matched{i};
            in_lisp = ismember(field, lisp_fields);
            in_ppm = ismember(field, ppm_fields);
            in_py = ismember(field, py_fields);
            fprintf('%s: LISP: %d, PPM: %d, Py: %d\n', field, in_lisp, in_ppm, in_py);
        end
    else
        fprintf('All fields are matched.\n');
    end
end
