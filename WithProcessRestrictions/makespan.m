function [Fit,Y1p,Y2p,Y3p]=makespan(T,Xstr,plotif,outi,outj)
% X �������
% T ʱ�����
% Xstr ���������ȼ�
% clear Xstr

[ number_of_mashine , number_of_job] = size(T);




N = length(Xstr);
mashine_busy = zeros(1,number_of_mashine);
job_busy = zeros(1,number_of_job);

Time_start = zeros(number_of_mashine,number_of_job);
Time_end = zeros(number_of_mashine,number_of_job);

mashine_next_end_time = zeros(1,number_of_mashine);
job_next_end_time = zeros(1,number_of_job);

job_count_in_mashine =zeros(1,number_of_mashine)+1; 
% job_count_in_mashine =zeros(1,4); 

for i = 1:N
    % current_job = Xstr(i); % ��ȡ��ǰ�Ĵ���Ĺ���ָ��
        
        current_job = Xstr{i}(1); % ��ǰ�Ĺ���
        current_mashine = Xstr{i}(2); % ��ǰ�Ļ���
        
        current_job_count_in_mashine = job_count_in_mashine( current_mashine ) ; % ��ȡ��ǰ�Ļ����Ĺ����Ĵ�����

        Time_start( current_mashine,current_job_count_in_mashine ) = max(mashine_next_end_time( current_mashine ), job_next_end_time( current_job )); % ��ȡ��ʼʱ��
        Time_end( current_mashine,current_job_count_in_mashine ) = Time_start( current_mashine,current_job_count_in_mashine )+ T( current_job,current_mashine ); % �������ʱ��
        
        mashine_next_end_time( current_mashine ) = Time_end( current_mashine,current_job_count_in_mashine ); % ��ֵ�µĽ���ʱ��
        job_next_end_time( current_job ) = Time_end( current_mashine,current_job_count_in_mashine );
        job_count_in_mashine( current_mashine ) = job_count_in_mashine( current_mashine )+ 1;
        % Time_start( current_mashine , current_job_count_in_mashine ) = 
        bianhao( current_mashine,  current_job_count_in_mashine) = current_job;
%         Time_start( Xstr() )

end






% %% ��ʼ��
% [m,n]=size(X);
% Y1p=zeros(m,n);
% Y2p=zeros(m,n);
% Y3p=zeros(m,n);
% Q1=zeros(m,n);
% Q2=zeros(m,n);
% Kt=zeros(m,n);
% J=zeros(1,m*n);
% K=zeros(1,n);

% %% �����ã��Ŵ��㷨ע�͵�����

% %for k=1:N %��ʼ��
% %a=repmat(1:m,1,n)
% %pos=a(randperm(length(a)))        %��¼�У�job��
% %farm{k}=pos;
% %Xstr=farm{k};
% %end
% %�Ŵ��㷨ע�͵�����

% Nu=zeros(1,m);
% Q1(Xstr(1),1)=0;  % ��ʼ���0��ʼ
% Q2(Xstr(1),1)=T( Xstr(1),1);  % ��һ���������������ڻ���Xstr(1)�ϵļӹ���ʼ�ͽ���ʱ��
% Nu(Xstr(1))=1;

% for i=2:m*n                       % ��¼�������˳����
%     Nu(   Xstr(i)) = Nu(Xstr(i))+1;      % ��¼�У�����
%     if Nu( Xstr(i) )==1
%         Kt=Nu;
%         j=i-1;                         %��¼��һ�����
%         while j ~= 0  &&  X(  Xstr( j )  ,   Kt(   Xstr( j )  )  ) ~= X(  Xstr(i) ,  1 )
%             Kt(Xstr(j))=Kt(Xstr(j))-1;
%             j=j-1;
%         end
        
%         % ����ǿ�ͷ��һ�У�ֱ�ӿ�ʼʱ����Ϊ0��������ǣ���ʼʱ����Ϊ���е���һ���Ľ�β
%         if j~=0  % j Ϊ����ĵ�ǰ������
%             Q1( Xstr(i), 1 ) = Q2(  Xstr(j),  Kt(Xstr(j))  ); % 
%             Q2( Xstr(i), 1 ) = Q1(  Xstr(i), 1)  +  T( Xstr(i) , 1 ); % 
%         else  %Ϊ��һ�й���
%             Q1(Xstr(i),1)=0;
%             Q2(Xstr(i),1)=Q1(Xstr(i),1)+T(Xstr(i),1); 
%         end
        
%     else
%         if Nu(Xstr(i))>=2
            
%             T1=Q2(Xstr(i),Nu(Xstr(i))-1);%�˹�����ǰһ�����ʱ��
            
%             Kt=Nu;
%             Kt(Xstr(i))=Kt(Xstr(i))-1;
%             j=i-1;
%             while j~=0 &&   X(   Xstr(j) , Kt(Xstr(j)))  ~=  X(Xstr(i),  Nu(Xstr(i))  )
%                 Kt(Xstr(j))=Kt(Xstr(j))-1;
%                 j=j-1;
%             end
%             if j~=0
%                 T2=Q2(Xstr(j),Kt(Xstr(j)));
%                 Tmax=[T1,T2];
%                 Q1(Xstr(i),Nu(Xstr(i)))=max(Tmax);
%                 Q2(Xstr(i),Nu(Xstr(i)))=Q1(Xstr(i),Nu(Xstr(i)))+T(Xstr(i),Nu(Xstr(i)));
%             else
%                 Q1(Xstr(i),Nu(Xstr(i)))=0;
%                 Q2(Xstr(i),Nu(Xstr(i)))=Q1(Xstr(i),Nu(Xstr(i)))+T(Xstr(i),1);
%             end
%         end
%     end
    
    Y1p=Time_start; % ��ʼ��ļ���
    Y2p=Time_end; % ������ļ���
    Y3p=bianhao; % ������ŵļ���
% end


Fit=max(Y2p(:,number_of_job));
if plotif == 1
    plotgantplot(T,Y1p,Y2p,Y3p,outi,outj,Fit);
end

hold off
% close(zzl)
end
function PlotRec(mPoint1,mPoint2,mText)

vPoint=zeros(4,2);
vPoint(1,:)=[mPoint1,mText-1];
vPoint(2,:)=[mPoint2,mText-1];
vPoint(3,:)=[mPoint1,mText];
vPoint(4,:)=[mPoint2,mText];
plot([vPoint(1,1),vPoint(2,1)],[vPoint(1,2),vPoint(2,2)]);
hold on
plot([vPoint(1,1),vPoint(3,1)],[vPoint(1,2),vPoint(3,2)]);
plot([vPoint(2,1),vPoint(4,1)],[vPoint(2,2),vPoint(4,2)]);
plot([vPoint(3,1),vPoint(4,1)],[vPoint(3,2),vPoint(4,2)]);

end

