file_info= spm_vol('w5104-2019.5.30.11.10_rsl.img');
>> imge_file_data = spm_read_vols(file_info);
>> temp = permute(imge_file_data,[2 1 3]);
>> Tx00 = temp(:,:,1);
>> imagesc(Tx00)
>> Tx35 = temp(:,:,35);
>> imagesc(Tx35)
>> axis equal
>> lTx35 = reshape(Tx35,95*79);
??? Error using ==> reshape
Size vector must have at least two elements.

>> lTx35 = reshape(Tx35,[95*79 1]);
>> figure
>> histogram(lTx35)
??? Undefined command/function 'histogram'.

>> hist(lTx35)
>> lTx35_over_05=find(lTx35>0.5);
>> lTx35_over_05 = 

>> Corr48 = temp(48,:,:);
>> Corr48 = permute(Corr48,[2 3 1]);