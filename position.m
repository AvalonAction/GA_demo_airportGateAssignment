function chroms = position(chroms,str,hangbanData,positionData,timeInter,time)
%{
① 读取航班信息，机位信息，读取初始航班可停靠的机位集合；
② 随机选取集合中的一个机位，作为该航班的停机位，然
   后更新该机位的空闲开始时间，使该机位的空闲开始时间等于该航班的离
   港时间； 
③ 以此类推，输出可行解。（如果最终还有航班未分配，推倒重来）
%}
disp('position executing...');
[~,n] = size(chroms);
[~,m] = size(chroms{1,1}.HangbanSeNum);
[q,~] = size(positionData);
chomTemp = cell(1,1);

%初次分配机位
if strcmp('first', str)
    i = 1;
    while i <= n
        %         posisionDisp = zeros(m);
      
        j = 1;
        
        while j <= m
            %如果已分配跳过
            if  chroms{1,i}.unappropriated(j)==0
                j = j+1;
                continue;
            end
        
            flag1 = 1;
            
            while flag1<q
                tt = randi([1 round(q)],1,1);
               
               
                if ((hangbanData(j,5)+time(tt,(hangbanData(j,7)))-positionData(tt,4)) >= 0 ...
                        && (hangbanData(j,4)<=positionData(tt,2)) )%机型匹配
                  
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
    %交叉、变异后调整以符合约束
elseif strcmp('else', str)
    count = 0;
    i = 1;
    while i < n

        j = 1;
        while j <= m
            %如果当前航班分配机位满足约束，更新并跳过
            if (hangbanData(j,5)+time(chroms{1,i}.Position(j),(hangbanData(j,7)))>=positionData(chroms{1,i}.Position(j),4)) ...
                    &&(hangbanData(j,4)<=positionData(chroms{1,i}.Position(j),2))
                
                positionData(chroms{1,i}.Position(j),4) = hangbanData(j,6) + timeInter;%更新机位空闲时间
                j=j+1;
                continue;
            else
                %如果当前航班分配机位不满足约束
                %寻找空闲机位：先找此时间区间占用航班，排除该航班占用机位，随机分配机位至指定航班；
                index0 = 1;
                onuseHB = zeros(1,q);%占用机位对应索引值置1
                while index0 <= m
                    if ((hangbanData(index0,5)-timeInter<hangbanData(j,6)) || (hangbanData(index0,6)+timeInter>hangbanData(j,5)))
                        onuseHB(1,chroms{1,i}.Position(index0)) = 1;
                        
                    end
                    index0=index0+1;
                end
                flag1 = 1;
                while flag1 <= 2*q   %随机分配机位至指定航班
                    tt = randi([1 round(q)],1,1);
                    
                    if(    (onuseHB(1,tt)==0) ...%空闲
                            && (hangbanData(j,5)+time(chroms{1,i}.Position(j),(hangbanData(j,7)))>=positionData(tt,4))) ...
                            && (hangbanData(j,4)<=positionData(tt,2))%机型匹配
                        
                        
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