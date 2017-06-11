function loadMzxml2( foldername )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%Go into data folder
cd /proj/p2013014/nobackup/nils_xjob/stef_batch/Obaid

eval(['cd ' foldername]) %go into folder
files = dir('*.mzXML'); %extract mzXML filenames
no = size(files,1); %store number of blank samples
saveStr = zeros(no+1,1);
saveStr(1) = '''files'''; %store which files are saved
for i=1:no
    tic
    inputfile = files(i).name;
    mzXMLstruc = mzxmlread(inputfile);
    eval(['[pl_' num2str(i) ', rt_' num2str(i) '] = mzxml2peaks(mzXMLstruc);']);
    saveStr(i+1) = [', ''pl_' num2str(i) ''', ''rt_' num2str(i) ''''];
    delete(inputfile);
    toc
end
saveStr = strjoin(saveStr,'');
eval(['save(''' foldername '.mat'', ' saveStr ');'])

