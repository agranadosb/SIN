#!/usr/bin/octave -qf
if (nargin != 3)
        printf("Usage: ./experiment.m <data> <alphas> <bes>\n");
        exit(1);
end

arg_list = argv();
data = arg_list{1};
as = str2num(arg_list{2});
bs = str2num(arg_list{3});

load(data);

# Numbers of rows and cols of the data (N, L)
[N, L] = size(data);

# Number of data without the class
D = L - 1;

# We will use only the 70% of the data for the training
NTr = round(.7 * N);

# Clases of the data without repeating and their number
ll = unique(data(:, L));
C = numel(ll);

# Get random number
rand("seed", 23);

# Change the positionof the rows
data = data(randperm(N), :);

fid = fopen("res.w", 'w+');
fprintf(fid, "#      a       b     E     k Ete Ete (-)    Ite (-)\n");
fprintf(fid, "#------- ------- ----- ----- --- ------- ----------\n");

printf("#      a       b     E     k Ete Ete (-)    Ite (-)\n");
printf("#------- ------- ----- ----- --- ------- ----------\n");
for a = as
    for b = bs
        # -> Calculate Perceptron for a and b
        [w, E, k] = perceptron(data(1:NTr, :), b, a);

        # Get the 30% percent of the data (we training the perceptron with the 70% of the data)
        M = N - round(.7 * N);
        te = data(N - M + 1:N, :);

        # Get the result of apply g to the 30% of the data
        rl = zeros(M, 1);

        for n = 1:M
            rl(n) = ll(linmach(w, [1 te(n, 1:D)]'));
        end

        [nerr m] = confus(te(:,L),rl);

        # Probibilidad empírica de error
        p = nerr / M;

        # Para calcular el intervalo de confianza
        s = sqrt(p * (1 - p) / M);
        r = 1.96 * s;

        # Margen superior e inferior del intervalo de confianza
        ma = p + r;
        mi = p - r;

        if (ma < 0)
                ma = 0;
        end
        if (mi < 0)
                mi = 0;
        end
        printf("%8.1f %7.1f %3d %5d %5d %7.1f [%.1f, %.1f]\n", a, b, E, k, nerr, p * 100, mi * 100, ma * 100);
        fprintf(fid, "%8.1f %7.1f %5d %5d %3d %7.1f [%.1f, %.1f]\n", a, b, E, k, nerr, p * 100, mi * 100, ma * 100);
    end
end
