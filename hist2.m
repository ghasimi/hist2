function [h p1 p2 p3] = hist2(x, a, b)
% This function is a histogram plus the cumulative distributions between
% critical points a and b.
%
%   [h p1 p2 p3] = hist2(x, a, b)
%       h : Handle to the plot
%       p1: Percentage of observations which are <= a
%       p2: Percentage of observations between a and b
%       p2: Percentage of observations which are >= b
%   
%   hist2 gets the vector x and one or two critical points (a and b),
%   and generates a histogram, plus the probabilities for observations 
%   between and outside of the critical points. 
%
%   Example: 
%       x = randn(1000,1);
%       [h p1 p2 p3] = hist2(x, -1.67, 2.33)
%
% More info at github.com/ghasimi/hist2

% Handling of inputs ----------------------------------------------
if (nargin == 1)
    a = median(x);
    b = max(x); 
elseif (nargin == 2)
    b = max(x);    
end

% 
if (size(x,2)>1)
    x = x';
end

% 
if (b<a) 
    c = a; 
    a = b;
    b = c;
end

% Parameters for visualization ------------------------------

% CDFs
n = length(x);
pL = sum(x<=a)/n*100;
pR = 100 - sum(x<=b)/n*100;

% Color and Formats
MC1  = 'w'; % text color of the middle area
MC2  = 'k';
C1 = [0 .6 1]; % background color of the middle area 
C2 = [1 1 1];
C3 = [1 1 1]; % color for masking the left and right areas of the histogram
fAlpha = 0.6; % transparency for masking the left and right areas of the histogram
e = 0.065; % threshold below which the percentages are not shown on the histogram 

% Histogram and numerical outputs ---------------------------------

h = histogram(x);
p1= pL/100;
p3= pR/100;
p2= 1 - p1 - p3;

% Annotations ----------------------------------------------------

% Parameters
pa = gca;
pa.YLim = [pa.YLim(1), pa.YLim(2)*1.12];

p = pa.Position;
sf = p(4)-p(2);
W = abs(pa.XLim(2) - pa.XLim(1));

L = abs(a-pa.XLim(1));
R = abs(b-pa.XLim(1));

oh = .06 * sf;
oy = p(4) + p(2) - 2.2*oh;

%
line([a a],[0 pa.YLim(2)*.95],'Color','k','LineStyle','--')
line([b b],[0 pa.YLim(2)*.95],'Color','k','LineStyle','--')


% L - Left-side cumulative distribution
ox = p(1);
ow = (L/W)*p(3);

dim = [ox p(2) ow oy-p(2)+oh];
an = annotation('rectangle',dim);
an.FaceColor = C3;
an.EdgeColor = 'none';
an.FaceAlpha = fAlpha;

dim = [ox oy ow oh];
an = annotation('textbox',dim,'String',string(num2str(pL,'%.1f%%')));
if(ow < e) an.String=''; end
an.BackgroundColor = 'none';
an.EdgeColor = 'k';
an.Color = MC2;
an.HorizontalAlignment = 'center';
an.VerticalAlignment = 'middle';

% R - Right-side cumulative distribution
ox = p(1)+(R/W)*p(3);
ow = ((W-R)/W)*p(3);

dim = [ox p(2) ow oy-p(2)+oh];
an = annotation('rectangle',dim);
an.FaceColor = C3;
an.EdgeColor = 'none';
an.FaceAlpha = fAlpha;

dim = [ox oy ow oh];
an = annotation('textbox',dim,'String',string(num2str(pR,'%.1f%%')));
if(ow < e) 
    an.String=''; 
end
an.BackgroundColor = 'none';
an.EdgeColor = 'k';
an.Color = MC2;
an.HorizontalAlignment = 'center';
an.VerticalAlignment = 'middle';

% M - Middle cumulative distribution
ox = p(1) + (L/W)*p(3);
ow = ((R-L)/W)*p(3);
dim = [ox oy ow oh];
an = annotation('textbox',dim,'String',string(num2str(100-pL-pR,'%.1f%%')));
if(ow < e) 
    an.String=''; 
end
an.BackgroundColor = C1;
an.EdgeColor = C1;
an.Color = MC1;
if(ow < e) 
    an.String=''; 
end
an.HorizontalAlignment = 'center';
an.VerticalAlignment = 'middle';
pa.YLim(2) = pa.YLim(2)*1.05;

% Tick labels for the cumulative distribution --------------------
oy = p(4) + p(2) - 1.2*oh;

% Lower point
ox = p(1) + (L/W)*p(3) - 0.02;
ow = 0.2;
dim = [ox oy ow oh];
an = annotation('textbox',dim,'String',string(num2str(a)),'FitBoxToText','on');
if(ow < e) 
    an.String=''; 
end
an.EdgeColor = 'none';
an.Color = 'k';
if(ow < e) 
    an.String=''; 
end
an.HorizontalAlignment = 'left';
an.VerticalAlignment = 'middle';

% Upper point
ox = p(1) + (R/W)*p(3)  - 0.025;
ow = 0.2;
dim = [ox oy ow oh];
an = annotation('textbox',dim,'String',string(num2str(b)),'FitBoxToText','on');
if(ow < e) 
    an.String=''; 
end
an.EdgeColor = 'none';
an.Color = 'k';
if(ow < e) 
    an.String=''; 
end
an.HorizontalAlignment = 'left';
an.VerticalAlignment = 'middle';

end

