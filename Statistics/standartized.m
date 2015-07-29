function [sdata] = standartized(data)
    % STANDARTIZED Compute standartized values for each column of input matrix
    %
    %   Copyright (c) 2013 by Dmitriy O. Afanasyev
    %   Versions:
    %       1.0 2013.03.07: initial version
    %

if isempty(data)
    error 'Input matrix must not be empty';
end

% if ~isvector(input) || ~ismatrix(input)
%     error 'Input must be a vector or matrix';
% end

rowNum = size(data, 1);
colNum = size(data, 2);
sdata = zeros(rowNum, colNum);

for i = 1:colNum
    sdata(:, i) = (data(:, i) - mean(data(:, i)))./std(data(:, i));
end