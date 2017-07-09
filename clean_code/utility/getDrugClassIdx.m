function [ idx ] = getDrugClassIdx( drugClass, sMeta )
%GETDRUGCLASSIDX get indicies for all samples in one drugclass
%   Input:
%       drugClass(string) - name of drugclass to get samples from. The name
%       is case insensitive, BUT the name must be a true match. The options
%       are:
%           estrogen
%           anti-inflammatory
%           tyrosine kinase
%           hdac inhibitors
%           pesticides
%       sMeta(table) - table with meta info about samples. First column
%       must contain the drugname added.
%   Output:
%       idx(list) - list of indicies for sample beloning to requested
%                   drugclass. 
%
%   Implemented by NA 2017-03-07

idx = [];
if(strcmpi(drugClass,'estrogen'))
    idx = [idx; findSampleIdx(sMeta, 'BetaEstradiol')];
    idx = [idx; findSampleIdx(sMeta, 'Diethylstilbestrol')];
    idx = [idx; findSampleIdx(sMeta, 'Bisphenol')];
    idx = [idx; findSampleIdx(sMeta, 'Genistein')];
    idx = [idx; findSampleIdx(sMeta, 'Quercetin')];
    idx = [idx; findSampleIdx(sMeta, 'Tamoxifen')];
elseif(strcmpi(drugClass,'anti-inflammatory'))
    idx = [idx; findSampleIdx(sMeta, 'Dexamethasone')];
    idx = [idx; findSampleIdx(sMeta, 'Hydrocortisone')];
    idx = [idx; findSampleIdx(sMeta, 'Prednisolone')];
    idx = [idx; findSampleIdx(sMeta, 'Aspirin')];
    idx = [idx; findSampleIdx(sMeta, 'Ibuprofen')];
    idx = [idx; findSampleIdx(sMeta, 'Chloroquine')];
    idx = [idx; findSampleIdx(sMeta, 'NVP')];
elseif(strcmpi(drugClass,'tyrosine kinase'))
    idx = [idx; findSampleIdx(sMeta, 'Erlotinib')];
    idx = [idx; findSampleIdx(sMeta, 'Gefitinib')];
    idx = [idx; findSampleIdx(sMeta, 'Lapatinib')];
elseif(strcmpi(drugClass,'hdac inhibitors'))
    idx = [idx; findSampleIdx(sMeta, 'Vinblastine')];
    idx = [idx; findSampleIdx(sMeta, 'Vincristine')];
    idx = [idx; findSampleIdx(sMeta, 'Albendazole')];
    idx = [idx; findSampleIdx(sMeta, 'Mebendazole')];
    idx = [idx; findSampleIdx(sMeta, 'Trichostatin')];
elseif(strcmpi(drugClass,'pesticides'))
    idx = [idx; findSampleIdx(sMeta, 'Octylmethoxycinnamate')];
    idx = [idx; findSampleIdx(sMeta, 'Diuron')];
    idx = [idx; findSampleIdx(sMeta, 'Glyphosate')];
    idx = [idx; findSampleIdx(sMeta, 'Atrazine')];
    idx = [idx; findSampleIdx(sMeta, 'Dimephenthioate')];
    idx = [idx; findSampleIdx(sMeta, 'Thiram')];
end

end

