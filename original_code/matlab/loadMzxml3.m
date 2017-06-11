function [files, pl] = loadMzxml3( foldername )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%Go into data folder
cd /proj/p2013014/nobackup/nils_xjob/stef_batch/Obaid


eval(['cd ' foldername]) %go into folder
foldername = strsplit(foldername, '/');
foldername = cell2mat(foldername); %remove / from name
files = dir('*.mzXML'); %extract mzXML filenames
no = size(files,1); %store number of blank samples
saveStr = '''files'''; %store which files are saved
for i=1:no
    tic
    inputfile = files(i).name
    mzXMLstruc = mzxmlread(inputfile);
    eval(['[pl_' num2str(i) ', rt_' num2str(i) '] = mzxml2peaks(mzXMLstruc);']);
    saveStr = [saveStr ', ''pl_' num2str(i) ''', ''rt_' num2str(i) ''''];
    delete(inputfile);
    toc
end
eval(['save(''' foldername '.mat'', ' saveStr ');'])
end
