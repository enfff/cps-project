function v = uniformly_distribuited_vector_on_union_domain(p, b1, b2, b3, b4)
% TODO: Riscrivi b_i come vettori
% Genera un vettore colonna lungo p con valori uniformemente distribuiti in
% un dominio [b1, b2] U [b3, b4]. Es: [-2, -1] U [1, 2]
% La media 0 è grarantita dal fatto che la distribuzione uniforme è simmetrica

traslazione = mean([abs(b1), abs(b4)]);
scala = (abs(b1)+abs(b4)); %

v = (scala * rand(p, 1)) - traslazione;

% S è il supporto di vettore
S = find(v > b2 & v < b3);

if ~isempty(S)
    for i = 1:size(S) % Controlla se esiste costrutto in
        while v(S(i)) > b1 && v(S(i)) < b3
            v(S(i)) = (scala*rand(1)) - traslazione;
        end
    end
end

% vettore
% mean(vettore)

end