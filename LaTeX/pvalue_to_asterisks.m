function [p_asterisks] = pvalue_to_asterisks( p_value )
    %PVALUE_TO_ASTERISKS Convert p-value to asterisks symbols using "standard" notation
    %
    %   Copyright (c) 2014 by Dmitriy O. Afanasyev
    %   Versions:
    %       1.0 2014.09.15: initial version
    %
    
    p_value = round(p_value, 2);

    if(p_value <= 0.01)
        p_asterisks = '***';
    elseif(p_value <= 0.05)
        p_asterisks = '**';
    elseif(p_value <= 0.10)
        p_asterisks = '*';
    else
        p_asterisks = '';
    end

end

