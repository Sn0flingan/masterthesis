function [files, pl] = loadMzxml( foldername )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%Go into data folder
cd /proj/p2013014/nobackup/nils_xjob/stef_batch/Obaid


eval(['cd ' foldername]) %go into folder
files = dir('*.mzXML'); %extract mzXML filenames
no = size(files,1); %store number of blank samples
pl = cell(1);
parfor i=1:no
    tic
    inputfile = files(i).name;
    mzXMLstruc = mzxmlread(inputfile);
    [peaklst, ret_time] = mzxml2peaks(mzXMLstruc);
    size(peaklst)
    size(ret_time)
    pl{i} = [ret_time' peaklst']; %Store data
    delete(inputfile);
    toc
end
eval(['save(''' foldername '.mat'', ''pl'', ''files'');']);
end
