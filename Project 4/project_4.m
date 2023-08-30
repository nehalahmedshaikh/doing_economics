%% *4. MEASURING WELLBEING*
% 
%% *PART 4.1*
% 

% start fresh
clc, clearvars, close all

% import data set
tempdata1 = readtable('Download-GDPconstant-USD-countries.xlsx', Sheet = 'Download-GDPconstant-USD-countr', ReadVariableNames = true, VariableNamingRule = 'preserve', TextType='string');
tempdata1
% filter to get only final consumption expenditure
tempdata2 = tempdata1(tempdata1.IndicatorName == 'Final consumption expenditure', :);

% get number of nonmissing values
tempdata2.NumAvailable = NaN(height(tempdata2), 1);
for i = 1:height(tempdata2)
    tempdata2(i, :).NumAvailable = sum(~ismissing(tempdata2(i, :))) - 3;
end

% create frequency table
freq_table = tempdata2(:, {'Country' 'NumAvailable'});
disp(freq_table);
% get number of countries with no missing value
full_data = sum(tempdata2.NumAvailable == 52);
fprintf('number of countries with complete data: %i', full_data);
% calculate net exports for three countries
nx_afg = table2array(tempdata1(tempdata1.Country == 'Afghanistan' & tempdata1.IndicatorName == 'Exports of goods and services', 4:55) ...
                     - tempdata1(tempdata1.Country == 'Afghanistan' & tempdata1.IndicatorName == 'Imports of goods and services', 4:55));
nx_alb = table2array(tempdata1(tempdata1.Country == 'Albania' & tempdata1.IndicatorName == 'Exports of goods and services', 4:55) ...
                     - tempdata1(tempdata1.Country == 'Albania' & tempdata1.IndicatorName == 'Imports of goods and services', 4:55));
nx_alg = table2array(tempdata1(tempdata1.Country == 'Algeria' & tempdata1.IndicatorName == 'Exports of goods and services', 4:55) ...
                     - tempdata1(tempdata1.Country == 'Algeria' & tempdata1.IndicatorName == 'Imports of goods and services', 4:55));

% create table to show net exports per year
years = linspace(1970, 2021, 52);
net_exports = table(years.', nx_afg.', nx_alb.', nx_alg.', 'VariableNames', {'Year' 'NX | Afghanistan' 'NX | Albania' 'NX | Algeria'});
disp(net_exports);
% filter to get relevant data for two countries
tempdata3 = tempdata1((tempdata1.Country == 'Afghanistan' | tempdata1.Country == 'Albania') ...
                       & (tempdata1.IndicatorName == 'Household consumption expenditure (including Non-profit institutions serving households)' ...
                       | tempdata1.IndicatorName == 'General government final consumption expenditure' ...
                       | tempdata1.IndicatorName == 'Gross capital formation'), :);
% append net exports
tempdata3(end + 1, :) = tempdata3(1, :);
tempdata3(end, 'IndicatorName') = array2table({'Net Exports'});
tempdata3(end, 4:55) = array2table(nx_afg);
tempdata3(end + 1, :) = tempdata3(4, :);
tempdata3(end, 'IndicatorName') = array2table({'Net Exports'});
tempdata3(end, 4:55) = array2table(nx_alb);

% get values in billions and sort according to id
tempdata3(:, 4:55) = tempdata3(:, 4:55) ./ 1e9;
tempdata3 = sortrows(tempdata3, 'CountryID');
tempdata3
% get indicator names as columns and years as rows
tempdata4 = array2table(transpose(table2array(tempdata3(:, 4:55))), ...
                        'VariableNames', {'C_Afghanistan', 'G_Afghanistan', 'I_Afghanistan', 'NX_Afghanistan', ...
                        'C_Albania', 'G_Albania', 'I_Albania', 'NX_Albania', });
