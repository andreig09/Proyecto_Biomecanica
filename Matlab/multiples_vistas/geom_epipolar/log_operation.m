function contador = log_operation(str)
%se utiliza esta funcion para contar cuantas veces se entra a un ciclo
%parfor

if ~exist('contador')
    global contador
end
if strcmp(str, 'reset')
    contador = 0;
else if isempty(contador)
        contador = 0;
    end
    matlabpool size;
    n = ans; %encuentro cuantos procesadores se estan usando
    contador = contador + n;
end

end