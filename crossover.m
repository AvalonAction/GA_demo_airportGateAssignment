function chroms = crossover(chroms, croPos)
%½»²æ
disp('crossover executing...');
[~,n]=size(chroms);
[~,m] = size(chroms{1,1}.HangbanSeNum);
flag = 1;
while flag == 1
    t1 = randi([1 round(m)],1,1);
    t2 = randi([1 round(m)],1,1);
    if t2>t1 && t2<=m
        flag = 0;
        break;
    end
end


for i=1:2:n-mod(n,2)
    if croPos>=rand
        a=chroms{1,i}.Position(t1:t2);
        b=chroms{1,i+1}.Position(t1:t2);
        
        chroms{1,i}.Position(t1:t2)=b;
        chroms{1,i+1}.Position(t1:t2)=a;
    end 
end

end