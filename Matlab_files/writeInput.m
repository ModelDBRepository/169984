% writeInput('/home/nobackup/genesis.DATA/INDATA/test-%d', myData)

function writeInput(file, inputData)

path = [pwd '/INPUTDATA/'];
[r,c] = size(inputData);
for i=1:c
    data = inputData(:,i);
    spikes = data(find(data < inf));
    filename = strcat(file,num2str(i),'.txt');
    fid = fopen([filename], 'w');
    fprintf(fid, '%f\n',spikes);
    fclose(fid);
end
