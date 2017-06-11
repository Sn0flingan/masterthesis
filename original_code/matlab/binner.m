function binner( name )

addpath('/proj/p2013014/nobackup/nils_xjob/stef_batch');

cd Obaid

eval(['cd ' name]) %go into folder
name = strsplit(name, '/');
name = cell2mat(name);
eval(['load ' name '.mat']) %go into folder

saveStr = '''MZ''';

for i=1:length(files)
    eval(['[MZ, I_' num2str(i) '] = binMZnoRT(pl_' num2str(i) ');'])
    saveStr = [saveStr ', ''I_' num2str(i) ''''];
end
sampleinfo = strsplit(files(1).name, '_');
eval(['save(''' name '_' cell2mat(sampleinfo(2)) '_MZ.mat'', ' saveStr ');']);

end

