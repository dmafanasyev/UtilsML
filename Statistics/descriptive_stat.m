function [ stat ] = descriptive_stat( data, doPrint, titles, formatSpec)
    %DESCRIPTIVE_STAT Compute the descriptive statistics of data
    %
    %   Input:
    %       data - data for descriptive statistics compute
    %       doPrint - flag for LaTeX table print, default is 0 (no print)
    %       titles - titles of a column from data
    %       formatSpec - specification of number output format
    %   
    %   Output:
    %       stat - descriptive statistics of data:
    %               mean,
    %               median,
    %               standard deviation,
    %               interquartile range,
    %               variation coefficient,
    %               skewness,
    %               excess kurtosis,
    %               Jarque-Bera test,
    %               Dickey-Fuller test vs AR with drift,
    %               Ljung-Box Q-test (12 lags)
    %   
    %   Copyright (c) 2015-2016 by Dmitriy O. Afanasyev
    %   Versions:
    %   v0.1 2015.07.30: initial version
    %   v0.2 2016.09.04: added IQR, JB, DF & LBQ tests

    if(isempty(data))
        error('Input matrix or vector must be not empty');
    end

    [~, nSamples] = size(data);

    if(nargin() < 2)
        doPrint = 0;
    end
    
    if(doPrint)
        if(nargin() < 3 || (nargin() == 3 && isempty(titles)))
            colTitles = cell(1,nSamples);
            for i = 1:nSamples
                colTitles{1,i} = num2str(i);
            end
        else
            colTitles = titles;
        end

        if(nargin() < 4)
            formatSpec = '%f';
        end
    end
    
    warning('off', 'stats:jbtest:PTooBig');
    warning('off', 'stats:jbtest:PTooSmall');
    warning('off', 'econ:adftest:LeftTailStatTooBig');
    warning('off', 'econ:adftest:LeftTailStatTooSmall');
    

    stat = [];
    stat(1,:) = mean(data);
    stat(2,:) = median(data);
    stat(3,:) = std(data);
    stat(4,:) = iqr(data);
    stat(5,:) = round(abs(stat(3,:)./stat(1,:)) * 100);
    stat(6,:) = skewness(data);
    stat(7,:) = kurtosis(data) - 3;

    for i = 1:nSamples
        [~, stat(9,i), stat(8,i)] = jbtest(data(:,i)); % 0 - fail to rect H0 about normal distribution with unknown mean and variance (i.e. time-series is normaly distributed)
        [~, stat(11,i), stat(10,i)] = adftest(data(:,i), 'model', 'ARD'); % 1 - reject H0 about unit root
        [~, stat(13,i), stat(12,i)] = lbqtest(data(:,i), 'Lags', 12);% 0 - fail to reject H0 about no autocorrelation (i.e. time-series has no autocorrelation)
    end

    notes = ['JB test $H_0$: the data comes from a normal distribution with an unknown mean and variance. ',...
                 'DF test $H_0$: unit root against the AR with drift alternative. ',...
                 'LB Q-test $H_0$: no autocorrelation for 12 lags. ',...
                 'Significance levels: \\textsuperscript{***}~--~1\\%%, \\textsuperscript{**}~--~5\\%%, \\textsuperscript{*}~--~10\\%%.'];


    if(doPrint)
        rowTitles = {'Mean', 'Median', 'Standard deviation', 'Interquartile range', 'Variation coefficient, \\%%', 'Skewness', 'Excess kurtosis', ...
                           'Jarque-Bera test', 'Dickey-Fuller test', 'Ljung-Box Q-test'};
        tblTitle = 'Descriptive statistics';
        
        stattbl = cell(10, nSamples);
        for i = 1:nSamples
            stattbl{1,i} = num2str(stat(1,i), formatSpec);
            stattbl{2,i} = num2str(stat(2,i), formatSpec);
            stattbl{3,i} = num2str(stat(3,i), formatSpec);
            stattbl{4,i} = num2str(stat(4,i), formatSpec);
            stattbl{5,i} = num2str(stat(5,i), '%d');
            stattbl{6,i} = num2str(stat(6,i), formatSpec);
            stattbl{7,i} = num2str(stat(7,i), formatSpec);
            stattbl{8,i} = model_param_to_latex(stat(8,i), NaN, stat(9,i), '%.2f');
            stattbl{9,i} = model_param_to_latex(stat(10,i), NaN, stat(11,i), '%.2f');
            stattbl{10,i} = model_param_to_latex(stat(12,i), NaN, stat(13,i), '%.2f');
        end
        
        print_latex_table(stattbl, colTitles, rowTitles, formatSpec, tblTitle, notes);
    end
    
    warning('on', 'stats:jbtest:PTooBig');
    warning('on', 'stats:jbtest:PTooSmall');
    warning('on', 'econ:adftest:LeftTailStatTooBig');
    warning('on', 'econ:adftest:LeftTailStatTooSmall');
end
