close all
clear all

a = csvread('new_results.csv');

base = a(:,1);
orig = a(:,4);
corr = a(:,6);

set(0,'DefaultAxesColorOrder',[0 0 0]);
set(0,'DefaultAxesLineStyleOrder','-*|:*|--*|-.*')

figure; pos=get(gcf,'pos'); pos(3:4)=pos(3:4).*[0.8 1.2]; set(gcf,'pos',pos);

subplot(2,1,2)
semilogy(0:7,[base(1:8),corr(9:16),corr(17:24),corr(1:8)])

axis([0 7 1e-11 1])
hold on
semilogy(5:7,1e-6*0.25.^(5:7),'-')
semilogy(1:4,2e-8*0.5.^(1:4),'-')
legend('baseline','polynomial','quantised','dyadic','Interpreter','Latex')

xlabel(' level $\ell$','Interpreter','Latex')
ylabel('variance','Interpreter','Latex')
text(1.5,1e-2,'$f(x) = \max(x\!-\!1,0) $','Interpreter','Latex')
%title('$f(x) = \max(x-1,0) $','Interpreter','Latex')
text(2,5e-10,'$2^{-\ell}$','Interpreter','Latex')
text(5.5,5e-11,'$2^{-2\ell}$','Interpreter','Latex')

subplot(2,1,1)
semilogy(0:7,[base(25:32),corr(33:40),corr(41:48),corr(25:32)])
hold on
semilogy(1:4,2e-8*0.25.^(1:4),'-')
axis([0 7 1e-11 1])

text(2,1e-10,'$2^{-2\ell}$','Interpreter','Latex')

legend('baseline','polynomial','quantised','dyadic','Interpreter','Latex')

xlabel(' level $\ell$','Interpreter','Latex')
ylabel('variance','Interpreter','Latex')
text(1.5,1e-2,'$f(x) = x$','Interpreter','Latex')
%title('$f(x) = x$','Interpreter','Latex')

print('-deps2','fig2.eps')


%
% state ratios
%

% max(X-K,0), quantised
Crat = 1/7;
Vrat = max(corr(17:24)./base(1:8));
fprintf(1, ...
 'max(X-K,0), quantised: Crat=%f, Vrat=%f, sqrt((1/Crat+1)*Vrat)=%f \n', ...
 Crat,Vrat,sqrt((1/Crat+1)*Vrat));

% max(X-K,0), dyadic
Crat = 1/7;
Vrat = max(corr(1:8)./base(1:8));
fprintf(1, ...
 'max(X-K,0), dyadic: Crat=%f, Vrat=%f, sqrt((1/Crat+1)*Vrat)=%f \n', ...
 Crat,Vrat,sqrt((1/Crat+1)*Vrat));

% X, quantised
Crat = 1/7;
Vrat = max(corr(41:48)./base(25:32));
fprintf(1, ...
 'X, quantised: Crat=%f, Vrat=%f, sqrt((1/Crat+1)*Vrat)=%f \n', ...
 Crat,Vrat,sqrt((1/Crat+1)*Vrat));

% X, dyadic
Crat = 1/7;
Vrat = max(corr(25:32)./base(25:32));
fprintf(1, ...
 'X, dyadic: Crat=%f, Vrat=%f, sqrt((1/Crat+1)*Vrat)=%f \n', ...
 Crat,Vrat,sqrt((1/Crat+1)*Vrat));


