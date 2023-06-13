clc
clear
QR_couples = [
        [1 2] % 1
        [3 4] % 2
        [5 6] % 3
        [7 8]
];

[couples_number, m] = size(QR_couples);

for couple_id=1:couples_number
    % Itera tra le coppie di QR
    Q = QR_couples(couple_id, 1)*eye(2);
    R = QR_couples(couple_id, 2);
end