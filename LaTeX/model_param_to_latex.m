function [ param_cell ] = model_param_to_latex( param_value, std_error, p_value, format )
    %MODEL_PARAM_TO_LATEX Print model parameter to LaTeX using template "<coefficient><p-value asterisks> (<stadard error>)"
    %
    %   Copyright (c) 2014 by Dmitriy O. Afanasyev
    %   Versions:
    %       1.0 2014.09.15: initial version
    %
    
    if(nargin < 4)
        format = '%4.4f';
    end
    
    param_cell = '';
    param_value_str = '';
    std_error_str = '';
    p_value_str = '';
    
    if(~isnan(param_value))
        
        if(abs(param_value) > eps)
            param_value_str = num2str(param_value, format);
        else
            param_value_str = '0';
        end
        
        if(~isnan(p_value))
            asterisks = pvalue_to_asterisks(p_value);
            if(~isempty(asterisks))
                p_value_str = ['\\textsuperscript{' asterisks '}'];
            else
                p_value_str = '';
            end
        else
            p_value_str = ' ';
        end
        
        if(~isnan(std_error))
            std_error_str = [' {\\footnotesize (' num2str(std_error, format) ')} '];
        end
    end
    
    param_cell = [param_value_str p_value_str std_error_str];
end

