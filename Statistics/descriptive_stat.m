function [ stat ] = descriptive_stat( data, doPrint, formatSpec)
    %DESCRIPTIVE_STAT Compute descriptive statistics of data
    %   INPUT:
    %   data            - data for descriptive statistics compute
    %   doPrint        - flag for LaTeX table print, default is 0 (no print)
    %   formatSpec  - specification of number output format
    %   OUTPUT:
    %   stat     - descriptive statistics of data: mean, median, standard deviation, variation coefficient, skewness, kurtosis (subtract 3)
    
    if(isempty(data))
        error('Input data or vector must be not empty');
    end
    
    if(nargin() < 2)
        doPrint = 0;
    end
    if(nargin() < 3)
        formatSpec = '%f';
    end
    
    stat = [];
    stat(1,:) = mean(data);
    stat(2,:) = median(data);
    stat(3,:) = std(data);
    stat(4,:) = (stat(3,:) ./ stat(1,:)) * 100;
    stat(5,:) = skewness(data);
    stat(6,:) = kurtosis(data)-3;
    
    if(doPrint)
        colTitles = {};
        for i = 1:size(data, 2)
            colTitles{1,i} = num2str(i);
        end
        
        rowTitles = {'Mean', 'Median', 'Standard deviation', 'Variation coefficient', 'Skewness', 'Kurtosis'};
        tblTitle = 'Descriptive statistics';
        print_latex_table(stat, colTitles, rowTitles, formatSpec, tblTitle);
    end
end

