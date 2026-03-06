clc; clear; close all;

% Thông số của mô hình
Gm = 10;        % Tăng ích cực đại của búp sóng chính (dB)
Gs = 1;         % Tăng ích trung bình của búp sóng phụ (dB)
omega = pi/6;   % Góc búp sóng 3 dB (Half-Power Beamwidth, HPBW)
theta_m = pi/3; % Góc búp sóng chính (Main-Lobe Beamwidth)
omega1 = pi/4;
theta_m1 = pi/2;

% Tạo trục góc từ -pi đến pi
theta = linspace(-pi, pi, 2000);
G = zeros(size(theta));
G1 = zeros(size(theta));
% Tính giá trị G(θ) theo công thức
for i = 1:length(theta)
    if abs(theta(i)) <= theta_m/2
        G(i) = Gm * 10^(-3/10 * (2*theta(i)/omega)^2); % Suy giảm Gaussian
    else
        G(i) = Gs; % Giữ mức side-lobe gain
    end
end

for i = 1:length(theta)
    if abs(theta(i)) <= theta_m1/2
        G1(i) = Gm * 10^(-3/10 * (2*theta(i)/omega1)^2); % Suy giảm Gaussian
    else
        G1(i) = Gs; % Giữ mức side-lobe gain
    end
end

% Vẽ đồ thị dạng phân cực
figure;
subplot(2,2,1);
polarplot(theta, G, 'b', 'LineWidth', 2);
title('Beam Pattern của Anten');

% Vẽ đồ thị dạng Cartesian (búp sóng theo độ lợi)
subplot(2,2,2);
plot(rad2deg(theta), G, 'r', 'LineWidth', 2);
xlabel('\theta (độ)');
ylabel('Gain (dB)');
title('Mô hình búp sóng anten');
grid on;

subplot(2,2,3);
polarplot(theta, G1, 'b', 'LineWidth', 2);
title('Beam Pattern của Anten');

% Vẽ đồ thị dạng Cartesian (búp sóng theo độ lợi)
subplot(2,2,4);
plot(rad2deg(theta), G1, 'r', 'LineWidth', 2);
xlabel('\theta (độ)');
ylabel('Gain (dB)');
title('Mô hình búp sóng anten');
grid on;