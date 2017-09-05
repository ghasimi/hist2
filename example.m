% An example for hist2() function
% August 2017

rng(2)
z = randn(1000,1);

figure(1)
hist2(z,-2,2)
title('hist2(z,-2,2) Example')

figure(2)
x = z*.2 + exp(z)*.4;
hist2(x,0,3)
title('hist2(x,0,3) Example')
