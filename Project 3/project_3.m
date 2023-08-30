%% *3. MEASURING THE EFFECT OF A SUGAR TAX*
% 
%% *PART 3.1*
% 

% start fresh
clc, clearvars, close all

% import data set

% Set up the Import Options and import the data
opts = spreadsheetImportOptions("NumVariables", 12);

% Specify sheet and range
opts.Sheet = "Data";
opts.DataRange = "A2:L2176";

% Specify column names and types
opts.VariableNames = ["store_id", "type", "store_type", "type2", "size", "price", "price_per_oz", "price_per_oz_c", "taxed", "supp", "time", "product_id"];
opts.VariableTypes = ["double", "categorical", "double", "categorical", "double", "double", "double", "double", "double", "double", "categorical", "double"];

% Specify variable properties
opts = setvaropts(opts, ["type", "type2", "time"], "EmptyFieldRule", "auto");

% Import the data
tempdata1 = readtable("C:\Users\HP\Doing Economics\MATLAB\Project 3\/Dataset Project 3.xlsx", opts, "UseExcel", false);

% Clear temporary variables
clear opts

% Display results
tempdata1
% examine data set
summary(tempdata1);
% format data appropriately
tempdata1.store_id = categorical(tempdata1.store_id);
tempdata1.store_type = categorical(tempdata1.store_type);
tempdata1.store_type(tempdata1.store_type == '1') = 'Large Supermarket';
tempdata1.store_type(tempdata1.store_type == '2') = 'Small Supermarket';
tempdata1.store_type(tempdata1.store_type == '3') = 'Pharmacy';
tempdata1.store_type(tempdata1.store_type == '4') = 'Gas Station';
tempdata1.taxed = categorical(tempdata1.taxed);
tempdata1.taxed(tempdata1.taxed == '0') = 'Nontaxed';
tempdata1.taxed(tempdata1.taxed == '1') = 'Taxed';
tempdata1.supp = categorical(tempdata1.supp);
tempdata1.supp(tempdata1.supp == '0') = 'Standard';
tempdata1.supp(tempdata1.supp == '1') = 'Supplemental';
tempdata1.time(tempdata1.time == 'MAR2015') = 'MAR2016';
tempdata1.product_id = categorical(tempdata1.product_id);

% ensure correctness of formatting
summary(tempdata1);
% calculate number of unique products and stores
products = length(unique(tempdata1.product_id));
stores = length(unique(tempdata1.store_id));
fprintf('no. of unique products: %i\nno. of unique stores: %i', products, stores);
% make frequency table for store_type across time
tcounts1 = varfun(@(x) length(x), tempdata1, 'GroupingVariables', {'store_type' 'time'}, 'InputVariables', {});
tcrosstab1 = unstack(tcounts1, 'GroupCount', 'time');
tcrosstab1.Properties.RowNames = cellstr(tcrosstab1.store_type);
tcrosstab1.store_type = [];
disp(tcrosstab1);
% make frequency table for store_type across taxed in DEC2014
tcounts2 = varfun(@(x) length(x), tempdata1(tempdata1.time == 'DEC2014', :), 'GroupingVariables', {'store_type' 'taxed'}, 'InputVariables', {});
tcrosstab2 = unstack(tcounts2, 'GroupCount', 'taxed');
tcrosstab2.Properties.RowNames = cellstr(tcrosstab2.store_type);
tcrosstab2.store_type = [];
disp(tcrosstab2);
% make frequency table for store_type across taxed in JUN2015
tcounts3 = varfun(@(x) length(x), tempdata1(tempdata1.time == 'JUN2015', :), 'GroupingVariables', {'store_type' 'taxed'}, 'InputVariables', {});
tcrosstab3 = unstack(tcounts3, 'GroupCount', 'taxed');
tcrosstab3.Properties.RowNames = cellstr(tcrosstab3.store_type);
tcrosstab3.store_type = [];
disp(tcrosstab3);
% make frequency table for store_type across taxed in MAR2016
tcounts4 = varfun(@(x) length(x), tempdata1(tempdata1.time == 'MAR2016', :), 'GroupingVariables', {'store_type' 'taxed'}, 'InputVariables', {});
tcrosstab4 = unstack(tcounts4, 'GroupCount', 'taxed');
tcrosstab4.Properties.RowNames = cellstr(tcrosstab4.store_type);
tcrosstab4.store_type = [];
disp(tcrosstab4);
% make frequency table for store_type across taxed
tcounts5 = varfun(@(x) length(x), tempdata1, 'GroupingVariables', {'store_type' 'taxed'}, 'InputVariables', {});
tcrosstab5 = unstack(tcounts5, 'GroupCount', 'taxed');
tcrosstab5.Properties.RowNames = cellstr(tcrosstab5.store_type);
tcrosstab5.store_type = [];
disp(tcrosstab5);
% make frequency table for type across time
tcounts6 = varfun(@(x) length(x), tempdata1, 'GroupingVariables', {'type' 'time'}, 'InputVariables', {});
tcrosstab6 = unstack(tcounts6, 'GroupCount', 'time');
tcrosstab6.Properties.RowNames = cellstr(tcrosstab6.type);
tcrosstab6.type = [];
disp(tcrosstab6);
% get list of product and store ids
pid_list = unique(tempdata1.product_id);
sid_list = unique(tempdata1.store_id);

