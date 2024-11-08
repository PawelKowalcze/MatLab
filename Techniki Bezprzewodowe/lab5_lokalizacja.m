clc;

robot_count = 100;
% robot_xy = randi([0 75], 2, robot_count),
robot_xy = rand(robot_count, 2).*[75 75];

bs_1_xy = [0 0];    % 3----4
bs_2_xy = [75 0];   % |    |
bs_3_xy = [0 75];   % |    |
bs_4_xy = [75 75];  % 1----2

bs_1_angle = zeros(robot_count, 1);
bs_2_angle = zeros(robot_count, 1);
bs_3_angle = zeros(robot_count, 1);
bs_4_angle = zeros(robot_count, 1);

bs_1_angle_err = zeros(robot_count, 1);
bs_2_angle_err = zeros(robot_count, 1);
bs_3_angle_err = zeros(robot_count, 1);
bs_4_angle_err = zeros(robot_count, 1);

r_container = zeros(robot_count, 2);

% tan $\alpha$ = $\deltax/\deltay$
for i = 1 : robot_count
  bs_1_angle = atand((0 - robot_xy(i, 1))/(0 - robot_xy(i, 2)));
  bs_2_angle = atand((75 - robot_xy(i, 1))/(0 - robot_xy(i, 2)));
  bs_3_angle = atand((0 - robot_xy(i, 1))/(75 - robot_xy(i, 2)));
  bs_4_angle = atand((75 - robot_xy(i, 1))/(75 - robot_xy(i, 2)));

  bs_1_angle_err = bs_1_angle + (rand()*8 - 4);
  bs_2_angle_err = bs_2_angle + (rand()*8 - 4);
  bs_3_angle_err = bs_3_angle + (rand()*8 - 4);
  bs_4_angle_err = bs_4_angle + (rand()*8 - 4);

  A = zeros(4, 2);
  A(1, :) = [1, -tand(bs_1_angle_err)];
  A(2, :) = [1, -tand(bs_2_angle_err)];
  A(3, :) = [1, -tand(bs_3_angle_err)]; 
  A(4, :) = [1, -tand(bs_4_angle_err)]; 

  B = zeros(4, 1);
  B(1, :) = [bs_1_xy(1) - bs_1_xy(2)*tand(bs_1_angle_err)];
  B(2, :) = [bs_2_xy(1) - bs_2_xy(2)*tand(bs_2_angle_err)];
  B(3, :) = [bs_3_xy(1) - bs_3_xy(2)*tand(bs_3_angle_err)];
  B(4, :) = [bs_4_xy(1) - bs_4_xy(2)*tand(bs_4_angle_err)];
  
  r = zeros(2, 1);
  r = inv(transpose(A) * A) * transpose(A) * B;
  r_container(i, :) = r;
end

robot_xy_delta = robot_xy - r_container;
robot_xy_err = sqrt(sum(robot_xy_delta.^2, 2));
robot_xy_err_mean = mean(robot_xy_err),

figure;
plot(robot_xy(:, 1), robot_xy(:, 2), 'bo'); hold on;
plot(r_container(:, 1), r_container(:, 2), 'r+'); hold off;
