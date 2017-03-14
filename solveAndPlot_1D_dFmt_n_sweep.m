% Finite Element Method/Finite Difference Method Solver

%% parameters
b=1;
c=0;
k=1;
f=@(x)x.^k;
epsilon=1e-2;
% Differential Format: central, forward, backward or FEM
dFmtList={'central','forward','backward','FEM'};
Err=cell(length(dFmtList),1);
meshType='shishkin';


%% analytical solution
% depends on epsilon, b, c and k
% get @(x)anaSol(x)
getAnaSol;

for kkk=1:length(dFmtList)
dFmt=dFmtList{kkk};

%% n - sweep
nList=2*floor(2.^(2:0.5:9))';
Err{kkk}=zeros(size(nList));

for i=1:length(nList)
    n=nList(i);
    meshWidth=min(0.49,epsilon/b*2.5*log(n));
    % the following depends on dFmt, f(x) and n
    % get the coefficient matrices S, C, M and vecf
    getCoeffs;
    
    % the following depends on n, epsilon, b and c
    H=epsilon*S+b*C+c*M;

    % solve
    % tic;
    u=H\vecf;
    % toc;
    
    Err{kkk}(i)=max(abs([0;u;0]-anaSol([0;xList;1])));
    
end
end

%% plot
figure();
markerList={'-ob','-sr','-*g','-^m'};
for kkk=1:length(dFmtList)
    plot(log(nList)/log(10),log(Err{kkk})/log(10),markerList{kkk});hold on
end
legend(dFmtList);
xlabel('$$\log_{10}n$$','interpreter','latex');ylabel('$$\log_{10}(\mathrm{Max\ Abs.\ Err.})$$','interpreter','latex');
title(['$$\varepsilon=\mathrm{',num2str(epsilon,'%1.1E'),'}\quad b=',num2str(b),'\quad c=',num2str(c),'\quad k=',num2str(k),'$$'],'interpreter','latex');

%% plot
% figure();
% plot(0:h:1,[0;u;0],'-o');hold on;
% 
% [ax,~,~]=plotyy(0:0.0001:1,real(anaSol(0:0.0001:1)),...
%                 h:h:1-h,abs( u'-real(anaSol(h:h:1-h)) ),...
%                 @(x,y)plot(x,y,'linewidth',2,'color','red'),...
%                 @(x,y)semilogy(x,y,'g*'));hold off;box on;
% 
% % refine plot
% legend({'Numerical Solution','Analytical Solution','Error'},'Location','northwest');
% title(['$$n=',num2str(n),'\quad \varepsilon=$$',num2str(epsilon),'$$\quad b=',num2str(b),'\quad c=',num2str(c),'\quad f(x)=x^k, k=',num2str(k),'$$  dFmt=',dFmt],'interpreter','latex');
% xlabel('$$x$$','interpreter','latex');
% ylabel(ax(1),'$$u(x)$$','interpreter','latex','color','black');
% ylabel(ax(2),'Error','color','black');
% set(ax(1),'fontsize',12,'ylim',[0,1],'Ycolor','black');
% set(ax(2),'fontsize',12,'Ycolor','black');