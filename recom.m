clear; clc;

fprintf("Loading Manipal recommender set....\n\n");

places = ["Endpoint", "Beach-Malpe-Kapu-Hude", "The Hanging Bridge", "Karkala", "Forest Areas-Agumbe-Kudremukh", "Chill Space", "Dee-Tee", "Trigger", "Escape Room", "Anatomy Museum"];

[Y, TXT, RAW] = xlsread("Data.xlsx");
[X, aa, bb] = xlsread("XData.xlsx");
y = Y';
Y = y(1:10,:);
R = Y > 0;
fprintf('\nProgram paused. Press enter to continue.\n');
pause;

% Useful Values
[num_places, num_users] = size(Y);
num_features = 5;

% Set Initial Parameters (Theta, X)
%X = randn(num_places, num_features);
%Theta = randn(num_users, num_features);
%load("Theta_vec")
Theta = y(11:15,:)';

initial_parameters = [X(:); Theta(:)];

% options for fmincg
options = optimset('GradObj', 'on', 'MaxIter', 100);

% Set Regularization
lambda = 1;
theta = fmincg (@(t)(cofiCostFunc(t, Y, R, num_users, num_places, ...
                                num_features, lambda)), ...
                initial_parameters, options);
% Unfold the returned theta back into U and W
X = reshape(theta(1:num_places*num_features), num_places, num_features);
Theta = reshape(theta(num_places*num_features+1:end), ...
                num_users, num_features);

fprintf('Recommender system learning completed.\n');

fprintf('\nProgram paused. Press enter to continue.\n');
pause;

fprintf("\nRate em' out of 5\n")
Theta(1,1) = input("Gaming: ");
Theta(1,2) = input("Party: ");
Theta(1,3) = input("Scenery: ");
Theta(1,4) = input("Arts: ");
Theta(1,5) = input("Adventure: ");

p = X * Theta';
my_predictions = p(:,1) + Y;

[r, ix] = sort(my_predictions, 'descend');
fprintf('\nTop recommendations for you:\n');
for i=1:10
    j = ix(i);
    fprintf('Predicting rating %.1f for place %s\n', my_predictions(j), ...
            places(j));
end

