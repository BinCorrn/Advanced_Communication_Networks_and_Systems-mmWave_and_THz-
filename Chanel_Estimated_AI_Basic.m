clc;
bandwidth0h = 13.87 + 0.25*randn(1000,1);
bandwidth1h = 9.3+ 0.25*randn(1000,1);
bandwidth2h = 7.85 + 0.25*randn(1000,1);
bandwidth3h = 6.45 + 0.25*randn(1000,1);
bandwidth4h = 7 + 0.5*randn(1000,1);
bandwidth5h = 6.8 + 0.5*randn(1000,1);
bandwidth6h = 10.5 + 0.5*randn(1000,1);
bandwidth7h = 13.5 + 1*randn(1000,1);
bandwidth8h = 16.5 + 1*randn(1000,1);
bandwidth9h = 19.5 + 1*randn(1000,1);
bandwidth10h = 20.5 + 1.5*randn(1000,1);
bandwidth11h = 25.5 + 1.5*randn(1000,1);
bandwidth12h = 23.5 + 1*randn(1000,1);
bandwidth13h = 22 + 1*randn(1000,1);
bandwidth14h = 21.5 + 1*randn(1000,1);
bandwidth15h = 19 + 1*randn(1000,1);
bandwidth16h = 23 + 2*randn(1000,1);
bandwidth17h = 25 + 2*randn(1000,1);
bandwidth18h = 30 + 2*randn(1000,1);
bandwidth19h = 33 + 2*randn(1000,1);
bandwidth20h = 36 + 2*randn(1000,1);
bandwidth21h = 39 + 2*randn(1000,1);
bandwidth22h = 32 + 2*randn(1000,1);
bandwidth23h = 22 + 1*randn(1000,1);

% Tạo mảng giờ (0 đến 23), mỗi giờ lặp 1000 lần
hour = repelem((0:23)', 1000);

% Ghép tất cả băng thông thành vector cột
bandwidth_all = [bandwidth0h; bandwidth1h; bandwidth2h; bandwidth3h;
                 bandwidth4h; bandwidth5h; bandwidth6h; bandwidth7h;
                 bandwidth8h; bandwidth9h; bandwidth10h; bandwidth11h;
                 bandwidth12h; bandwidth13h; bandwidth14h; bandwidth15h;
                 bandwidth16h; bandwidth17h; bandwidth18h; bandwidth19h;
                 bandwidth20h; bandwidth21h; bandwidth22h; bandwidth23h];
bandwidth_matrix = reshape(bandwidth_all, 1000, 24);  % mỗi cột là 1 giờ
mean_per_hour = mean(bandwidth_matrix);

% Tạo bảng dữ liệu
data = table(hour, bandwidth_all, 'VariableNames', {'Hour', 'Bandwidth'});

x = double(data.Hour') / 23;   % chuẩn hóa về [0,1]
y = double(data.Bandwidth');

net = fitnet(10); % mạng có 10 nút ẩn

[net, tr] = train(net, x, y);
y_pred = net(linspace(0, 1, 100));

% Vẽ kết quả
figure;
plot(data.Hour, data.Bandwidth, '.', 'MarkerSize', 4); hold on;
plot(linspace(0, 23, 100), y_pred, 'r-'); hold on;
plot(0:23, mean_per_hour,'b--');
xlabel('Giờ trong ngày');
ylabel('Băng thông (Mbps)');
title('Dự đoán băng thông sử dụng vào từng khung thời gian');
legend('Dữ liệu', 'Dự đoán mạng neural','Trung bình');
grid on;