tempdata4
% plot GDP components for afghanistan
plot(years, tempdata4.C_Afghanistan);
hold on;
plot(years, tempdata4.G_Afghanistan);
plot(years, tempdata4.I_Afghanistan);
plot(years, tempdata4.NX_Afghanistan);
title('GDP Components for Afghanistan');
xlabel('year');
ylabel('value (in billions)');
hold off;
legend('Consumption', 'Government Expenditure', 'Investment', 'Net Exports', 'Location', 'northwest');
% plot GDP components for albania
plot(years, tempdata4.C_Albania);
hold on;
plot(years, tempdata4.G_Albania);
plot(years, tempdata4.I_Albania);
plot(years, tempdata4.NX_Albania);
title('GDP Components for Albania');
xlabel('year');
ylabel('value (in billions)');
hold off;
legend('Consumption', 'Government Expenditure', 'Investment', 'Net Exports', 'Location', 'northwest');
% calculate GDP components as proportions for both countries
tempdata4.CP_Afghanistan = tempdata4.C_Afghanistan ./ sum(tempdata4{:, 1:4}, 2);
tempdata4.GP_Afghanistan = tempdata4.G_Afghanistan ./ sum(tempdata4{:, 1:4}, 2);
tempdata4.IP_Afghanistan = tempdata4.I_Afghanistan ./ sum(tempdata4{:, 1:4}, 2);
tempdata4.NXP_Afghanistan = tempdata4.NX_Afghanistan ./ sum(tempdata4{:, 1:4}, 2);
tempdata4.CP_Albania = tempdata4.C_Albania ./ sum(tempdata4{:, 5:8}, 2);
tempdata4.GP_Albania = tempdata4.G_Albania ./ sum(tempdata4{:, 5:8}, 2);
tempdata4.IP_Albania = tempdata4.I_Albania ./ sum(tempdata4{:, 5:8}, 2);
tempdata4.NXP_Albania = tempdata4.NX_Albania ./ sum(tempdata4{:, 5:8}, 2);
tempdata4
% plot GDP components' proportions for afghanistan
plot(years, tempdata4.CP_Afghanistan);
hold on;
plot(years, tempdata4.GP_Afghanistan);
plot(years, tempdata4.IP_Afghanistan);
plot(years, tempdata4.NXP_Afghanistan);
title('GDP Components for Afghanistan');
xlabel('year');
ylabel('proportion');
hold off;
legend('Consumption', 'Government Expenditure', 'Investment', 'Net Exports', 'Location', 'northwest');
% plot GDP components' proportions for albania
plot(years, tempdata4.CP_Albania);
hold on;
plot(years, tempdata4.GP_Albania);
plot(years, tempdata4.IP_Albania);
plot(years, tempdata4.NXP_Albania);
title('GDP Components for Albania');
xlabel('year');
ylabel('proportion');
hold off;
legend('Consumption', 'Government Expenditure', 'Investment', 'Net Exports', 'Location', 'northwest');
% calculate net exports for three developed countries
nx_fra = table2array(tempdata1(tempdata1.Country == 'France' & tempdata1.IndicatorName == 'Exports of goods and services', 2015 - 1966) ...
                     - tempdata1(tempdata1.Country == 'France' & tempdata1.IndicatorName == 'Imports of goods and services', 2015 - 1966));
nx_ger = table2array(tempdata1(tempdata1.Country == 'Germany' & tempdata1.IndicatorName == 'Exports of goods and services', 2015 - 1966) ...
                     - tempdata1(tempdata1.Country == 'Germany' & tempdata1.IndicatorName == 'Imports of goods and services', 2015 - 1966));
nx_ita = table2array(tempdata1(tempdata1.Country == 'Italy' & tempdata1.IndicatorName == 'Exports of goods and services', 2015 - 1966) ...
                     - tempdata1(tempdata1.Country == 'Italy' & tempdata1.IndicatorName == 'Imports of goods and services', 2015 - 1966));

% get other relevant data
tempdata5 = tempdata1((tempdata1.Country == 'France' | tempdata1.Country == 'Germany' | tempdata1.Country == 'Italy') ...
                       & (tempdata1.IndicatorName == 'Household consumption expenditure (including Non-profit institutions serving households)' ...
                       | tempdata1.IndicatorName == 'General government final consumption expenditure' ...
                       | tempdata1.IndicatorName == 'Gross capital formation'), {'CountryID' 'Country' 'IndicatorName' '2015'});

