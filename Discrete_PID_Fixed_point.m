clc;
clear;
close all;

TOTAL_BITS = 16;
FRAC_BITS = 12;
SCALE = 2^FRAC_BITS;

Kp = 2.0;
Ki = 0.5;
Kd = 0.1;
Ts = 0.01;

Kp_f = round(Kp * SCALE);
Ki_f = round(Ki * SCALE);
Kd_f = round(Kd * SCALE);
Ts_f = round(Ts * SCALE);

u_min = -1;
u_max = 1;

u_min_f = round(u_min * SCALE);
u_max_f = round(u_max * SCALE);

N = 700;

r = ones(1,N);
r_f = round(r * SCALE);

a = 0.9;
b = 0.1;

a_f = round(a * SCALE);
b_f = round(b * SCALE);

y_f = zeros(1,N+1,'int64');
e_f = zeros(1,N,'int64');

P_f = zeros(1,N,'int64');
I_f = zeros(1,N,'int64');
D_f = zeros(1,N,'int64');

u_f = zeros(1,N,'int64');

for k = 2:N

    e_f(k) = r_f(k) - y_f(k);

    P_f(k) = round((Kp_f * e_f(k)) / SCALE);

    KiTs_f = round((Ki_f * Ts_f) / SCALE);
    I_increment = round((KiTs_f * e_f(k)) / SCALE);
    I_f(k) = I_f(k-1) + I_increment;

    error_difference = e_f(k) - e_f(k-1);
    Kd_error = round((Kd_f * error_difference) / SCALE);
    D_f(k) = round((Kd_error * SCALE) / Ts_f);

    u_f(k) = P_f(k) + I_f(k) + D_f(k);

    if u_f(k) > u_max_f
        u_f(k) = u_max_f;
    elseif u_f(k) < u_min_f
        u_f(k) = u_min_f;
    end

    plant_y = round((a_f * y_f(k)) / SCALE);
    plant_u = round((b_f * u_f(k)) / SCALE);

    y_f(k+1) = plant_y + plant_u;

end

y_fixed = double(y_f) / SCALE;
e_fixed = double(e_f) / SCALE;
P_fixed = double(P_f) / SCALE;
I_fixed = double(I_f) / SCALE;
D_fixed = double(D_f) / SCALE;
u_fixed = double(u_f) / SCALE;

figure;

subplot(2,2,1);
plot(1:N,r,'LineWidth',1.5);
hold on;
plot(1:N,y_fixed(1:N),'LineWidth',1.5);
grid on;
xlabel('Sample');
ylabel('Amplitude');
title('Fixed-Point PID Response');
legend('Reference','Output');

subplot(2,2,2);
plot(1:N,e_fixed,'LineWidth',1.5);
grid on;
xlabel('Sample');
ylabel('Error');
title('Fixed-Point PID Error');

subplot(2,2,3);
plot(1:N,P_fixed,'LineWidth',1.5);
hold on;
plot(1:N,I_fixed,'LineWidth',1.5);
plot(1:N,D_fixed,'LineWidth',1.5);
grid on;
xlabel('Sample');
ylabel('PID Component');
title('Fixed-Point PID Components');
legend('P','I','D');

subplot(2,2,4);
plot(1:N,u_fixed,'LineWidth',1.5);
grid on;
xlabel('Sample');
ylabel('Control Output');
title('Fixed-Point PID Control Output');
ylim([u_min-0.1,u_max+0.1]);

fprintf('Total bits = %d\n',TOTAL_BITS);
fprintf('Fraction bits = %d\n',FRAC_BITS);
fprintf('Scale = %d\n',SCALE);

fprintf('Kp fixed = %d\n',Kp_f);
fprintf('Ki fixed = %d\n',Ki_f);
fprintf('Kd fixed = %d\n',Kd_f);
fprintf('Ts fixed = %d\n',Ts_f);

fprintf('Final output = %.6f\n',y_fixed(N));
fprintf('Final error = %.6f\n',e_fixed(N));
fprintf('Maximum output = %.6f\n',max(y_fixed));
fprintf('Minimum output = %.6f\n',min(y_fixed));
fprintf('Maximum control output = %.6f\n',max(u_fixed));
fprintf('Minimum control output = %.6f\n',min(u_fixed));