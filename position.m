function chroms = position(chroms,str,hangbanData,positionData,timeInter,time)
%{
�� ��ȡ������Ϣ����λ��Ϣ����ȡ��ʼ�����ͣ���Ļ�λ���ϣ�
�� ���ѡȡ�����е�һ����λ����Ϊ�ú����ͣ��λ��Ȼ
   ����¸û�λ�Ŀ��п�ʼʱ�䣬ʹ�û�λ�Ŀ��п�ʼʱ����ڸú������
   ��ʱ�䣻 
�� �Դ����ƣ�������н⡣��������ջ��к���δ���䣬�Ƶ�������
%}
disp('position executing...');
[~,n] = size(chroms);
[~,m] = size(chroms{1,1}.HangbanSeNum);
[q,~] = size(positionData);
chomTemp = cell(1,1);

%���η����λ
if strcmp('first', str)
    i = 1;
    while i <= n
        %         posisionDisp = zeros(m);
      
        j = 1;
        
        while j <= m
            %����ѷ�������
            if  chroms{1,i}.unappropriated(j)==0
                j = j+1;
                continue;
            end
        
            flag1 = 1;
            
            while flag1<q
                tt = randi([1 round(q)],1,1);
               
               
                if ((hangbanData(j,5)+time(tt,(hangbanData(j,7)))-positionData(tt,4)) >= 0 ...
                        && (hangbanData(j,4)<=positionData(tt,2)) )%����ƥ��
                  
                    chroms{1,i}.Position(j) = tt;
                    
                    positionData(tt,4) = hangbanData(j,6) + timeInter;
                    chroms{1,i}.unappropriated(j) = 0;
                    
                   
                    flag1 = q;
                    break;
                end
                flag1 = flag1+1;
            end
            j = j +1;
        end
        i = i+1;
        positionData(:,4)=0;
        for jj=1:m
            if chroms{1,i-1}.Position(jj) == 0
                chroms{1,i-1}.unappropriated(:) = 1;
                i = i - 1;
                break;
            end
        end
    end
    %���桢���������Է���Լ��
elseif strcmp('else', str)
    count = 0;
    i = 1;
    while i < n

        j = 1;
        while j <= m
            %�����ǰ��������λ����Լ�������²�����
            if (hangbanData(j,5)+time(chroms{1,i}.Position(j),(hangbanData(j,7)))>=positionData(chroms{1,i}.Position(j),4)) ...
                    &&(hangbanData(j,4)<=positionData(chroms{1,i}.Position(j),2))
                
                positionData(chroms{1,i}.Position(j),4) = hangbanData(j,6) + timeInter;%���»�λ����ʱ��
                j=j+1;
                continue;
            else
                %�����ǰ��������λ������Լ��
                %Ѱ�ҿ��л�λ�����Ҵ�ʱ������ռ�ú��࣬�ų��ú���ռ�û�λ����������λ��ָ�����ࣻ
                index0 = 1;
                onuseHB = zeros(1,q);%ռ�û�λ��Ӧ����ֵ��1
                while index0 <= m
                    if ((hangbanData(index0,5)-timeInter<hangbanData(j,6)) || (hangbanData(index0,6)+timeInter>hangbanData(j,5)))
                        onuseHB(1,chroms{1,i}.Position(index0)) = 1;
                        
                    end
                    index0=index0+1;
                end
                flag1 = 1;
                while flag1 <= 2*q   %��������λ��ָ������
                    tt = randi([1 round(q)],1,1);
                    
                    if(    (onuseHB(1,tt)==0) ...%����
                            && (hangbanData(j,5)+time(chroms{1,i}.Position(j),(hangbanData(j,7)))>=positionData(tt,4))) ...
                            && (hangbanData(j,4)<=positionData(tt,2))%����ƥ��
                        
                        
                        chroms{1,i}.Position(j) = positionData(tt,1);
                        positionData(tt,4) = hangbanData(j,6) + timeInter;
                        chroms{1,i}.unappropriated(j) = 0;%
                        j=j+1;
                        flag1 = q;
                        break;
                    end
                    flag1 = flag1 + 1;
                    chroms{1,i}.unappropriated(j) = 1;
                    
                end
                j = j+1;
            end
            
        end
        posisionDisp = chroms{1,i}.Position;
        posisionDisp;
        i = i+1;
        positionData(:,4)=0;
        for jj=1:m
            if chroms{1,i-1}.unappropriated(jj) == 1
                chomTemp{1,1} = chroms{1,i-1};
                chomTemp = position(chomTemp,'first',hangbanData,positionData,timeInter,time);
                chroms{1,i-1} = chomTemp{1,1} ;
                count = count +1;
                break;
            end
        end
        
    end
    count
end

end