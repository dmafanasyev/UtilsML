function [ mae,  mape, mse, rmse] = mean_errors( a, f )
    %MEAN_ERRORS Compute MAE, MAPE, MSE, RMSE
    %   INPUT:
    %       a   - actual data
    %       f   - fitted data
    %   OUTPUT:
    %       mae     - mean absolute error
    %       mape   - mean absolute percentage error
    %       mse     - mean squared error
    %       rmse    - root mean squared error
    %
    %   Copyright (c) 2015 by Dmitriy O. Afanasyev
    %   Versions:
    %       1.0 2014.12.27: initial version
    %
    
    if (~all(size(a)==size(f)))
        error('Actual "y" and fitted "f" data must be the equal size');
    end
    
    nans = ~or(isnan(a), isnan(f));
    a = a(nans);
    f = f(nans);
    
    mae = mean(abs(a(:) - f(:)));
    mape = mean(abs((a(:)-f(:))./a(:)))*100;
    mse = mean((a(:) - f(:)).^2);
    rmse = sqrt(mse);
end

