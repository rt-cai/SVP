clear variables; close all; clc;

%% Set-up

% Discretization parameters
nx = 81;
ny = 81;
dt = 0.005;
dx = 1/(nx-1);
dy = 1/(ny-1);

% Time interval
t_0 = 0;
tf = 0.25;

% Problem parameters
D = 0.05;
kindergarten = [0.5, 0.5];
s1 = 100;
s2 = 150;

% Set up arrays for later
x = 0:dx:1;
y = 0:dy:1;
t = 0:dt:tf;
nt = length(t);

%% Create u
% the first dimension of u is the flattened spatial dimension,
% and the second dimension is time
u = zeros(ny*nx, nt);

boundaries = [1:ny 1:ny:ny*nx ny:ny:ny*nx nx*(ny-1)+1:nx*ny];
% (above) might be less confusing to use the G function for this...


%%



a1 = exprnd(2);
pa1 = exp(-a1/2)/2;
a2 = exprnd(1);
pa2 = exp(-a2);
ptheta = 1/(2*pi);
u0 = a1*exp(-s1*bsxfun(@plus, (x-0.25).^2, (y'-0.25).^2)) + ...
     a2*exp(-s2*bsxfun(@plus, (x-0.65).^2, (y'-0.4).^2));
u(:,1) = u0(:);
u(boundaries,1) = 0;
avg = 0;
for i = 1:100
    W = wblrnd(2,2);
    pw = wblpdf(W,2,2);
    theta = rand*2*pi;
    A = createA(D, W, theta, nx, ny, dx, dy, dt);
    sA = sparse(A);
    for j = 1:nt-1
        u(:,j+1) = sA \ u(:,j);
    end
    uplot = reshape(u, [ny, nx, nt]);

    f = zeros(1, nt);
    for j = 1:nt
        f(1,j) = uplot(0.5/dx,0.5/dy,j); 
    end
    k = trapz(f);
    avg = avg + k * ptheta * pw * pa1 * pa2;
end
totalPollution = avg/100