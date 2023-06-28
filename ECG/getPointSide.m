function side = getPointSide(plane, points)
    % plane: Coefficients of the plane equation [A, B, C, D]
    % points: a matrix, each row is the coordinates of a point [x, y, z]

    % Calculate the distance from the point to the plane
    distances = (plane(1) * points(:, 1) + plane(2) * points(:, 2) + plane(3) * points(:, 3) + plane(4)) ./ sqrt(plane(1)^2 + plane(2)^2 + plane(3)^2);

    % Get the side of each point relative to the plane
    side = sign(distances);
end
