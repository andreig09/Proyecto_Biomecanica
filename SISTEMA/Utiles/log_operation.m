function contador = log_operation(varargin)
%se utiliza esta funcion para contar cuantas veces se entra a un ciclo
%parfor
global contador
if strcmp(varargin{1}, 'reset') %se quiere resetear el contador    
    if isempty(contador)
        contador = 0;
    end
else %se quiere incrementar el contador
    matlabpool size;
    n = ans; %encuentro cuantos procesadores se estan usando
    if n~=0
        contador = contador + n; %se tienen parfor con n procesadores en paralelo
        if contador>varargin{1}
            contador = varargin{1};
        end
    else
        contador = contador + 1; %se tiene un for simple
    end
end

end