% append net exports
tempdata5(end + 1, :) = tempdata5(1, :);
tempdata5(end, 'IndicatorName') = array2table({'Net Exports'});
tempdata5(end, 4) = array2table(nx_fra);
tempdata5(end + 1, :) = tempdata5(4, :);
tempdata5(end, 'IndicatorName') = array2table({'Net Exports'});
tempdata5(end, 4) = array2table(nx_ger);
tempdata5(end + 1, :) = tempdata5(7, :);
tempdata5(end, 'IndicatorName') = array2table({'Net Exports'});
tempdata5(end, 4) = array2table(nx_ita);

% get values in billions and sort according to id
tempdata5(:, 4) = tempdata5(:, 4) ./ 1e9;
tempdata5 = sortrows(tempdata5, 'CountryID');
tempdata5
% calculate net exports for three transitioning countries
nx_geo = table2array(tempdata1(tempdata1.Country == 'Georgia' & tempdata1.IndicatorName == 'Exports of goods and services', 2015 - 1966) ...
                     - tempdata1(tempdata1.Country == 'Georgia' & tempdata1.IndicatorName == 'Imports of goods and services', 2015 - 1966));
nx_taj = table2array(tempdata1(tempdata1.Country == 'Tajikistan' & tempdata1.IndicatorName == 'Exports of goods and services', 2015 - 1966) ...
                     - tempdata1(tempdata1.Country == 'Tajikistan' & tempdata1.IndicatorName == 'Imports of goods and services', 2015 - 1966));
nx_ukr = table2array(tempdata1(tempdata1.Country == 'Ukraine' & tempdata1.IndicatorName == 'Exports of goods and services', 2015 - 1966) ...
                     - tempdata1(tempdata1.Country == 'Ukraine' & tempdata1.IndicatorName == 'Imports of goods and services', 2015 - 1966));

% get other relevant data
tempdata6 = tempdata1((tempdata1.Country == 'Georgia' | tempdata1.Country == 'Tajikistan' | tempdata1.Country == 'Ukraine') ...
                       & (tempdata1.IndicatorName == 'Household consumption expenditure (including Non-profit institutions serving households)' ...
                       | tempdata1.IndicatorName == 'General government final consumption expenditure' ...
                       | tempdata1.IndicatorName == 'Gross capital formation'), {'CountryID' 'Country' 'IndicatorName' '2015'});

% append net exports
tempdata6(end + 1, :) = tempdata6(1, :);
tempdata6(end, 'IndicatorName') = array2table({'Net Exports'});
tempdata6(end, 4) = array2table(nx_geo);
tempdata6(end + 1, :) = tempdata6(4, :);
tempdata6(end, 'IndicatorName') = array2table({'Net Exports'});
tempdata6(end, 4) = array2table(nx_taj);
tempdata6(end + 1, :) = tempdata6(7, :);
tempdata6(end, 'IndicatorName') = array2table({'Net Exports'});
tempdata6(end, 4) = array2table(nx_ukr);

% get values in billions and sort according to id
tempdata6(:, 4) = tempdata6(:, 4) ./ 1e9;
tempdata6 = sortrows(tempdata6, 'CountryID');
tempdata6
% calculate net exports for three developing countries
nx_ban = table2array(tempdata1(tempdata1.Country == 'Bangladesh' & tempdata1.IndicatorName == 'Exports of goods and services', 2015 - 1966) ...
                     - tempdata1(tempdata1.Country == 'Bangladesh' & tempdata1.IndicatorName == 'Imports of goods and services', 2015 - 1966));
nx_ind = table2array(tempdata1(tempdata1.Country == 'India' & tempdata1.IndicatorName == 'Exports of goods and services', 2015 - 1966) ...
                     - tempdata1(tempdata1.Country == 'India' & tempdata1.IndicatorName == 'Imports of goods and services', 2015 - 1966));
nx_pak = table2array(tempdata1(tempdata1.Country == 'Pakistan' & tempdata1.IndicatorName == 'Exports of goods and services', 2015 - 1966) ...
                     - tempdata1(tempdata1.Country == 'Pakistan' & tempdata1.IndicatorName == 'Imports of goods and services', 2015 - 1966));

% get other relevant data
tempdata7 = tempdata1((tempdata1.Country == 'Bangladesh' | tempdata1.Country == 'India' | tempdata1.Country == 'Pakistan') ...
                       & (tempdata1.IndicatorName == 'Household consumption expenditure (including Non-profit institutions serving households)' ...
                       | tempdata1.IndicatorName == 'General government final consumption expenditure' ...
                       | tempdata1.IndicatorName == 'Gross capital formation'), {'CountryID' 'Country' 'IndicatorName' '2015'});

