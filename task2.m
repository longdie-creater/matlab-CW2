%Jiayi Wei 20513778 ssyjw20@nottingham.edu.cn

%temp_monitor.m
%for monitoring the tempreture and control leds
function temp_monitor(a)
    %set the tempreture graph
    figure;
    h=plot(NaN, NaN); 
    xlabel('Time (s)');
    ylabel('Temperature (°C)');
    xlim([0, 600]); %time
    ylim([10, 30]); %tempreture rage 

    green='D8'; 
    yellow='D10'; 
    red='D12';%control leds
    sensorPin='A0'%control sensor
    writeDigitalPin(a, green, 0);%initialize the leds
    writeDigitalPin(a, yellow, 0);
    writeDigitalPin(a, red, 0);
    
    duration=600; %colect data for 600 seconds
    data=zeros(1, duration);%store the temp data
    
logFile=fopen('cabin_temperature.txt', 'w');
fprintf(logFile, 'Data logging initiated\n');
fprintf(logFile, 'Location - Nottingham\n\n');%record the temp data



while true
    voltage=readVoltage(a,'A0');
    temperature=(voltage-0.5)/0.02;%read tem and transfer to centigrade
    
    time=time+1;
    temperatureArray=[temperatureArray temperature];
    
    set(h, 'XData', [get(h, 'XData') time], 'YData', temperatureArray);
    drawnow;

    fprintf(logFile, 'Minute\t%d\n', time);
    fprintf(logFile, 'Temperature\t%.2f C\n\n', temperature);%record the data
    
    %control led based on the tempreture
    if temperature>=18 &&temperature<=24
        %temperature between 18°C and 24°C, green constantly lit
        writeDigitalPin(a, green, 1);
        writeDigitalPin(a, yellow, 0);
        writeDigitalPin(a, redLED, 0);

    elseif temperature<18
        %temperature below 18°C, yellow flashes
        writeDigitalPin(a, green, 0);
        while true
            writeDigitalPin(a, yellow, 1);
            pause(0.5); %lit for each 0.5s
            writeDigitalPin(a, yellow, 0);
            pause(0.5); %turned off each 0.5s
            
            % If returns to normal range, cease flashing
            if temperature>=18 && temperature<=24
                break;
            end
        end

    elseif temperature>24
        %temperature exceeds 24°C, red flashes.
        writeDigitalPin(a, green, 0);
        while true
            writeDigitalPin(a, red, 1);
            pause(0.25); %lit for each 0.25s
            writeDigitalPin(a, red, 0);
            pause(0.25); %turned off each 0.25s
            
            % If returns to normal range, cease flashing
            if temperature>=18 && temperature<=24
                break;
            end
        end
    end
end