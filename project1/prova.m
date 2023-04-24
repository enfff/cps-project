clc;

Z = [1 1 1
1 2 3
1 2 3];

Z(i, :)
Z(:, i)

if sum(Z(i, :)) ~= 3 || sum(Z(:, i)) ~= 3
    disp(['excp'])
else
    disp(['corretto!'])
end

clear Z;
