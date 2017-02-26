function [] = print_latex_table( data, colTitles, rowTitles, formatSpec, tblTitle, tblNotes )
    %PRINT_LATEX_TABLE Print matrix to LaTeX table
    %
    %   Copyright (c) 2014 by Dmitriy O. Afanasyev
    %   Versions:
    %       1.0 2014.09.15: initial version
    %       1.1 2016.07.31: support of the unique number format for each columns
    %       1.2 2016.09.20: no default centering and new font size of notes
    %
    
    if(isempty(data))
        error('Input data must be not empty');
    end
    
    if(nargin() < 2)
        colTitles = [];
    end
    if(nargin() < 3)
        rowTitles = [];
    end
    if(nargin() < 4 || isempty(formatSpec))
        formatSpec = '';
    end
    if(nargin() < 5)
        tblTitle = '';
    end
    if(nargin() < 6)
        tblNotes = '';
    end
    
    nRows = size(data, 1);
    nCols = size(data, 2);
    
    if(~isempty(rowTitles))
        colAlign = 'l';
    else
        colAlign = '';
    end
    for i=1:nCols
        colAlign = [colAlign 'r'];
    end
    
    fprintf(1, '\\begin{table*}[!t]\n');
    fprintf(1, ['\\caption{' tblTitle '}\n']);
    fprintf(1, '\\label{tab:}\n');
    fprintf(1, '\\footnotesize\n');
    fprintf(1, '\\setlength{\\arrayrulewidth}{1.05 pt}\n');
    fprintf(1, '\\renewcommand{\\arraystretch}{1.1}\n');
    fprintf(1, ['\\begin{tabular*}{1.0\\textwidth}{@{\\extracolsep{\\fill}}' colAlign '}\n']);
    fprintf(1, '\\hline\n');
    
    for i = 1:nRows
        
        if(i == 1 && ~isempty(colTitles))
            if(~isempty(rowTitles))
                rowStr = '& ';
            else
                rowStr = '';
            end
            for j = 1:nCols
                if(j == 1)
                    rowStr = [rowStr, colTitles{1,j}, ' &'];
                elseif(j == nCols)
                    rowStr = [rowStr, ' ', colTitles{1,j}, ' \\\\'];
                else
                    rowStr = [rowStr, ' ', colTitles{1,j}, ' &'];
                end
            end
            
            fprintf(1, [rowStr '\n']);
            fprintf(1, '\\hline\n');
        end
        
        
        if(~isempty(rowTitles))
            rowStr = [rowTitles{1,i}, ' & '];
        else
            rowStr = '';
        end
        
        for j = 1:nCols
            value = '';
            if(iscell(data))
                value = data{i,j};
            else
                if(isempty(formatSpec))
                    value = num2str(data(i,j));
                elseif(ischar(formatSpec))
                    value = num2str(data(i,j), formatSpec);
                else
                    if(isempty(formatSpec{j}))
                        value = num2str(data(i,j));
                    else
                        value = num2str(data(i,j), formatSpec{j});
                    end
                end
            end
        
            if(j == 1)
                rowStr = [rowStr, value, ' &'];
            elseif(j == nCols)
                rowStr = [rowStr, ' ', value, ' \\\\\n'];
            else
                rowStr = [rowStr, ' ', value, ' &'];
            end
        end
        
        fprintf(1, rowStr);
    end
    
    fprintf(1, '\\hline\n');
    fprintf(1, '\\end{tabular*}\n');
    fprintf(1, '\\begin{spacing}{0.5}\n');
    fprintf(1, ['{\\footnotesize Notes:', tblNotes, '}\n']);
    fprintf(1, '\\end{spacing}\n');
    fprintf(1, '\\end{table*}\n');
end
