function time = timeTransf(hms, flag)


if flag == 1
    dt = datevec(hms);           % ���봦��
    h = dt(1,4)';   % ȡ��Сʱ��
    m = dt(1,5)';   % ȡ��������
    time = h*60+m;                      % ��ֵ�ϳɷ�����
else  
    time = datestr(datenum(num2str( floor(hms/60)*100 + rem(hms, 60)),'HHMM'),'HH:MM');
end
end