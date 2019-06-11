%Image Import
%file_info= spm_vol('w5104-2019.5.30.11.10_rsl.img');
file_list = ls;
w_file = ls(end,:)
%file_info = spm_vol(uigetfile('w*.img'));
file_info = spm_vol(w_file);
imge_file_data = spm_read_vols(file_info);
temp = permute(imge_file_data,[2 1 3]);
[Ny Nx Nz] = size(temp);%[Ny, Nx, Nz] = [95, 79, 69]
N = prod([Ny Nx Nz]);%517845
temp_1D = reshape(temp,[N,1]);%temp in 1D

%Transaxial VINCI plane 034 and Coronal VINCI 047
Tx35 = temp(:,:,35);
Cor48 = temp(48,:,:);
Cor48 = permute(Cor48,[2 3 1]); % this makes a 2D matrix

%Length of Y- and Z-Major Axes and its midpoints
Yx = Ny;%95
Yshft = (Ny+1)/2;%48
Zx = Nz;%69
Zshft = (Nz+1)/2;%35
%
%Length of X-Major Axis
%
Tx35g = sum(Tx35);%column sum
Td1 = diff(Tx35g);%the 1st difference
Cor48g = sum(Cor48,2)';%row sum transposed
Cd1 = diff(Cor48g);%the 1st difference
%left-end
[MxTd1L,idxTd1L] = max(Td1(1:10));%max, and its index in the list
[MxCd1L,idxCd1L] = max(Cd1(1:10));
candidateL = [idxTd1L,MxTd1L;...
              idxCd1L,MxCd1L];
%xL will be the smallest odd index              
switch sum(mod(candidateL(:,1),2))
  case 0
      xL = min(candidateL(:,1))-1;
  case 1
      xL = candidateL(:,1)'*mod(candidateL(:,1),2);
  case 2
      xL = min(candidateL(:,1));
end
%right-end
Llimit = length(Td1)-10;
[MxTd1R,idxTd1R] = max(abs(Td1(Llimit:end)));
[MxCd1R,idxCd1R] = max(abs(Cd1(Llimit:end)));
candidateR = [Llimit+idxTd1R-1,MxTd1R;...
              Llimit+idxCd1R-1,MxCd1R];%index in the first difference
candidateR(:,1) = candidateR(:,1)+1;%index on the voxel along X-axis
%xR will be the largest odd index  
switch sum(mod(candidateR(:,1),2))
  case 0
      xR = min(candidateR(:,1))+1;
  case 1
      xR = candidateR(:,1)'*mod(candidateR(:,1),2);
  case 2
      xR = max(candidateR(:,1));
end
%X-Major axis: [xL,xR]
Xx = xR-xL+1;%length
Xshft = (Xx+1)/2 + (xL-1);%center

%Equation of an ellipsoid
%def. of an image dimension on line 5
x = [1:Nx];%x-axis
y = [1:Ny];%y-axis
z = [1:Nz];%z-axis
[X,Y,Z] = meshgrid(x,y,z);%3D matrix grid
%inside = find((X-39).^2/[(73-1)/2]^2 + (Y-48).^2/[(95-1)/2]^2 + (Z-35).^2/[(69-1)/2]^2 <1);
inside = find((X-Xshft).^2/[(Xx-1)/2]^2 + (Y-Yshft).^2/[(Yx-1)/2]^2 + (Z-Zshft).^2/[(Zx-1)/2]^2 <1);

ave_intensity = mean(temp_1D(inside))
std_intensity = std(temp_1D(inside))
num_vxl = length(inside)

%
% obtain and save the ICVOI image
%
s = pwd;
file_info_ICVOI = file_info;
s_slash = regexp(s,'\');
patient = s(s_slash(max(find(s_slash-27<0)))+1:union(regexp(s,'F_'),regexp(s,'M_')));
file_info_ICVOI.fname = [patient,'_ICVOI.img'];
file_info_ICVOI.descrip = 'spm - algebra';
expression = ['i1/',num2str(ave_inensity)];
Vo = spm_imcalc(file_info,file_info_ICVOI,expression);
