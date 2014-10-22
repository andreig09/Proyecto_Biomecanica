function modify_bvh(bvh2modify, bvhDataHip)
% Funcion que permite modificar la trayectoria del hip de  un archivo bvh2modify
% para que sea igual a la trayectoria del hip del archivo bvhData

[C_out, index_data_out] = bvh2cell(bvh2modify);%contiene el bvh a modificar
[C_in, index_data_in] = bvh2cell(bvhDataHip);%contiene el bvh que se utiliza para modificaciones

InfoFrames_in = C_in(index_data_in:end);%Me quedo solo con los datos de cada frame
[row_in, ~]= size(InfoFrames_in);
InfoFrames_in = str2num(char(InfoFrames_in));%llevo toda la info a una matriz
InfoHipTraslation_in= InfoFrames_in(:,1:3);%Me quedo solo con la traslacion del HIP origen


InfoFrames_out = C_out(index_data_out:end);%Me quedo solo con los datos de cada frame
[row_out, ~]= size(InfoFrames_out);
InfoFrames_out = str2num(char(InfoFrames_out));%llevo toda la info a una matriz
InfoHipTraslation_out= InfoFrames_out(:,1:3);%Me quedo solo con la traslacion del HIP origen
%Modifico la traslacion de HIP destino
row = min([row_out, row_in]);
for k=2:row %para cada frame veo cual es la traslacion del HIP que se deberia tener y la agrego al bvh de salida
    traslation = InfoHipTraslation_in(k, :)-InfoHipTraslation_in(k-1, :);
    InfoHipTraslation_out(k, :) = InfoHipTraslation_out(k-1,:) + traslation;
end

InfoFrames_out(:, 1:3) = InfoHipTraslation_out;
%Llevo nuevamente a string la informacion de cada frame
InfoFrames_out= num2str_2(InfoFrames_out);

for k=1:row %para cada columna de InfoFrames
    C_out{k-1+index_data_out}=InfoFrames_out(k, :);
end
fid=fopen('salida.bvh','wt');
[rows,~]=size(C_out);
for i=1:rows
      fprintf(fid,'%s \n',C_out{i, end});      
end
fclose(fid);

end

function [C, index_data] = bvh2cell(nameText)
%fileID = fopen('Marcador_en_origen.bvh');
fileID = fopen(nameText);
n=1;%variable auxiliar
C = cell(1, 200);
%formo un cell array C con las filas del bvh
while ~feof(fileID) 
   leer_linea = fgetl(fileID);
   if isempty(leer_linea) || ~ischar(leer_linea), break, end
   C(n)= cellstr(leer_linea);
   if strfind(C{n}, 'MOTION') %encuentro donde se tiene la linea 'MOTION'
       index_data = n+3;
   end
   n=n+1;
end
fclose(fileID);
C=C';
end