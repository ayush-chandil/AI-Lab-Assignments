steps = 10000;
R = zeros(steps, 2);
i = 1;
total = zeros(steps);
cntActions = zeros(10);
for eps = [0.01, 0.1, 0.2]
    total(:,i) = 0;
    R(:, :, i) = 0;
    step = 1;
    cntActions(:,i) = 0;
    
    while step <= steps
        
        % exploration
        if rand < eps || step == 1
            action = randi(10);
            value = bandit(action);
            total(step,i) = value;
            if step > 1
                total(step,i) = total(step,i) + total(step - 1,i);
            end
            R(step, :, i) = [value, action];
            
        % exploitation
        else
            actions = zeros(10, 2);
            
            for s = 1:(step-1)
                actions(R(s,2,i), 1) = actions(R(s,2,i),1)+R(s,1,i);
                actions(R(s,2,i), 2) = actions(R(s,2,i),2)+1;
            end
            
            action = 1;
            expReturn = 0;
            a = 1;
            for aa = actions
                temp = aa(1) / aa(2);
                if temp > expReturn
                    expReturn = temp;
                    action = a;
                end
                a = a + 1;
            end
            
            value = bandit(action);
            total(step,i) = value + total(step - 1,i);
            R(step, :, i) = [value, action];
            cntActions(:,i) = actions(:,2);
        end    
        
        step = step + 1;
    end
    
    i = i + 1;
end

% figure(1);
% plot(R(:,2,2));
% xlabel('Time Steps')
% ylabel('Actions')
% 
% figure(2);
% scatter(1:10,cntActions(:,2));
% xlabel('Actions')
% ylabel('# times taken')
% 
% figure(3);
% plot(total(:,2))
% xlabel('Time Steps')
% ylabel('Total Value Received')

avgReward = zeros(steps);
for i = 1:steps
    avgReward(i) = total(i,2) / i;
end

% figure(1);
% plot(avgReward(:,1));
% xlabel('Time Steps')
% ylabel('Average Reward')
% title('10 armed Bandit - (e = 0.1)')
% plot(total(:,1))
% hold on
plot(total(:,2))
plot(total(:,3))
hold off
xlabel('Time Steps')
ylabel('Total Successes')