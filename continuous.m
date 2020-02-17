function [ map ] = create(X, weightNum, cellNum)

if (cellNum > weightNum) || (cellNum < 1) || (isempty(X))
    map = [];
    return
end

% Input vector
x = linspace(min(X),max(X),weightNum-cellNum+1)';

% Look up table
lookUp = zeros(length(x),2*weightNum);
for i=1:length(x)
    lookUp(i,i:cellNum+i-1) = 1;
    lookUp(i,i+weightNum:cellNum+i+weightNum-1) = 1;

end

% Weights
Weights = ones(2*weightNum,1);

% Create map
map = cell(3,1);
map{1} = x;
map{2} = lookUp;
map{3} = Weights;
map{4} = cellNum;

end


%%% Testing Part %%%

% Location of Input given the Input vectors
input  = zeros(length(testData),1);
for i=1:length(testingData)
    if testData(i,1) > map{1}(end)
        input(i) = length(map{1});
    elseif testData(i,1) < map{1}(1)
        input(i) = 1;
    else
        temp = (length(map{1})-1)*(testData(i,1)-map{1}(1))/(map{1}(end)-map{1}(1)) + 1;
        input(i) = floor(temp);
    end
end

% Calculate Accuracy
numerator = 0;
denomenator = 0;
for i=1:length(input)
    Y(i) = sum(map{3}(find(map{2}(input(i),:),map{4})));
    num = num + abs(testData(i,2)-Y(i));
    den = den + testData(i,2) + Y(i);
end
err = abs(numerator/denomenator);
accuracy = 100 - err;

[X,I] = sort(testData(:,1));
Y = Y(I);
plot(X,Y);

end

%%% Training Part %%%

tic;

map = mainMap;
if isempty(map) || isempty(trainingData) || isempty(E)
    return
end

% Learning rate
eta = 0.025; 
err = 0;
iteration = 0;
count = 0;
y = zeros(size(map{2},1),1);
while (err > E)&&(2*count <= iteration)
    old_err = error;
    iteration = iteration + 1;
    
    % Output for each input and correspondingly adjusting weights
    for i=1:length(input)
        index = find(map{2}(input(i),:));
        output = sum(map{3}(index(1:map{4}))) + (1/(1+exp(-y(input(i)))))*sum(map{3}(index(map{4}+1:end)));
        err = eta*(trainingData(i,2)-output)/(2*map{4});
        map{3}(index) = map{3}(index) + err;
    end

end
iteration = iteration - count;

% Final error
numerator = 0;
denomenator = 0;
for i=1:length(input)
    Y(i) = sum(map{3}(find(map{2}(input(i,1),:))));
    numerator = numerator + abs(trainingData(i,2)-Y(i));
    denomenator = denomenator + trainingData(i,2) + Y(i);
end
finalError = abs(numerator/denomenator);
[X,I] = sort(trainingData(:,1));
Y = Y(I);
plot(X,Y);

t = toc;

end