for i = 1:length(pid_list)
  for j = 1:length(sid_list)
    % pick product-store combination
    temp = tempdata1(tempdata1.product_id == int2str(i) & tempdata1.store_id == int2str(j), :);
    temp_time = temp.time;
    % create boolean for whether current combination exists in each time period
    test = (any(temp_time == 'DEC2014') & any(temp_time == 'JUN2015') & any(temp_time == 'MAR2016'));
    % assign boolean to current combination
    tempdata1.period_test(tempdata1.product_id == pid_list(i) & tempdata1.store_id == sid_list(j)) = test;
  end
end

% create subtable for combinations found in each time period
tempdata2 = tempdata1(tempdata1.period_test == 1 & tempdata1.supp == 'Standard', :)
% calculate mean price based on grouped data
tempdata3 = groupsummary(tempdata2, {'taxed' 'store_type' 'time'}, 'mean', 'price_per_oz')
% create subtable grouped by only taxed and store_type
tempdata4 = unique(tempdata3(:, {'taxed' 'store_type'}));

% create subtables for each time period to allow comparisons
d14 = tempdata3(tempdata3.time == 'DEC2014', :);
j15 = tempdata3(tempdata3.time == 'JUN2015', :);
m16 = tempdata3(tempdata3.time == 'MAR2016', :);

% save differences in means
tempdata4.d1 = j15.mean_price_per_oz - d14.mean_price_per_oz;
tempdata4.d2 = m16.mean_price_per_oz - d14.mean_price_per_oz;
tempdata4
% plot difference in means of DEC2014 and JUN2015 across store types
bar([tempdata4{1, 'd1'} tempdata4{5, 'd1'}; tempdata4{2, 'd1'} tempdata4{6, 'd1'}; tempdata4{3, 'd1'} tempdata4{7, 'd1'}; tempdata4{4, 'd1'} tempdata4{8, 'd1'}]);
title('Average Price Change: DEC2014-JUN2015');
xlabel('store type');
xticklabels(tempdata4.store_type);
ylabel('price change');
legend('nontaxed beverages', 'taxed beverages', 'Location', 'northeast');
% plot difference in means of DEC2014 and MAR2016 across store types
bar([tempdata4{1, 'd2'} tempdata4{5, 'd2'}; tempdata4{2, 'd2'} tempdata4{6, 'd2'}; tempdata4{3, 'd2'} tempdata4{7, 'd2'}; tempdata4{4, 'd2'} tempdata4{8, 'd2'}]);
title('Average Price Change: DEC2014-MAR2016');
xlabel('store type');
xticklabels(tempdata4.store_type);
ylabel('price change');
legend('nontaxed beverages', 'taxed beverages', 'Location', 'northeast');
%% *PART 3.2*
% 

% import data set

% Set up the Import Options and import the data
opts2 = delimitedTextImportOptions("NumVariables", 8);

% Specify range and delimiter
opts2.DataLines = [2, Inf];
opts2.Delimiter = ",";

% Specify column names and types
opts2.VariableNames = ["year", "quarter", "month", "location", "beverage_group", "tax", "price", "under_report"];
opts2.VariableTypes = ["double", "double", "double", "categorical", "categorical", "categorical", "double", "string"];

% Specify file level properties
opts2.ExtraColumnsRule = "ignore";
opts2.EmptyLineRule = "read";

% Specify variable properties
opts2 = setvaropts(opts2, "under_report", "WhitespaceRule", "preserve");
opts2 = setvaropts(opts2, ["location", "beverage_group", "tax", "under_report"], "EmptyFieldRule", "auto");

% Import the data
tempdata5 = readtable("C:\Users\HP\Doing Economics\MATLAB\Project 3\public_use_weighted_prices2.csv", opts2);

% Clear temporary variables
clear opts2

% Display results
tempdata5
% examine data set
summary(tempdata5);
% calculate mean price based on grouped data
tempdata6 = groupsummary(tempdata5, {'year' 'month' 'location' 'tax'}, 'mean', 'price')
% format month variable to get a valid expression for datetime
tempdata6.month = string(num2str(tempdata6.month, '%02.f'));

% create subtables to plot separate line charts
tax_berk = tempdata6(tempdata6.location == 'Berkeley' & tempdata6.tax == 'Taxed', :);
tax_nberk = tempdata6(tempdata6.location == 'Non-Berkeley' & tempdata6.tax == 'Taxed', :);
ntax_berk = tempdata6(tempdata6.location == 'Berkeley' & tempdata6.tax == 'Non-taxed', :);
ntax_nberk = tempdata6(tempdata6.location == 'Non-Berkeley' & tempdata6.tax == 'Non-taxed', :);

% get dates to plot in a time-series fashion
dates = datetime(tax_berk.year + tax_berk.month + '01','InputFormat','yyyyMMdd');

% construct and annotate line charts
plot(dates, tax_berk.mean_price);
hold on;
plot(dates, tax_nberk.mean_price);
plot(dates, ntax_berk.mean_price);
plot(dates, ntax_nberk.mean_price);
title({'Average Price of Taxed and Non-taxed Beverages', 'in Berkeley and Non-Berkeley Areas'});
xlabel('Time');
xline([dates(25) dates(27)]);
ylabel('Average Price');
ylim([4 12]);
hold off;
text(dates(19), 4.5, 'pre-tax', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'top');
text(dates(33), 4.5, 'post-tax', 'HorizontalAlignment', 'center', 'VerticalAlignment', 'top');
legend('taxed | berkeley', 'taxed | non-berkeley', 'non-taxed | berkeley', 'non-taxed | non-berkeley', 'Location', 'northwest');