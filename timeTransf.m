function time = timeTransf(hms, flag)


if flag == 1
    dt = datevec(hms);           % 分离处理
    h = dt(1,4)';   % 取出小时数
    m = dt(1,5)';   % 取出分钟数
    time = h*60+m;                      % 差值合成分钟数
else  
    time = datestr(datenum(num2str( floor(hms/60)*100 + rem(hms, 60)),'HHMM'),'HH:MM');
end
end