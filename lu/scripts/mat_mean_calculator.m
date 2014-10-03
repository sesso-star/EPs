file=argv(){1};

a=dlmread(file);

for i = 1 : size(a)(2)
    printf("%f ", mean(a(:,i)));
end
printf("\n");
