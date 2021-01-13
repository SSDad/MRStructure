clearvars

n = 1; ST(n).name = 'Duodenum';
n = n+1; ST(n).name = 'Liver';
n = n+1; ST(n).name = 'Stomach';
n = n+1; ST(n).name{1} = 'Large';  ST(n).name{2} = 'Bowel';
n = n+1; ST(n).name{1} = 'Small';  ST(n).name{2} = 'Bowel';
n = n+1; ST(n).name{1} = 'Spinal';  ST(n).name{2} = 'Cord';
n = n+1; ST(n).name{1} = 'Kidney';  ST(n).name{2} = 'R';
n = n+1; ST(n).name{1} = 'Kidney';  ST(n).name{2} = 'L';

save('STList', 'ST')