function [ r ] = ggdrnd( n, m, location, scale, shape, version )
    % GGDRND Pseudorandom numbers generator for Generalized Gaussian (normal) distribution (version 1 or 2)
    % Generate n-to-m matrix of pseudorandom numbers which distributed as GGD (versio 1 or 2)
    %   Reference(s):
    %       http://en.wikipedia.org/wiki/Generalized_normal_distribution
    %
    %   Copyright (c) 2014 by Dmitriy O. Afanasyev
    %   Versions:
    %       1.0 2014.08.25: initial version
    %
    
    if(nargin < 1) n = 1; end
    if(nargin < 2) m = 1; end
    if(nargin < 3) location = 0; end
    if(nargin < 4) scale = 1; end
    if(nargin < 5) shape = 0.5; end
    if(nargin < 6) version = 1; end
    
    r = nan(n,m);
    
    for j = 1:m
        for i = 1:n
            [r_tmp, prob] = generate(location, scale);
            while (ggdpdf(r_tmp, location, scale, shape, version) < prob)
                [r_tmp, prob] = generate(location, scale);
            end
            r(i,j) = r_tmp;
        end
    end

% Internally used routine
function [r, prob] = generate (location, scale)
    r =  location + 10*scale*(rand(1) - rand(1));
    prob = rand(1);