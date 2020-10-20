%% Input files for 2D body forced simulations
ieee='b';
accuracy='real*8';
g=9.81;
alphaT=2e-4;
N2=3e-6;


% grid size
nx=1024;
ny=1;
nz=2000;
Lx=100e3;
H1=3000;

z=-linspace(0,H1,nz+1);
z=(z(1:end-1)+z(2:end))/2;

x=linspace(0,Lx,nx+1);
x=(x(1:end-1)+x(2:end))/2;


%% Goff topo 
load topo.mat hout

mean_depth=-H1-min(hout)*200;
harray=[0 20 50 100 200];

for i=1:length(harray)
    h=mean_depth*ones(size(hout))+hout*harray(i);
    fid=fopen(sprintf('topo_h%i.field',harray(i)),'w',ieee); fwrite(fid,h,accuracy); fclose(fid);
end


%% Temperature
dTdz=N2/(alphaT*g);
[X,Z]=ndgrid(x,z);
T=dTdz*(Z+H1);
fid=fopen('Tinit_N2_3e6.field','w',ieee); fwrite(fid,T,accuracy); fclose(fid);

T=dTdz*(Z+H1)+8*dTdz*exp(Z/500)*500;
fid=fopen('Tinit_N2_exp.field','w',ieee); fwrite(fid,T,accuracy); fclose(fid);

%% initial velocity
% tidal
omega0=0.000138889;
f0=1e-4;
F0=1e-6;
u0=omega0/(f0^2-omega0^2)*F0;
fid=fopen('uinit_super.field','w',ieee); fwrite(fid,u0*ones(size(X)),accuracy); fclose(fid);
fid=fopen('uinit_superx5.field','w',ieee); fwrite(fid,5*u0*ones(size(X)),accuracy); fclose(fid);

% mean only
meanFy=1e-6;
u0=meanFy/f0;
fid=fopen('uinit_mean20.field','w',ieee); fwrite(fid,20*u0*ones(size(X)),accuracy); fclose(fid);
