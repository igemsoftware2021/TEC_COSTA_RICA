n = 9; %n is equal the number of recombinases
%There will be 2^n -1 nodes/leaves in the tree
sequence = 'Sequence: ';

for i = 1:2^n -1
    for j = 1:n
        if mod(i,2^j)==2^(j-1)
            s1 = 'Recombinase';
            s2 = int2str(j);
            s = strcat(s1,s2,'/');
            break
        end
    end
sequence = [sequence s];
end
sequence
