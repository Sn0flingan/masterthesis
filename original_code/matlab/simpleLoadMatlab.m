%% Loading data
%% Load in blank and pool data
%Initalize parameters

%Go into data folder
cd /proj/p2013014/nobackup/nils_xjob/stef_batch/Obaid

clear all

cd Ancitabine %go into blank folder
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
eval(['save(''ancitabine.mat'', ' saveStr ');'])

clear all

cd ../Asprin %go into blank folder
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
eval(['save(''asprin.mat'', ' saveStr ');'])

clear all

cd ../Atrazine %go into blank folder
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
eval(['save(''atrazine.mat'', ' saveStr ');'])

clear all

cd ../BetaEstradiol %go into blank folder
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
eval(['save(''betaEstradiol.mat'', ' saveStr ');'])

clear all

cd ../BisphenolA %go into blank folder
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
eval(['save(''bisphenolA.mat'', ' saveStr ');'])

clear all

cd ../BLANK/1 %go into blank folder
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
eval(['save(''blankB1.mat'', ' saveStr ');'])

clear all

cd ../2 %go into blank folder
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
eval(['save(''blankB2.mat'', ' saveStr ');'])

clear all

cd ../3 %go into blank folder
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
eval(['save(''blankB3.mat'', ' saveStr ');'])

clear all

cd ../4 %go into blank folder
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
eval(['save(''blankB4.mat'', ' saveStr ');'])

clear all

cd ../../Bortezomib %go into blank folder
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
eval(['save(''bortezomib.mat'', ' saveStr ');'])

clear all

cd ../Chloroquine %go into blank folder
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
eval(['save(''chloroquine.mat'', ' saveStr ');'])

clear all
