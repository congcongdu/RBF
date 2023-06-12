% load file 
%cluster1 = n*3
%cluster2 = n*3

% Calculate the centroid of two cluster points
centroid1 = mean(cluster1);
centroid2 = mean(cluster2);
% Calculate normal vectors
normal_vector = centroid2 - centroid1;

% Calculate the equation for the split plane: Ax + By + Cz + D = 0
    A = normal_vector(1);
    B = normal_vector(2);
    C = normal_vector(3);
    D = -(A*centroid1(1) + B*centroid1(2) + C*centroid1(3));
while true
    % Check that the two cluster points are on either side of the plane
    if checkSameSide([A, B, C, D], cluster1) && checkSameSide([A, B, C, D], cluster2)
        break;
    end
    
    % Adjust the normal vector slightly
    D = D + randn(1) * 0.00001;
end

figure(2)
scatter3(cluster1(:, 1), cluster1(:, 2), cluster1(:, 3), 'r', 'filled');
hold on;
scatter3(cluster2(:, 1), cluster2(:, 2), cluster2(:, 3), 'b', 'filled');

[x, y] = meshgrid(linspace(-0.05, 0.05, 10), linspace(-0.05, 0.05, 10));

z = (-D - A*x - B*y) / C;

surf(x, y, z, 'FaceAlpha', 0.5, 'EdgeColor', 'none');

xlabel('V1');
ylabel('V2');
zlabel('V3');
xlim([-0.015,0.005]);ylim([-0.02,0.015]);zlim([-0.015,0.01])

hold off;
grid on;





