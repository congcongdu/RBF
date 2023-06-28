clc
clear
load('all-zp.mat')
% data preparation
points1 = SR';
points2 = [SA,SB,ST,SVT]';
points1 = points1(:,2:4);
points2 = points2(:,2:4);


findBestPlane(points1, points2, 40000, 1000);
function best_plane = findBestPlane(points1, points2, iterations, perturbation)
    % points1, points2: matrices, each row is the coordinates of a point [x, y, z]
    % iterations: the number of iterations for the perturbation process
    % perturbation: the maximum absolute value of the random perturbation added to each parameter

    % Calculate the centroids of the two sets of points
    centroid1 = mean(points1);
    centroid2 = mean(points2);

    % Use the vector between the centroids as the initial normal to the plane
    normal = centroid2 - centroid1;
    normal = normal / norm(normal);  % Normalize to length 1

    % Use the midpoint of the centroids as a point on the plane
    point = (centroid1 + centroid2) / 2;

    % Calculate the initial plane equation: normal . (X - point) = 0 => normal . X - normal . point = 0
    plane = [normal, -dot(normal, point)];

    % Initialize the best plane and the best performance
    best_plane = plane;
    best_performance = inf;

    % For each iteration, add a small perturbation to the plane parameters and evaluate the performance
    for i = 1:iterations
        % Add a random perturbation to the plane parameters
        plane = plane + (rand(1, 4) -0.5) * 2 * perturbation;

        % Normalize the plane equation to ensure that A^2 + B^2 + C^2 = 1
        plane = plane / sqrt(plane(1)^2 + plane(2)^2 + plane(3)^2);

        % Evaluate the performance of the plane
        side1 = getPointSide(plane, points1);
        side2 = getPointSide(plane, points2);
        performance = sum(side1 ~= 1) + sum(side2 ~= -1);  % Count the number of misclassified points

        % If this plane is better, save it
        if performance < best_performance
            best_plane = plane;
            best_performance = performance;
        end
    end

    % Calculate the confusion matrix
    true_labels = [ones(size(points1, 1), 1); -ones(size(points2, 1), 1)];
    predicted_labels = [getPointSide(best_plane, points1); getPointSide(best_plane, points2)];
    confusion = confusionmat(true_labels, predicted_labels);

    % Return the best plane found
    fprintf('The best plane is: %.4f*x + %.4f*y + %.4f*z + %.4f = 0\n', best_plane(1), best_plane(2), best_plane(3), best_plane(4));
    fprintf('The best performance is: %d\n', best_performance);
    fprintf('The confusion matrix is:\n');
    disp(confusion);
end


