% Implementing mean shift

% Define the input distributions
mu1 = [0 0];
mu2 = [5 5];
C1  = [2, 0; 0, 2];
C2  = [2, 1; 1, 2];

% Get the samples
n_samples = 3000;
samples = zeros(2, n_samples);
min_dist = 0.0000001;
max_iter = Inf;

for i=1:n_samples
    if(rand()<0.4)
        samples(:, i) = mvnrnd(mu1, C1);
    else
        samples(:, i) = mvnrnd(mu2, C2);
    end
end

% Display the scatter and hold the plot
figure;
axis square;
scatter(samples(1, :), samples(2, :));
hold;

% Do the mean shift
num = [0; 0];
denomTerm = 0;
newPoint = [0; 0];
dist = 0;
output = samples;
iter = 0;
iterations = zeros(1, n_samples);

for i=1:n_samples
    disp(i);
    dist = 10; % Initialize distance to some random value
    iter = 0;
    while dist>min_dist && iter<max_iter
         num = [sum(samples(1, :).*exp(-1*sum((output-[samples(1, i)*ones(1, n_samples); samples(2, i)*ones(1, n_samples)]).^2)/8)); ...
                sum(samples(2, :).*exp(-1*sum((output-[samples(1, i)*ones(1, n_samples); samples(2, i)*ones(1, n_samples)]).^2)/8))];
%        num = [sum(output(1, :).*exp(-1*sum((output-[output(1, i)*ones(1, n_samples); output(2, i)*ones(1, n_samples)]).^2)/8)); ...
%               sum(output(2, :).*exp(-1*sum((output-[output(1, i)*ones(1, n_samples); output(2, i)*ones(1, n_samples)]).^2)/8))];
        denomTerm = sum(exp(-1*sum((output-[samples(1, i)*ones(1, n_samples); samples(2, i)*ones(1, n_samples)]).^2)/8));
        denom = [denomTerm; denomTerm];
        newPoint = num ./ denom;
        dist = sqrt(sum((output(:, i)-newPoint).^2));
        output(:, i) = newPoint;
        iter = iter+1;
    end
    iterations(i) = iter;
end

% Plot the output
scatter(output(1, :), output(2, :));