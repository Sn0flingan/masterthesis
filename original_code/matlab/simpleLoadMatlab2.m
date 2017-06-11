%% Loading data
%% Load in blank and pool data
%Initalize parameters

%Go into data folder
cd /proj/p2013014/nobackup/nils_xjob/stef_batch/Obaid

clear all

cd Daidzein %go into blank folder
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
eval(['save(''daidzein.mat'', ' saveStr ');'])

clear all

cd ../Dexamethasone %go into blank folder
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
eval(['save(''dexamethasone.mat'', ' saveStr ');'])

clear all

cd ../Diethylstilbestrol %go into blank folder
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
eval(['save(''diethylstilbistrol.mat'', ' saveStr ');'])

clear all

cd ../Dimephentioate %go into blank folder
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
eval(['save(''dimephentioate.mat'', ' saveStr ');'])

clear all

cd ../Diuron %go into blank folder
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
eval(['save(''diuron.mat'', ' saveStr ');'])

clear all

cd ../Erlotinib %go into blank folder
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
eval(['save(''erlotinib.mat'', ' saveStr ');'])

clear all

cd ../Gefitinib %go into blank folder
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
eval(['save(''gefitinib.mat'', ' saveStr ');'])

clear all

cd ../Genistein %go into blank folder
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
eval(['save(''genistein.mat'', ' saveStr ');'])

clear all

cd ../Glyphosate %go into blank folder
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
eval(['save(''glyphosate.mat'', ' saveStr ');'])

clear all

cd ../Hydrocortisone %go into blank folder
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
eval(['save(''hydrocortisone.mat'', ' saveStr ');'])

clear all

cd ../../Ibuprofen %go into blank folder
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
eval(['save(''ibuprofen.mat'', ' saveStr ');'])

clear all

cd ../Lapatinib %go into blank folder
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
eval(['save(''lapatinib.mat'', ' saveStr ');'])

clear all

cd ../Medendazole %go into blank folder
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
eval(['save(''medendazole.mat'', ' saveStr ');']);

clear all

cd ../NVP-BEZ235 %go into blank folder
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
eval(['save(''NVP-BEZ235.mat'', ' saveStr ');']);

clear all

cd ../Octylmethoxycinnamate %go into blank folder
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
eval(['save(''octylmethoxycinnamate.mat'', ' saveStr ');']);

clear all

cd ../Phthalate %go into blank folder
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
eval(['save(''phthalate.mat'', ' saveStr ');']);

clear all

cd ../PoolBatch1 %go into blank folder
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
eval(['save(''poolB1.mat'', ' saveStr ');']);

clear all

cd ../PoolBatch2 %go into blank folder
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
eval(['save(''poolB2.mat'', ' saveStr ');']);

clear all

cd ../PoolBatch3 %go into blank folder
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
eval(['save(''poolB3.mat'', ' saveStr ');']);

clear all

cd ../PoolBatch4 %go into blank folder
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
eval(['save(''poolB4.mat'', ' saveStr ');']);

clear all

cd ../Prednisolone %go into blank folder
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
eval(['save(''prednisolone.mat'', ' saveStr ');']);

clear all

cd ../Quercetin %go into blank folder
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
eval(['save(''quercetin.mat'', ' saveStr ');']);

clear all

cd ../Rapamycin %go into blank folder
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
eval(['save(''rapamycin.mat'', ' saveStr ');']);

clear all

cd ../Tamoxifen %go into blank folder
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
eval(['save(''tamoxifen.mat'', ' saveStr ');']);

clear all

cd ../Thiram %go into blank folder
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
eval(['save(''thiram.mat'', ' saveStr ');']);

clear all

cd ../TrichostatinA %go into blank folder
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
eval(['save(''trichostatinA.mat'', ' saveStr ');']);

clear all

cd ../Vinblastine %go into blank folder
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
eval(['save(''vinblastine.mat'', ' saveStr ');']);

clear all

cd ../Vincristine %go into blank folder
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
eval(['save(''vincristine.mat'', ' saveStr ');']);

clear all
