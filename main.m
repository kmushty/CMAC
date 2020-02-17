%% Implementing CMAC %%


% Inputs

X = (linspace(0,10))';
Y = cos(X);

% Testing Data and training data 

testingData = [X(1:30),Y(1:30)];


trainingData = [X(31:100),Y(31:100)];

% Creating CMAC map with 35 weights

CMAC = create_2(X,35,10);
figure
plot(X,Y);

hold on
[map,itr,~,T] = train_2(CMAC,trainData,0);
acc = test_2(map,testData);

    I = randperm(100);
    testData = [X(I(1:30)),Y(I(1:30))];
    trainData = [X(I(31:100)),Y(I(31:100))];
    for i=1%:34
        CMAC = create(X,35,i);
        figure
        plot(X,Y);
        
        hold on
        [map,itr(1,i),~,T(1,i)] = train(CMAC,trainData,0,0);
        acc(1,i) = test(map,testData,0);
        hold off
        legend('Input Data','Testing Data');
        title(['Cell Number = ' num2str(i)]);
        figure
        plot(X,Y);
        
        hold on
        [map,itr(2,i),~,T(2,i)] = train(CMAC,trainData,0,1);
        acc(2,i) = test(map,testData,1);
        hold off
        legend('Input Data','Testing Data');
        title(['Cell Number = ' num2str(i)]);
    end
