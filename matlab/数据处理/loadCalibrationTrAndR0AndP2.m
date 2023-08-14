function T = loadCalibrationTrAndR0AndP2(filename)
%�������ڽ��������ݾ���ת��Ϊ2Dƽ���ϵ�3��ת������֮��

% open file
fid = fopen(filename,'r');

if fid<0
  error(['ERROR: Could not load: ' filename]);
end

%�������ڽ��������ݾ���ת��Ϊ2Dƽ���ϵ�3��ת������
tr = readVariable(fid,'Tr_velo_to_cam',3,4);
r0 = readVariable(fid,'R0_rect',3,3);
P2 = readVariable(fid,'P2',3,4);
Tr = [tr;0 0 0 1];
R0=eye(4); %����4*4�ĵ�λ����
R0(1:3,1:3)=r0;

% close file
fclose(fid);

T=P2*R0*Tr;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function A = readVariable(fid,name,M,N)

% rewind
fseek(fid,0,'bof');

% search for variable identifier
success = 1;
while success>0
  [str,success] = fscanf(fid,'%s',1);
  if strcmp(str,[name ':'])
    break;
  end
end

% return if variable identifier not found
if ~success
  A = [];
  return;
end

% fill matrix
A = zeros(M,N);
for m=1:M
  for n=1:N
    [val,success] = fscanf(fid,'%f',1);
    if success
      A(m,n) = val;
    else
      A = [];
      return;
    end
  end
end
