function [T,S] = osslda_wPCA(X,classIndices,d,displayFlag)
%
% OSSLDA: optimal orthonormal system for discriminant analysis
%
% X=Examples as columns
% classIndices: Integers from 1 to K if there are K classes
% d=number of dimensions (projections)
% displayFlag=1 means that some results are displayed during calculations
%
% T=Basis vectors as columns
% S=coordinates (scores) for each column in X
%
% Remark.
% The implementation  follows essentially
% Okada & Tomita, Patt Rec 18(2):139-144, 1985
%
% MG/April/2010
% Modified and simplified by NA/May/2017




if nargin==0
   demo_okadaLDA
   return
end


[dX,N]=size(X);
K=max(classIndices);

T=nan(dX,d);

for k=1:K
   indices=find(classIndices==k);
   if displayFlag disp(['X' num2str(k) ' = X(:,indices);']); end
   eval(['X' num2str(k) ' = X(:,indices);']);
   
   if displayFlag disp(['N' num2str(k) ' = numel(indices);']); end
   eval(['N' num2str(k) ' = numel(indices);']);
   
end

%Class means
for k=1:K
  if displayFlag disp(['m' num2str(k) ' = mean(X' num2str(k) ''')'';']); end
 eval(['m' num2str(k) ' = mean(X' num2str(k) ''')'';']);
end

%Global mean
m=zeros(dX,1);
for k=1:K
      if displayFlag disp(['m=m+N' num2str(k) '*m' num2str(k) ';']); end
    eval(['m=m+N' num2str(k) '*m' num2str(k) ';'])
end
m=m/N;
   
%Within-class scatter matrices
for k=1:K
    if displayFlag disp(['W' num2str(k) '=(N' num2str(k) '-1)*cov(X' num2str(k) ''')/N' num2str(k) ';']); end
    eval(['W' num2str(k) '=(N' num2str(k) '-1)*cov(X' num2str(k) ''')/N' num2str(k) ';'])
end

%Global Within-class scatter matrix
W=zeros(size(W1));
for k=1:K
    if displayFlag disp(['W=W+N' num2str(k) '*W' num2str(k) ';']); end
    eval(['W=W+N' num2str(k) '*W' num2str(k) ';'])
end
Wo=W/N;


%Between-class scatter matrix
B=zeros(numel(m),numel(m));
for k=1:K
    if displayFlag disp(['B=B+N' num2str(k) '*(m' num2str(k) '-m)*(m' num2str(k) '-m)'';']); end
    eval(['B=B+N' num2str(k) '*(m' num2str(k) '-m)*(m' num2str(k) '-m)'';'])
end
Bo=B/N;



%Find eigenvalues to the seperationmatrix S
invW_B=inv(W)*B;
[loadings] = pcacov(invW_B);
T = loadings(:,1:d);

% [eigVec, D] = eig(invW_B);
% eigVals = sum(D)';
% [~, order] = sortrows(eigVals);
% eigVec = eigVec(:,order); %arrange in order
% eigVec = eigVec(:,end:-1:1); %flip due to sorted wrong way
% T = eigVec(:,1:d);

S = T'*X;

  
function demo_okadaLDA
% Remark.
% This dataset is from the original article 
% Okada & Tomita, Patt Rec 18(2):139-144, 1985

d=10;
m1=[10 7 6 5 1 7 2 0 5 3]';

d1=[0.091 0.373 1.43 0.084 0.071 5.72 2.75 1.45 0.067 0.341];

c1=[0.038 -0.053 -0.005 0.01 -0.136 0.155 0.03 0.002 0.032 ...
    0.018 -0.028 -0.011 -0.367 0.154 -0.057 -0.031 -0.065 ...
    0.017 0.055 -0.45 -0.038 -0.298 -0.041 -0.03 ...
    -0.005 0.016 0.042 -0.022 0.001 0.005 ...
    0.088 0.058 -0.069 -0.008 0.003 ...
    -0.0544 -0.248 0.005 0.095 ...
    -0.343 -0.011 -0.12 ...
    0.078 0.028 ...
    0.015];
C1=diag(d1);
 C1=C1+squareform(c1);
 
 m2=[1 4 3 9 5 1 0 7 -5 -3]';
 
 d2=[0.427 5.69 0.08 2.8 3.44 2.27 0.327 0.727 0.715 0.065];
 
c2=[0.011 -0.005 -0.025 0.089 -0.079 -0.019 0.074 0.089 0.005 ...
    -0.069 -0.282 -0.731 0.09 -0.124 0.1 0.432 -0.103 ...
    0.098 0.045 -0.041 0.023 0.022 -0.035 0.012 ...
    -0.107 0.15 -0.193 0.095 -0.226 0.046 ...
    0.253 0.251 0.316 0.039 -0.01 ...
    -0.18 0.295 -0.039 -0.113 ...
    0.027 0.026 -0.016 ...
    -0.096 -0.017 ...
    -0.009];
 
C2=diag(d2);
 C2=C2+squareform(c2);
 
 
 
 
 m3=[-5 -9 0 -4 -1 -5 2 6 -3 6]';
 d3=[0.335 0.091 0.078 0.082 0.797 1.5 0.277 0.317 0.538 0.668]';
 c3=[0.026 -0.051 -0.012 0.079 0.017 0.029 0.008 0.077 -0.03 ...
     0.011 -0.01 0.006 -0.014 -0.002 -0.023 0.011 0.035 ...
     0.000 0.016 0.003 0.03  -0.035 -0.003 -0.049 ...
     -0.003 -0.026 -0.025 -0.029 -0.015 0.025 ...
     0.194 -0.037 -0.023 0.059 -0.145 ...
     0.014 -0.104 0.114 -0.229 ...
     -0.03 -0.077 -0.051 ...
     0.022 0.01 ...
     0.034];
 
 C3=diag(d3);
 C3=C3+squareform(c3);
 
 
 m4=[2 3 7 15 12 10 1 3 -4 -6]';
 d4=[0.084 0.793 0.066 0.728 0.08 0.336 1.45 0.32 2.93 0.304];
 c4=[-0.012 0.001 0.015 -0.004 0.024 -0.011 0.027 0.073 -0.012 ...
     0 0.197 0.031 -0.026 0.05 0.079 0.145 -0.027 ...
     -0.023 0.011 -0.017 0.039 -0.002 0.017 -0.004 ...
     -0.003 -0.015 0.121 0.09 0.08 0.041 ...
     -0.001 -0.007 0.023 -0.014 -0.023 ...
     -0.147 -0.037 0.302 -0.052 ...
     -0.132 -0.230 -0.137 ...
     0.238 0.017 ...
     -0.057];
 C4=diag(d4);
 C4=C4+squareform(c4);
 
 m5=[5 -8 -4 -6 -4  3 1 -5 -2 8]';
 d5=[0.09 0.092 0.082 5.68 0.076 0.458 1.82 4.07 0.263 0.387];
 c5=[0.001 -0.008 -0.191 -0.007 0.041 -0.03 -0.058 0.022 0.032 ...
     -0.011 0.008 -0.014 -0.002 0.012 -0.01 -0.021 -0.002 ...
     0.082 0.014 -0.02 -0.058 0.105 0.004 0.023 ...
     -0.096 -0.015 0.646 0.219 -0.238 0.218 ...
     -0.035 -0.04 -0.023 0.027 -0.014 ...
     0.138 -0.251 0.012 0.039 ...
     -0.183 -0.002 0.117 ...
     -0.464 0.147 ...
     0.054];
 C5=diag(d5);
 C5=C5+squareform(c5);
 
 
 %"EXACT MATRICES - NOT USED HERE BUT AVAILABLE AS REFERENCES
 We=(C1+C2+C3+C4+C5)/5
 me=(m1+m2+m3+m4+m5)/5;
 
 Be=(m1-me)*(m1-me)'+(m2-me)*(m2-me)'+(m3-me)*(m3-me)'+(m4-me)*(m4-me)'+(m5-me)*(m5-me)';
 Be=Be/5
 
 
 
 bb=[24.5 42.5 16.1 60.4 31 26.5 0.461 18.5 12.4 28.1]';
 bbb=[18.5 4.94 6.09 -2.24 18.4 -0.138 -14.2 13.0 0.99 ...
     22.5 41.1 22.3 22.6 -1.67 5.27 8.36 -24.1 ...
     27.6 18.0 12.8 -0.27 6.96 3.22 -16.8 ...
     41.4 26.3 -2.59 13.2 -4.12 -40.1 ...
     15.8 -1.6 11.2 -6.89 -28.7 ...
     -0.53 -9.18 6.06 -13.7 ...
     -0.644 1.27 2.12 ...
     -6.67 -11.9 ...
     6.72];
 Bee=diag(bb);
 Bee=Bee+squareform(bbb);
 
 
 %DATA GENERATION
 Ngen=200;
 
 
 R1 = mvnrnd(m1,C1,Ngen);
 C1_hat=cov(R1);
 m1_hat=mean(R1);
 

 R2 = mvnrnd(m2,C2,Ngen);
 C2_hat=cov(R2);
 m2_hat=mean(R2);
 
 R3 = mvnrnd(m3,C3,Ngen);
 C3_hat=cov(R3);
 m3_hat=mean(R3);
 

 R4 = mvnrnd(m4,C4,Ngen);
 C4_hat=cov(R4);
 m4_hat=mean(R4);
 
 R5 = mvnrnd(m5,C5,Ngen);
 C5_hat=cov(R5);
 m5_hat=mean(R5);
 
 
X=[R1' R2' R3' R4' R5'];

classIndices=[ones(1,Ngen) 2*ones(1,Ngen) 3*ones(1,Ngen) 4*ones(1,Ngen) 5*ones(1,Ngen) ];



%FINAL CALL
displayFlag=1
[T,S] = osslda(X,classIndices,d,displayFlag);
sizeT=size(T)
T32=T(1:3,1:2)
sizeS=size(S)
S32=S(1:3,1:2)

BasisVectorsAsColumns=T;
ScoreValuesAsColumns=S;


%CHOOSE TO PLOT THE 3 MAIN SCORE VALUES
figure
plot3(ScoreValuesAsColumns(1,:),ScoreValuesAsColumns(1,:),ScoreValuesAsColumns(1,:),'.w')
hold on
plot3(ScoreValuesAsColumns(1,1:200),ScoreValuesAsColumns(2,1:200),ScoreValuesAsColumns(3,1:200),'.r')
plot3(ScoreValuesAsColumns(1,200+1:200+200),ScoreValuesAsColumns(2,200+1:200+200),ScoreValuesAsColumns(3,200+1:200+200),'.b')
plot3(ScoreValuesAsColumns(1,400+1:400+200),ScoreValuesAsColumns(2,400+1:400+200),ScoreValuesAsColumns(3,400+1:400+200),'.m')
plot3(ScoreValuesAsColumns(1,600+1:600+200),ScoreValuesAsColumns(2,600+1:600+200),ScoreValuesAsColumns(3,600+1:600+200),'.c')
plot3(ScoreValuesAsColumns(1,800+1:800+200),ScoreValuesAsColumns(2,800+1:800+200),ScoreValuesAsColumns(3,800+1:800+200),'.k')


noOfExamples=size(X,2);
m=mean(X')';
M=m*ones(1,noOfExamples);  %M consists of noOfExamples copies of the column vector m
[U,Ssvds,V]=svds((X-M)/sqrt(noOfExamples-1),3);
sizeU=size(U)
EigenVectors=U(:,1:3);  %KEEP 3 EGENVECTORS
eigenValues=diag(Ssvds).^2;
eigenValues=eigenValues(1:3);
Scores=EigenVectors'*(X-M);
title('OSS')
grid

figure
ScoreValuesAsColumns=Scores;
plot3(ScoreValuesAsColumns(1,:),ScoreValuesAsColumns(1,:),ScoreValuesAsColumns(1,:),'.w')
hold on
plot3(ScoreValuesAsColumns(1,1:200),ScoreValuesAsColumns(2,1:200),ScoreValuesAsColumns(3,1:200),'.r')
plot3(ScoreValuesAsColumns(1,200+1:200+200),ScoreValuesAsColumns(2,200+1:200+200),ScoreValuesAsColumns(3,200+1:200+200),'.b')
plot3(ScoreValuesAsColumns(1,400+1:400+200),ScoreValuesAsColumns(2,400+1:400+200),ScoreValuesAsColumns(3,400+1:400+200),'.m')
plot3(ScoreValuesAsColumns(1,600+1:600+200),ScoreValuesAsColumns(2,600+1:600+200),ScoreValuesAsColumns(3,600+1:600+200),'.c')
plot3(ScoreValuesAsColumns(1,800+1:800+200),ScoreValuesAsColumns(2,800+1:800+200),ScoreValuesAsColumns(3,800+1:800+200),'.k')
title('PURE PCA')
grid


