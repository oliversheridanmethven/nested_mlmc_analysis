clear all;
close all;

%
% quantisation figure
%

M = 2^20;
U = ((1:M)-0.5)'/M;
Z = norminv(U);

set(0,'DefaultAxesColorOrder',[0 0 0]);

figure; pos=get(gcf,'pos'); pos(3:4)=pos(3:4).*[1.0 0.4]; set(gcf,'pos',pos);

Q   = 4:16;
e2s = [];
e4s = [];

for N = 2.^Q

  Z2 = reshape(Z,M/N,N);
  Zq = sum(Z2,1)/(M/N);
  Zq = repmat(Zq,M/N,1);
  Zq = reshape(Zq,M,1);

  if N==16
    subplot(1,2,1)
    plot(U,Z,'--',U,Zq,'-');
    axis([0 1 -3 3]);
    xlabel('$U$','Interpreter','latex');
    ylabel('$Z$, $\widetilde{Z}$','Interpreter','latex')
    legend('exact','approx','Location','NorthWest','Interpreter','latex') 
    % legend boxoff 
  end

  e2 = sum((Z-Zq).^2)/M;
  e4 = sum((Z-Zq).^4)/M;
  e2s = [e2s e2];
  e4s = [e4s e4];
  
  if N==1024
    fprintf(1,"Quantisation error variance  = %f \n",e2);
  end
end

subplot(1,2,2)
loglog(2.^Q,e2s,'--',2.^Q,e4s,'-');
axis([10 1e5 1e-7 0.1])
xticks([10 100 1000 1e4 1e5])
yticks([1e-6 1e-4 1e-2])
xlabel('number of sub-intervals','Interpreter','latex')
ylabel('error moments','Interpreter','latex')
%legend('2-moment','4-moment','Location','NorthEast','Interpreter','latex')
legend('$E[(\widetilde{Z}\!-\!Z)^2]$','$E[(\widetilde{Z}\!-\!Z)^4]$','Location','NorthEast','Interpreter','latex')
% legend boxoff 

print('-deps2c','fig1a.eps')

%
% piecewise linear dyadic figure
%

M = 2^20;
U = ((1:M)-0.5)'/M;
Z = norminv(U);

figure; pos=get(gcf,'pos'); pos(3:4)=pos(3:4).*[1.0 0.4]; set(gcf,'pos',pos);

Ks  = 2:16;
Ks  = 2:30;
e2s = [];
e4s = [];

for K = Ks
  e2 = 0;
  e4 = 0;
  
  for k=1:K
    u2 = 2^(-k);
    u1 = 2^(-k-1);
    
    if k==K
      u1=0;
    end
    
    u = linspace(u1, u2)';
    u = 0.5*(u(1:end-1)+u(2:end));
    
    z = norminv(u);
    A = [ones(size(u)) u];
    beta = A \ z;
    z2 = A*beta;
        
    e2 = e2 + 2*sum((z-z2).^2)*(u(2)-u(1));
    e4 = e4 + 2*sum((z-z2).^4)*(u(2)-u(1));
    
    if K==2
      subplot(1,2,1)
      plot(u,z,'--',u,z2,'-',1-u,-z,'--',1-u,-z2,'-'); hold on
      axis([0 1 -3 3]);
      xlabel('$U$','Interpreter','latex');
      ylabel('$Z$, $\widetilde{Z}$','Interpreter','latex')
      legend('exact','approx','Location','NorthWest','Interpreter','latex') 
      % legend boxoff 
    end 
  end
  
  e2s = [e2s e2];
  e4s = [e4s e4];
  
  if K==16
    fprintf(1,"Linear-dyadic error variance = %f \n",e2);
  end
end

subplot(1,2,2)
semilogy(2*Ks,e2s,'--',2*Ks,e4s,'-');
axis([0 60 1e-9 1])
yticks([1e-8 1e-6 1e-4 1e-2 1])
xlabel('number of sub-intervals','Interpreter','latex')
ylabel('error moments','Interpreter','latex')
%legend('2-moment','4-moment','Location','NorthEast')
legend('$E[(\widetilde{Z}\!-\!Z)^2]$','$E[(\widetilde{Z}\!-\!Z)^4]$','Location','NorthEast','Interpreter','latex')
% legend boxoff 

print('-deps2c','fig1b.eps')

%
% polynomial figure
%

M = 2^20;
U = ((1:M)-0.5)'/M;
Z = norminv(U);

figure; pos=get(gcf,'pos'); pos(3:4)=pos(3:4).*[1.0 0.4]; set(gcf,'pos',pos);

M = 2^20;
U = ((1:M)-0.5)'/M;

Ks  = 1:2:15;
e2s = [];
e4s = [];

for K = Ks
  A = [];
  for k=1:2:K
    A = [A (U-0.5).^k];
  end
  beta = A \ Z;
  Zp = A*beta;

  if K==3
    subplot(1,2,1)
    plot(U,Z,'--',U,Zp,'-');
    axis([0 1 -3 3]);
    xlabel('$U$','Interpreter','latex');
    ylabel('$Z$, $\widetilde{Z}$','Interpreter','latex')
    legend('exact','approx','Location','NorthWest','Interpreter','latex')
    %  legend boxoff 
  end
  
  e2 = sum((Z-Zp).^2)/M;
  e4 = sum((Z-Zp).^4)/M;
  e2s = [e2s e2];
  e4s = [e4s e4];

  if K==7
    fprintf(1,"Polynomial error variance    = %f \n",e2);
  end
end

subplot(1,2,2)
semilogy(Ks,e2s,'--',Ks,e4s,'-');
axis([0 15 1e-4 1e-1])
yticks([1e-4 1e-3 1e-2 1e-1 ])
xlabel('polynomial degree','Interpreter','latex')
ylabel('error moments','Interpreter','latex')
%legend('2-moment','4-moment','Location','NorthEast')
legend('$E[(\widetilde{Z}\!-\!Z)^2]$','$E[(\widetilde{Z}\!-\!Z)^4]$','Location','NorthEast','Interpreter','latex')
%legend boxoff 

print('-deps2c','fig1c.eps')

