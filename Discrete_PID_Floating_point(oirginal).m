clc
clear

Kp = 2.0;
Ki = 0.5;
Kd = 0.1;
Ts = 0.01;

u_min = -1;
u_max = +1;

N = 500;

r = ones(1,N);

y = zeros(1,N+1);
e = zeros(1,N);
P = zeros(1,N);
I = zeros(1,N);
D = zeros(1,N);
u = zeros(1,N);

for k=2:N
    e(k) = r(k) - y(k);
    P(k) = Kp * e(k);
    I(k) = I(k-1) + Ki * Ts * e(k);
    D(k) = Kd * (e(k) - e(k-1)) / Ts;
    u(k) = P(k) + I(k) + D(k);
    u(k) = min(max(u(k), u_min), u_max);
    y(k+1) = 0.9*y(k) + 0.1*u(k);
end

figure;

plot(1:N, r, 'LineWidth', 1.5);
hold on;
plot(1:N, y(1:N), 'LineWidth', 1.5);

grid on;
xlabel('Sample');
ylabel('Amplitude');
title('Floating-Point PID Response');
legend('Reference', 'Output');

figure;

plot(1:N, e, 'LineWidth', 1.5);

grid on;
xlabel('Sample');
ylabel('Error');
title('PID Error');

figure;

plot(1:N, P, 'LineWidth', 1.5);
hold on;
plot(1:N, I, 'LineWidth', 1.5);
plot(1:N, D, 'LineWidth', 1.5);

grid on;
xlabel('Sample');
ylabel('PID Component');
title('PID Components');
legend('P', 'I', 'D');

figure;

plot(1:N, u, 'LineWidth', 1.5);

grid on;
xlabel('Sample');
ylabel('Control Output');
title('PID Control Output');
ylim([u_min-0.1, u_max+0.1]);

fprintf('Final output = %.6f\n', y(N));
fprintf('Final error  = %.6f\n', e(N));
fprintf('Maximum output = %.6f\n', max(y));
fprintf('Minimum output = %.6f\n', min(y));
fprintf('Maximum control output = %.6f\n', max(u));
fprintf('Minimum control output = %.6f\n', min(u));
