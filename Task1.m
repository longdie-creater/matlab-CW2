%Jiayi Wei 20513778

a=arduino%delete this line after setting

duration=600;
tempData=zeros(1,duration);
time=1:duration;

for t=1:duration
    voltage=readVoltage(a,'A0');
    temp=(voltage-0.5)/0.01;
    tempData(t)=temp;
    pause(1);%read temperture each second
end

min=min(tempData);
max=max(tempData);
avg=mean(tempData);

% Task 1c: Plot
plot(time,tempData);
xlabel('Time (s)');
ylabel('Temperature (°C)');%plot the data

% Task 1d: Print to screen
fprintf('Date: %s\tLocation: Cabin\n', datestr(now, 'dd-mm-yyyy'));
for minute=0:10
    idx=minute*60+1;
    fprintf('Time: Minute %d\tTemperature: %.2f°C\n', minute, tempData(idx));
end%show the form

% Task 1e: Write to file
fileID=fopen('cabin_temperature.txt', 'w');
fprintf(fileID, 'Date: %s\tLocation: Cabin\n', datestr(now, 'dd-mm-yyyy'));
for minute=0:10
    idx=minute*60+1;
    fprintf(fileID, 'Time: Minute %d\tTemperature: %.2f°C\n', minute, tempData(idx));
end
fclose(fileID);