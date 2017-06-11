function [] = binMatlab()
%% Loading data
%% Load in blank and pool data
%Initalize parameters

%Go into data folder
cd /proj/p2013014/nobackup/nils_xjob/stef_batch/Obaid/All_4_Pools/All_4_Pools

clear all
tic;
files = dir('*_10.mzXML') %extract mzXML filename
inputfile = files(1).name;
mzXMLstruc = mzxmlread(inputfile);
[pl, rt] = mzxml2peaks(mzXMLstruc);
cd /proj/p2013014/nobackup/nils_xjob/stef_batch/matlab
[MZ, I] = binMZnoRT(pl);
toc
%eval(['save(''ancitabine.mat'', ' saveStr ');'])
end
