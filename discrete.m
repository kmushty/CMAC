function [ map ] = create(X, weightNum, cellNum)

if (cellNum > weightNum) || (cellNum < 1) || (isempty(X))
    map = [];
    return
end

% Input vector
x = linspace(min(X),max(X),weightNum-cellNum+1)';

% Look up table
lookUp = zeros(length(x),weightNum);
for i=1:length(x)
    lookUp(i,i:cellNum+i-1) = 1;
end

% Weights
Weights = ones(weightNum,1);

% Create map
map = cell(3,1);
map{1} = x;
map{2} = lookUp;
map{3} = Weights;
map{4} = cellNum;

end

%%%Testing part%%%

% Location of Input given the Input vectors
input  = zeros(length(testData),2);
for i=1:length(testData)
    if testData(i,1) > map{1}(end)
        input(i,1) = length(map{1});
    elseif testData(i,1) < map{1}(1)
        input(i,1) = 1;
    else
        temp = (length(map{1})-1)*(testData(i,1)-map{1}(1))/(map{1}(end)-map{1}(1)) + 1;
        input(i,1) = floor(temp);
        if (ceil(temp) ~= floor(temp)) && state
            input(i,2) = ceil(temp);
        end
    end
end

% compute accuracy
num = 0;
den = 0;
for i=1:length(input)
    if input(i,2) == 0
        output = sum(map{3}(find(map{2}(input(i,1),:))));
        num = num + abs(testData(i,2)-output);
        den = den + testData(i,2) + output;
    else
        d1 = norm(map{1}(input(i,1))-testData(i,1));
        d2 = norm(map{2}(input(i,2))-testData(i,1));
        output = (d2/(d1+d2))*sum(map{3}(find(map{2}(input(i,1),:))))...
               + (d1/(d1+d2))*sum(map{3}(find(map{2}(input(i,2),:))));
        num = num + abs(testData(i,2)-output);
        den = den + testData(i,2) + output;
    end
    Y(i) = output;
end
err = abs(num/den);
accuracy = 100 - err;

[X,I] = sort(testData(:,1));
Y = Y(I);
plot(X,Y);

end

%%%Training part%%%

tic;

map = mainMap;
if isempty(map) || isempty(trainData) || isempty(E)
    return
end

% Learning rate
eta = 0.025;
err = 0;
iteration = 0;
count = 0;
while (err > E)&&(count*2 <= iteration)
    old_err = err;
    iteration = iteration + 1;
    
    % Output for each input and correspondingly adjusting weights
    for i=1:length(input)
        if input(i,2) == 0
            output = sum(map{3}(find(map{2}(input(i,1),:))));
            err = eta*(trainData(i,2)-output)/map{4};
            map{3}(find(map{2}(input(i,1),:))) = map{3}(find(map{2}(input(i,1),:))) + err;
        else
            d1 = norm(map{1}(input(i,1))-trainData(i,1));
            d2 = norm(map{1}(input(i,2))-trainData(i,1));
            output = (d2/(d1+d2))*sum(map{3}(find(map{2}(input(i,1),:))))...
                    + (d1/(d1+d2))*sum(map{3}(find(map{2}(input(i,2),:))));
            err = eta*(trainData(i,2)-output)/map{4};
            map{3}(find(map{2}(input(i,1),:))) = map{3}(find(map{2}(input(i,1),:)))...
                                                    + (d2/(d1+d2))*err;
            map{3}(find(map{2}(input(i,2),:))) = map{3}(find(map{2}(input(i,2),:)))...
                                                    + (d1/(d1+d2))*err;            
        end
    end

    % Final error
    num = 0;
    den = 0;
    for i=1:length(input)
        if input(i,2) == 0
            output = sum(map{3}(find(map{2}(input(i,1),:))));
            num = num + abs(trainData(i,2)-output);
            den = den + trainData(i,2) + output;
        else
            d1 = norm(map{1}(input(i,1))-trainData(i,1));
            d2 = norm(map{1}(input(i,2))-trainData(i,1));
            output = (d2/(d1+d2))*sum(map{3}(find(map{2}(input(i,1),:))))...
                   + (d1/(d1+d2))*sum(map{3}(find(map{2}(input(i,2),:))));
            num = num + abs(trainData(i,2)-output);
            den = den + trainData(i,2) + output;
        end
    end
    err = abs(num/den);
    if abs(old_err - err) < 0.0001
        check = check + 1;
    else
        count = 0;
    end
end
iteration = iteration - check;

final
[X,I] = sort(trainData(:,1));
Y = Y(I);

t = toc;

end
