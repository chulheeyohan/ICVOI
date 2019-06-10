%Image Import
file_info= spm_vol('w5104-2019.5.30.11.10_rsl.img');
imge_file_data = spm_read_vols(file_info);
temp = permute(imge_file_data,[2 1 3]);
N = prod(size(temp));%517845
temp_1D = reshape(temp,[N,1]);%temp in 1D

%Transaxial VINCI plane 034 and Coronal VINCI 047
Tx35 = temp(:,:,35);
Cor48 = temp(48,:,:);
Cor48 = permute(Cor48,[2 3 1]); % this makes a 2D matrix

%
Yx = 95;
Zx = 69;
Tx35g = sum(Tx35);%column sum
Cor48g = sum(Cor48,2)';%row sum transposed

x = [1:79];
y = [1:95];
z = [1:69];
[X,Y,Z] = meshgrid(x,y,z);
inside = find((X-39).^2/[(73-1)/2]^2 + (Y-48).^2/[(95-1)/2]^2 + (Z-35).^2/[(69-1)/2]^2 <1);

mean(temp_1D(inside))
std(temp_1D(inside))
length(inside)
