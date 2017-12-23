function chroms = sortByFitness(varargin)
%{
���غ�������Ӧ��ֵ����
�״β����뾫Ӣ
֮���þ�Ӣ�滻�������������
%}


if nargin==2
    goal = varargin{2};
    switch (goal)
        case 1
            chroms = varargin{1};
            [~,n] = size(chroms);
            for i = n:-1:1
                %ÿһ���ɵ����ϵ�����
                for j = 1:1:i-1
                    if chroms{1,j+1}.fitness1 < chroms{1,j}.fitness1
                        temp = chroms{1,j};
                        chroms{1,j} = chroms{1,j+1};
                        chroms{1,j+1} = temp;
                    end
                end
            end
        case 2
            chroms = varargin{1};
            [~,n] = size(chroms);
            for i = n:-1:1
                %ÿһ���ɵ����ϵ��½�
                for j = 1:1:i-1
                    if chroms{1,j+1}.fitness2 > chroms{1,j}.fitness2
                        temp = chroms{1,j};
                        chroms{1,j} = chroms{1,j+1};
                        chroms{1,j+1} = temp;
                    end
                end
            end
        case 0
            chroms = varargin{1};
            [~,n] = size(chroms);
            for i = n:-1:1
                %ÿһ���ɵ����ϵ�����
                for j = 1:1:i-1
                    if chroms{1,j+1}.fitness < chroms{1,j}.fitness
                        temp = chroms{1,j};
                        chroms{1,j} = chroms{1,j+1};
                        chroms{1,j+1} = temp;
                    end
                end
            end
            
        otherwise
            fprintf('��Ŀ��or��Ŀ�ꣿ������ϸ�ٿ���\n' );
            
            
    end
    
elseif  nargin==3
    chroms = varargin{1};
    [~,n] = size(chroms);
    chromBest = varargin{2};
    goal = varargin{3};
    chroms = sortByFitness(chroms,goal);
    chroms{1,n} = chromBest;
    chroms = sortByFitness(chroms,goal);
end
end
