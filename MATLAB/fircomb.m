function [b,a] = fircomb(r,L)
%  COMB
%
%      [b,a] = COMB(r,L)
%
%    generates L zeros equally spaced around a circle of radius r


b = [1 zeros(1,L-1) -r^L];
a = [1 zeros(1,L-1)]; 