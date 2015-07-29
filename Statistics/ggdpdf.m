function [ Y ] = ggdpdf( X, location, scale, shape, version)
    % GGDPDF Generalized Gaussian (normal) distribution (version 1 or 2)
    %   Version 1 is known also as the generalized error distribution (GED).
    %   Version 2 is a family of continuous probability distributions
    %   in which the shape parameter can be used to introduce skew.
    %
    %   Reference(s):
    %       http://en.wikipedia.org/wiki/Generalized_normal_distribution
    %
    %   Copyright (c) 2014 by Dmitriy O. Afanasyev
    %   Versions:
    %       1.0 2014.08.01: initial version
    %
    
    if(nargin < 1)
        error('X must be specified');
    end
    if(nargin < 2)
        location = 0;
    end
    if(nargin < 3)
        scale = 1;
    end
    if(nargin < 4)
        shape = 0.5;
    end
    if(nargin < 5)
        version = 1;
    end
    
    nObs = size(X, 1);
    nCols = size(X, 2);
    
    Y = zeros(nObs, nCols);
    
    switch version
        case 1
            A = sqrt((scale^2*gamma(shape))/gamma(3*shape));
            Y=(1/shape)*exp(-abs((X-location)./A).^(1/shape))./(2*A*gamma(shape+1));
            
        case 2
            for i=1:nCols
                for j=1:nObs
                    if(abs(shape) < eps)
                        % normal distribution
                        Y(j,i) = normpdf(X(j,i), location, scale);
                    elseif((shape > eps && X(j,i) < location+(scale/shape)) || (shape < -eps && X(j,i) > location+(scale/shape)))
                        % skewed distribution
                        Y(j,i) = normpdf((-1/shape) .* log(1 - (shape.*(X(j,i)-location)./scale)))./(scale - shape*(X(j,i)-location));
                    else
                        % out of the domain
                        Y(j,i) = 0;
                    end
                end
            end
    end
    
end

