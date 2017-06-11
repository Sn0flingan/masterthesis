%% Loading data
%% Load in blank and pool data
%Initalize parameters

%Go into data folder
cd /proj/p2013014/nobackup/nils_xjob/stef_batch/Obaid

cd Albendazole %go into blank folder
files = dir('*.mzXML'); %extract mzXML filenames
no = size(files,1); %store number of blank samples
saveStr = '''files'''; %store which files are saved
for i=1:no
    inputfile = files(i).name;
    mzXMLstruc = mzxmlread(inputfile);
    eval(['[pl_' num2str(i) ', rt_' num2str(i) '] = mzxml2peaks(mzXMLstruc);']);
    saveStr = [saveStr ', ''pl_' num2str(i) ''', ''rt_' num2str(i) ''''];
    delete(inputfile);
end
eval(['save(''albendazole.mat'', ' saveStr ');'])


