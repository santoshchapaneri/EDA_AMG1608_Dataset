function [A, B] = onevar(x) 

if nargin == 0, A = 1; return; end          % report number of parameters

if size(x,2) ~= 1;                          % check dimension of input
  disp('Bad dimension parameter in function f1d');
  return;
end

if nargout == 1
%     A = 5.*x - 2;
  A = ((x.*6-2).^2).*sin((x.*6-2).*2);
else
    A = 5.*x - 2;
%     B = 6.*x + 3;
%   A = ((x.*6-2).^2).*sin((x.*6-2).*2);
%   B = ((x.*6-2).^2).*cos((x.*6-2).*2);
  B = 10*sin(6*x).*sin(x/2);
%   B = (2.*(x.*6-2).*6).*sin((x.*6-2).*2) + ((x.*6-2).^2).*cos((x.*6-2).*2).*12;
end  