% append net exports
tempdata7(end + 1, :) = tempdata7(1, :);
tempdata7(end, 'IndicatorName') = array2table({'Net Exports'});
tempdata7(end, 4) = array2table(nx_ban);
tempdata7(end + 1, :) = tempdata7(4, :);
tempdata7(end, 'IndicatorName') = array2table({'Net Exports'});
tempdata7(end, 4) = array2table(nx_ind);
tempdata7(end + 1, :) = tempdata7(7, :);
tempdata7(end, 'IndicatorName') = array2table({'Net Exports'});
tempdata7(end, 4) = array2table(nx_pak);

% get values in billions and sort according to id
tempdata7(:, 4) = tempdata7(:, 4) ./ 1e9;
tempdata7 = sortrows(tempdata7, 'CountryID');
tempdata7
% create matrix of proportions to be used for stacked bar chart
bar_matrix = [table2array(tempdata5(1:4, 4)).' ./ sum(tempdata5.("2015")(1:4), 1);
              table2array(tempdata5(5:8, 4)).' ./ sum(tempdata5.("2015")(5:8), 1);
              table2array(tempdata5(9:12, 4)).' ./ sum(tempdata5.("2015")(9:12), 1);
              table2array(tempdata6(1:4, 4)).' ./ sum(tempdata6.("2015")(1:4), 1);
              table2array(tempdata6(5:8, 4)).' ./ sum(tempdata6.("2015")(5:8), 1);
              table2array(tempdata6(9:12, 4)).' ./ sum(tempdata6.("2015")(9:12), 1);
              table2array(tempdata7(1:4, 4)).' ./ sum(tempdata7.("2015")(1:4), 1);
              table2array(tempdata7(5:8, 4)).' ./ sum(tempdata7.("2015")(5:8), 1);
              table2array(tempdata7(9:12, 4)).' ./ sum(tempdata7.("2015")(9:12), 1)];

% plot the stacked bar chart
bar(bar_matrix, 'stacked', 'Horizontal','on');
title('GDP Components'' Proportions for 2015');
xlabel('proportion');
ylabel('country');
yticklabels({'France', 'Germany', 'Italy', 'Georgia', 'Tajikistan', 'Ukraine', 'Bangladesh', 'India', 'Pakistan'});
legend('Consumption', 'Government Expenditure', 'Investment', 'Net Exports', 'Location', 'eastoutside');
%% *PART 4.2:*
% 

% start fresh
clc, clearvars, close all

% import and format data set
tempdata8 = readtable('HDR21-22_Statistical_Annex_HDI_Table.xlsx', Sheet = 'Table 1' ,ReadVariableNames = false, VariableNamingRule = 'preserve', TextType='string', Range='A9:O202');
tempdata8 = tempdata8(~isnan(tempdata8.Var1), [1 2 3 5 7 9 11 13 15]);
tempdata8.Properties.VariableNames = {'hdi_rank_2021', 'country', 'hdi_value', 'life_exp_years', 'exp_years_school', 'mean_years_school', 'gni_capita', 'gni_hdi_rank', 'hdi_rank_2020'};
tempdata8.hdi_value = round(tempdata8.hdi_value, 3);
tempdata8.life_exp_years = round(tempdata8.life_exp_years, 1);
tempdata8.exp_years_school = round(tempdata8.exp_years_school, 1);
tempdata8.mean_years_school = round(tempdata8.mean_years_school, 1);
tempdata8
% calculate health index
health_idx = (tempdata8.life_exp_years - 20) / (85 - 20);

% calculate education index
exp_school = min([tempdata8.exp_years_school / 18 ones(191, 1)].').';
mean_school = tempdata8.mean_years_school / 15;
edu_idx = (exp_school + mean_school) / 2;

% calculate income index
inc_idx = (log(tempdata8.gni_capita) - log(100)) / (log(75000) - log(100));

% calculate hdi
hdi = round((health_idx .* edu_idx .* inc_idx).^(1/3), 3);
hdi.'