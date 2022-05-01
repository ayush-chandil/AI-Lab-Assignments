% Number of steps
steps = 100;
R = zeros(steps, 2);% Matrix for storing rewards
i = 1;
total = zeros(steps);%total value after every step

for eps = [0.01, 0.3, 0.4]% eps is matrix for holding epsilon 
    R(:, :, i) = 0;
    step = 1;
    
    while step <= steps
        % exploration
        
        if rand < eps || step == 1
            action = randi(2);
            value = binaryBanditB(action);
            total(step,i) = value;
            if step > 1
                total(step,i) = total(step,i) + total(step - 1,i);
            end
            R(step, :, i) = [value, action];
            
        else
            % exploitation
            a1 = 0;
            a2 = 0;
            
            for s = 1:step
                
                if R(s, 1, i) == 1
                    if R(s, 2, i) == 1
                        a1 = a1 + 1;
                    else
                        a2 = a2 + 1;
                    end
                end
                
            end
            
            action = 1;
            if a2 > a1
                action = 2;
            end
            
            value = binaryBanditB(action);
            total(step,i) = value + total(step - 1,i);
            R(step, :, i) = [value, action];
        end
        
        step = step + 1;
    end
    
    i = i + 1;
end
plot(total(:,1))
hold on
plot(total(:,2))
plot(total(:,3))
hold off
ylim([0,50])
xlabel('Time Steps')
ylabel('Total Successes')
legend('e = 0.01','e = 0.3', 'e = 0.4','Location','northwest')
title('Binary Bandit B - (e = 0.01, 0.3, 0.4)')