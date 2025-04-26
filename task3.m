%Jiayi Wei 20513778 ssyjw20@nottingham.edu.cn

% temp_prediction.m
%for tempreture prdiction 
function temp_prediction(a)
    green='D8';
    yellow='D10';
    red='D12';
    sensorPin='A0';
    writeDigitalPin(a, green, 0);
    writeDigitalPin(a, yellow, 0);
    writeDigitalPin(a, red, 0);

figure;
h=plot(NaN, NaN);
xlabel('Time (s)');
ylabel('Temperature (°C)');
xlim([0, 600]);
ylim([10, 30]);

time=0;
previousTemp=0;%last temp
previousTime=time; % last time
tempChanges = []; % store the temp change  
tempArray = [];


while true

    voltage=readVoltage(a, sensorPin);
    temperature=(voltage-0.5)/0.02;%read the tempreture 
    

    deltaTemperature=temperature-previousTemp;
    deltaTime=time-previousTime; %calculate the changing rate 

    changingrate=(deltaTemperature/deltaTime)*60; %°C/s to °C/min
    
    tempChanges = [tempChanges changingrate]; %store the changing rate
    tempArray = [tempArray temperature]; %store the tem data 
    
    
    previousTemp=temperature;
    previousTime=time;%renew time and temp
    
    time=time+1;
    
    set(h, 'XData', [get(h, 'XData') time], 'YData', tempArray);
    drawnow;%refresh chart
    
    if changingrate>4 % changing rate greater than 4°C/min (increase)
        for i = 1:5
            writeDigitalPin(a, red, 1);
            pause(0.25);
            writeDigitalPin(a, red, 0);
            pause(0.25);%red flash
        end
        writeDigitalPin(a, yellow, 0); %turn off yellow
        writeDigitalPin(a, green, 0); %turn green 

    elseif changingrate<-4 %changing rate less than -4°C/min (decreasing).
        for i = 1:5
            writeDigitalPin(a, yellow, 1);
            pause(0.25);
            writeDigitalPin(a, yellow, 0);
            pause(0.25);%yellow flash
        end
        writeDigitalPin(a, red, 0); %turn off red
        writeDigitalPin(a, green, 0); %turn off green

    else %changing rate within ±4°C/min (stable)
        writeDigitalPin(a, green, 1);%green constant lit
        writeDigitalPin(a, yellow, 0); %turn off yellow
        writeDigitalPin(a, red, 0); %turn off green
    end
    

    predictionTime=5; %preidct 5min
    predictedTemperature = temperature + (changingrate * predictionTime);
    disp(['Predicted Temperature in 5 minutes: ', num2str(predictedTemperature), ' °C']);
    
    pause(1); %refresh for each second
end
