close all;
clear all;
clc;

user_start_pos = [70, 10]; %pozycja początkowa
v = 30; %prędkość
dt = 0.01;
t = 0:dt:5; % czas

PT = 10;
BS_pos = [120,30];
f = 3e+9;
dl_fali = 3e+8 /f;

BS_pos_odbite_1 = [-20,30];
BS_pos_odbite_2 = [120,170];

wsp_odbicia = 0.8;

wall1_pos = [50,10,50,300];
wall2_pos = [90,100,220,100];

line([50 50], [10 300]);
line([90 220], [100 100]);
current_user_pos = [70, 10];

PR_matrix = zeros(length(t));

for i=1:length(t)
    current_user_pos = [70, 10 + v*t(i)];
    r = norm(current_user_pos - BS_pos);
    r_odbite1 = norm (current_user_pos - BS_pos_odbite_1);
    r_odbite2 = norm (current_user_pos - BS_pos_odbite_2);
    H_bezp = 0;
    H_odbite1 = 0;
    H_odbite2 = 0;

    if (dwawektory(current_user_pos(1), current_user_pos(2), BS_pos(1), BS_pos(2), wall2_pos(1), wall2_pos(2), wall2_pos(3), wall2_pos(4)) < 0)
        H_bezp = (dl_fali/(4*pi*r)) * exp(-2*j*pi*r/dl_fali);
    end

    if (dwawektory(current_user_pos(1), current_user_pos(2), BS_pos_odbite_1(1), BS_pos_odbite_1(2), wall1_pos(1), wall1_pos(2), wall1_pos(3), wall1_pos(4)) > (-0.5) )
        H_odbite1 = wsp_odbicia * (dl_fali/(4*pi*r_odbite1)) * exp(-2*j*pi*r_odbite1/dl_fali);
    end
    
    if (dwawektory(current_user_pos(1), current_user_pos(2), BS_pos_odbite_2(1), BS_pos_odbite_2(2), wall2_pos(1), wall2_pos(2), wall2_pos(3), wall2_pos(4)) > (-0.5) )
        H_odbite2 = wsp_odbicia * (dl_fali/(4*pi*r_odbite2)) * exp(-2*j*pi*r_odbite2/dl_fali);
    end

    H = H_bezp + H_odbite1 + H_odbite2;
    %PR = PT * abs(H)^2;
    PR_matrix(i) = 10*log10(PT) + 20*log10(abs(H));
    
end

plot(t,PR_matrix);