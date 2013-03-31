clear all;
% use cell to simulate the cs in the ccn, each item in cs is a struct,which
% contains two elements, one is has(0 ... 1000, 0 means not exist, i=1...1000 means
% store content i), the other is timestamp(record the time when the content arrives)
a = struct('has',0,'timestamp',0) ;
cs = cell(10,10);
%define the ST to contain the content number and its ST time
%each ST item contain two elements, one is content number, the other is ST
%time
%ST = [];
ii = 1;%ST index number
%just for test
%pp = [];
for i=1:10
    for j=1:10
    cs{i,j} = a;
    end
end
interest = randraw('zipf',0.8,1000);
global ST1 ;
global ST2;
global ST3;
global ST4;
global ST5;
global ST6;
global ST7;
global ST8;
global ST9;
global ST10;
% step by five, 5 interests per second
for i = 1:5:1000
    for j = i:(i+4)
        send = interest(j);
        [exist,index] = is_exist(cs,send,1);
        if exist==1
             temp = cs{index,1}.timestamp;%store the timestamp when content "send" arrives
                for ll = index:-1:2
                    cs{ll,1}.has = cs{ll-1,1}.has;
                    cs{ll,1}.timestamp = cs{ll-1,1}.timestamp;
                end
                cs{1,1}.has = send;
                cs{1,1}.timestamp = temp;
        else 
           for kk = 10:-1:2
            if kk==10&&cs{kk,1}.has>0
                %get the ST and store it into the ST[]
                %contentNum is the content number
                %
                %another method to record the ST, but consume too much
                %storage
                %use find(ST(contentNum,:)) to find the indices that
                %elements is nonzero(>0)
                ST(cs{10,1}.has,ii) = (now-cs{10,1}.timestamp)*3600*24;
                ii = ii+1;
%                 ST(ii).contentNum = cs{10}.has;
%                 ST(ii).ST_time = (now-cs{10}.timestamp)*3600*24;%now return the day counts since year 0, convert it into seconds
%                 ii = ii + 1;
            end
            %update the cs only
            cs{kk,1}.has = cs{kk-1,1}.has;
            cs{kk,1}.timestamp = cs{kk-1,1}.timestamp;
          end
        cs{1,1}.has = send;
        cs{1,1}.timestamp = now;% now  
        end
      %  pause(0.2);%pause for 0.2s, means 5 interests per second
    end
%   pause(1);%pause for 1 second
end
