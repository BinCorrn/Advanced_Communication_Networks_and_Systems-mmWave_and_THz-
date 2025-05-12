bandwidth0h = 13.87 + 0.1*randn(100,1);
bandwidth1h = 9.3+ 0.1*randn(100,1);
bandwidth2h = 7.85 + 0.1*randn(100,1);
bandwidth3h = 6.45 + 0.1*randn(100,1);
bandwidth4h = 7 + 0.1*randn(100,1);
bandwidth5h = 6.8 + 0.1*randn(100,1);
bandwidth6h = 10.5 + 0.5*randn(100,1);
bandwidth7h = 13.5 + 1*randn(100,1);
bandwidth8h = 16.5 + 1*randn(100,1);
bandwidth9h = 19.5 + 1*randn(100,1);
bandwidth10h = 20.5 + 1.5*randn(100,1);
bandwidth11h = 25.5 + 1.5*randn(100,1);
bandwidth12h = 23.5 + 2*randn(100,1);
bandwidth13h = 22 + 2*randn(100,1);
bandwidth14h = 21.5 + 2*randn(100,1);
bandwidth15h = 19 + 2*randn(100,1);
bandwidth16h = 23 + 2*randn(100,1);
bandwidth17h = 25 + 2*randn(100,1);
bandwidth18h = 30 + 2*randn(100,1);
bandwidth19h = 33 + 2*randn(100,1);
bandwidth20h = 36 + 3*randn(100,1);
bandwidth21h = 39 + 3*randn(100,1);
bandwidth22h = 32 + 2.5*randn(100,1);
bandwidth23h = 22 + 2*randn(100,1);

data = [bandwidth0h bandwidth1h bandwidth2h bandwidth3h bandwidth4h ...
        bandwidth5h bandwidth6h bandwidth7h bandwidth8h bandwidth9h ...
        bandwidth10h bandwidth11h bandwidth12h bandwidth13h bandwidth14h ...
        bandwidth15h bandwidth16h bandwidth17h bandwidth18h bandwidth19h ...
        bandwidth20h bandwidth21h bandwidth22h bandwidth23h];

data_seq = reshape(data', [], 1);  % [24000 x 1]

%% Chuẩn hóa và chuyển thành dạng cell
[data_norm, settings] = mapminmax(data_seq');
sequence = num2cell(data_norm, 1);

%% Chia tập train/test
numTrain = floor(0.8 * numel(sequence));
XTrain = sequence(1:numTrain-1);
YTrain = sequence(2:numTrain);

XTest = sequence(numTrain:end-1);
YTest = sequence(numTrain+1:end);

%% Xây dựng mô hình LSTM
inputSize = 1;
numHiddenUnits = 100;
outputSize = 1;

layers = [
    sequenceInputLayer(inputSize)
    lstmLayer(numHiddenUnits)
    fullyConnectedLayer(outputSize)
    regressionLayer
];

options = trainingOptions('adam', ...
    'MaxEpochs', 150, ...
    'GradientThreshold', 1, ...
    'InitialLearnRate', 0.005, ...
    'Verbose', 0, ...
    'Plots', 'training-progress');

%% Huấn luyện mô hình
net = trainNetwork(XTrain, YTrain, layers, options);

%% Dự đoán trên tập kiểm tra
YPred = predict(net, XTest);

% Chuyển về giá trị ban đầu
YPred = mapminmax('reverse', cell2mat(YPred), settings);
YTest = mapminmax('reverse', cell2mat(YTest), settings);

%% Vẽ kết quả
figure;
plot(YTest, 'b'); hold on;
plot(YPred, 'r--');
legend('Giá trị thực tế','Giá trị dự đoán');
xlabel('Thời gian');
ylabel('Băng thông (MHz)');
title('Dự đoán nhu cầu băng thông bằng LSTM');

%% Đánh giá lỗi
rmse= sqrt(mean(YPred - YTest).^2);
rmse_avr = mean(rmse);
disp(['RMSE: ', num2str(rmse_avr)]);