function [ mae,  mape, mse, rmse, wape, nmae, nrmse] = mean_errors( a, f )
    %MEAN_ERRORS Compute MAE, MAPE, MSE, RMSE, WAPE, nMAE, nRMSE
    %   INPUT:
    %       a   - actual data
    %       f   - fitted data
    %   OUTPUT:
    %       mae     - mean absolute error
    %       mape   - mean absolute percentage error
    %       mse     - mean squared error
    %       rmse    - root mean squared error
    %       wape    - weighted (equally) absolute percentage error
    %       nmae   - normalized MAE (divided to range)
    %       nrmse  - normalized RMSE (divided to range)
    %
    %   Copyright (c) 2015 by Dmitriy O. Afanasyev
    %   Versions:
    %       1.0 2014.12.27: initial version
    %       1.1 2017.05.28: added wape
    %
    
    if (~all(size(a)==size(f)))
        error('Actual "y" and fitted "f" data must be the equal size');
    end
    
    nans = ~or(isnan(a), isnan(f));
    a = a(nans);
    f = f(nans);
    
    e = a(:) - f(:);
    
    mae = mean(abs(e), 1);
    mape = mean(abs(e./a), 1)*100;
    mse = mean(e.^2, 1);
    rmse = sqrt(mse);
    wape = mean(abs(e./mean(a)), 1)*100;
    nmae = mae./(max(a) - min(a));
    nrmse = rmse./(max(a) - min(a));
end

