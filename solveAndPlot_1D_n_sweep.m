% Finite Element Method/Finite Difference Method Solver
% Differential Format: central, forward, backward or FEM
% dFmtList={'central','forward','backward','FEM'};
dFmt='FEM';
meshType='shishkin';
extraPointPos=0.9;
%% parameters
b=1;
c=0;
k=1;
f=@(x)x.^k;
epsilon=1e-12;

%% analytical solution
% depends on epsilon, b, c and k
% get @(x)anaSol(x)
getAnaSol;

%% n - sweep
nList=floor(2.^([3:7])');
Err=zeros(size(nList));
numSol=cell(size(nList));
legendList=cell(length(nList)+1,1);

for i=1:length(nList)
    n=nList(i);
    if (b)
        meshWidth=min(0.49,epsilon/b*2.5*log(n));
    else
        meshWidth=min(1/3.1,sqrt(epsilon/c)*2.5*log(n));
    end
    % the following depends on dFmt and n
    % get the coefficient matrices S, C, M and vecf
    getCoeffs;
    
    % the following depends on n, epsilon, b and c
    H=epsilon*S+b*C+c*M;


    % solve
    % tic;
    u=H\vecf;
    % toc;
    
    % record
    numSol{i}.n=n;
    numSol{i}.u=u;
    numSol{i}.xList=xList;
    legendList{i}=['N=',num2str(N)];
    
end

%% plot
figure('position',[100 100 877 546]);
subplot(2,1,2);
for i=1:length(nList)
    plot(numSol{i}.xList,anaSol(numSol{i}.xList)-numSol{i}.u,'-o');hold on;
end
xlabel('$$x$$','interpreter','latex');ylabel('anaSol - numSol');
title('Error between numerical and analytical solution.');

%figure('position',[0 0 940 360]);
subplot(2,1,1);
for i=1:length(nList)
    plot([0;numSol{i}.xList;1],[0;numSol{i}.u;0],'-o');hold on;
end
switch meshType
    case 'shishkin'
        w=-epsilon*log(epsilon);
        xSample=[linspace(0,1-w,5*nList(end))';linspace(1-w,1,5*nList(end))'];
    case '2sideShishkin'
        w=-sqrt(epsilon)*log(epsilon)/2;
        xSample=[linspace(0,w,5*nList(end))';linspace(w,1-w,5*nList(end))';linspace(1-w,1,5*nList(end))'];
    otherwise
        xSample=linspace(0,1,5*nList(end))';
end
plot(xSample,anaSol(xSample),'linewidth',2);
legendList{end}='Analytical Solution';
if strcmp(dFmt,'FEM')
    xlabel('$$x$$','interpreter','latex');ylabel('$$u^{(\mathrm{FEM})}$$','interpreter','latex');
else
    xlabel('$$x$$','interpreter','latex');ylabel('$$u^{(\mathrm{FDM})}$$','interpreter','latex');
end
title(['$$\varepsilon=\mathrm{',num2str(epsilon,'%1.1E'),'}\quad b=',num2str(b),'\quad c=',num2str(c),'\quad k=',num2str(k),'$$  \quad dFmt=',dFmt,' \quad meshType=',meshType],'interpreter','latex');
set(gca,'fontsize',12);
legend(legendList,'location','north');

