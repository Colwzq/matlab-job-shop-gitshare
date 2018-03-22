function [Zp,Y1p,Y2p,Y3p,Xp,LC1,LC2 ] =GAM( M,num_gen,T,plotif)
% ������ʹ��GA�������JOBshop���⣬
% ���������
% M: ��������
% num_gen: ������Ⱥ�������ӣ������Ļ������Ⱥ����2*num_gen+1
% T ʱ����󣬼�¼���ĵ�ʱ��
% plotif: ��ͼ��־λ�����Ϊ1����������ɺ���л�ͼ

% ���������Ⱥ��
N = 2*num_gen+1;

%% �Ŵ��㷨��ʼ��
[m,n]=size(T);                                  % ����T��������������Ҳ�ǹ������ͻ�����
Xp={};                                          % ����Ⱦɫ���еĻ���
CHA=zeros(1,m*n);                               % A�Ӵ�Ⱦɫ��
CHB=zeros(1,m*n);                               % B�Ӵ�Ⱦɫ��
LC1=zeros(1,M);
LC2=zeros(1,M);
farm=cell(N,1);                                 % ����Ⱥ���е����ӵļ���
Parent={};                                      % ��Ÿ���
BestValue=10000;                                % �������ֵ,��ʼ���ǳ������
BestMakespan=0;
TotalFitness=0;                                 % �������Ӧֵ
Toltal=0;                                       % ����ۼ���Ӧֵ
FIT1=zeros(N,1);                                % ÿ���������Ӧ��
FIT2=zeros(N,1);                                % ÿ�������ѡ�����
FitValue=zeros(N,1);                            % ÿ�������ѡ�����
SelectedGenome=cell(1,1);
BestGenome=cell(1,1);
mparent={};
Chp=zeros(1,1);
m1=cell(N,1);

%% ����Դ���ȷ���
sour = {};
count = 1;
for i = 1 : m
    for j = 1:n
        sour{count} = [i,j];
        count= count + 1;
    end
end

%% ��ԭ���ȷ��������γ�������ȷ���
for k=1:N %��ʼ�����ӵĳ�ʼλ��
    randlist = randperm(length(sour));
    for j  = 1:m*n
        farm{k,j}=sour{ randlist( j ) };
    end
end

%% ����Ⱥ����
for counter=1:M % ����M��
    
    for d=1:N                                   % ����ÿ���������Ӧֵ
        for farmi = 1:n*m
            Xstr{farmi}=farm{d,farmi};          % �����е����ӵļ�����ѡ��һ��
        end
        [Fit, Y1p, Y2p, Y3p]=Fitness(T,Xstr);   % Makspan������makspan
        FitValue(d)=1/Fit;                      % ������Ӧ�ȼ�������ѡ��ĸ���
        FIT1(d)=Fit;
    end
    
    BestMakespan=min(FIT1);                     % ����ѡ����õ����ӵ�λ��
    pos1=find(FIT1==BestMakespan);              % �ҵ�����λ�õ����ӵ����
    
    for farmi = 1:n*m
        Xp{farmi}=farm{pos1(1),farmi};          % �����е����ӵļ�����ѡ��һ��
    end
    
    % ��������Ⱦɫ��
    TotalFitness=sum(FitValue);                 % ��������Ӧֵ-�������̶ĵķ�ĸ
    
    for i=1:N                                   % ����ÿ������ѡ����ʣ��������̶ĵķ���
        FIT2(i)=FitValue(i)/TotalFitness;
    end
    BestValue=min(FIT2);                        % �������ֵ��Ӧֵ
    
    % ���̶�ѡ��ѡ��N��Ⱦɫ��
    for s=1:num_gen
        WheelSelectionNumber=rand(1);           % �������һ��������Ϊ���̶ĵ�ָ��
        WheelSelectionNumber=WheelSelectionNumber*TotalFitness;
        
        for i=1:N
            Toltal=Toltal+FitValue(i);
            if Toltal>WheelSelectionNumber
                for farmi = 1:n*m
                    SelectedGenome{farmi}=farm{i,farmi}; % �����е����ӵļ�����ѡ��һ��
                end
                break
            end
        end
        
        for farmi = 1:n*m
            Parent{s,farmi}=SelectedGenome{farmi};
        end
        %���̶�ѡ�����
    end
    
    %% ���ڽ�������
    m1={};
    for i=1:num_gen
        for farmi = 1:n*m
            mparent{farmi}=Parent{i,farmi};
        end
        mp11=randi([1,m*n]); % ѡ��һ��Ҫ����Ļ�������
        mp12=randi([1,m*n]); % ��ѡ��һ��Ҫ����Ļ�������
        a = min( mp11 ,mp12);
        b = max( mp11 ,mp12);
        if a == b
            if a ~= n*m
                b = a+1;
            else
                a = b-1;
            end
        end
        c=randi([1,m*n]); % ѡ��һ��Ҫ����Ļ�������
        for jiaohuani = a : b
            mid{jiaohuani-a+1} = mparent{ jiaohuani };
        end
        for jiaohuani = a : b
            fromi = jiaohuani +c ;
            if fromi > n*m
                fromi = fromi - n*m;
            end
            [fromi-a+1];
            mparent{jiaohuani} = mid{ jiaohuani -a +1 };
        end
        for jiaohuani = a : b
            fromi = jiaohuani +c ;
            if fromi > n*m
                fromi = fromi - n*m;
            end
            mparent{jiaohuani} = mid{ jiaohuani-a+1 };
        end
        for farmi = 1:n*m
            m1{i, farmi}=mparent{farmi};
        end
    end
    %% ����������
    m2={};
    for i=1:num_gen
        for farmi = 1:n*m
            mparent{farmi}=Parent{i,farmi};
        end
        mp1=randi([1,m*n]); % ѡ��һ��Ҫ����Ļ�������
        mp2=randi([1,m*n]); % ��ѡ��һ��Ҫ����Ļ�������
        
        Chp=mparent{mp1}; % ���б���
        mparent{mp1}=mparent{mp2};
        mparent{mp2}=Chp;
        
        for farmi = 1:n*m
            m2{i, farmi}=mparent{farmi};
        end
        
    end
    for loop = 1:num_gen
        for farmi = 1:n*m
            farm{loop,farmi}=m1{ loop,farmi };               % �����е����ӵļ�����ѡ��һ��
        end
    end
    for loop = 1:num_gen
        for farmi = 1:n*m
            farm{loop+num_gen,farmi}=m2{ loop,farmi };               % �����е����ӵļ�����ѡ��һ��
        end
    end
    farm=[ m1;m2;Xp ];
    %�������
    
    LC1(counter)=BestValue;
    LC2(counter)=BestMakespan;
end
disp('BestMakespan=')
disp(BestMakespan);

if plotif == 1
    figure(1);
    plot(LC1);
    figure(2);
    plot(LC2);

    Xstr=Xp;
    plotif=1;
    [Zp,Y1p,Y2p,Y3p]=makespan(T,Xstr,plotif);
end

end


