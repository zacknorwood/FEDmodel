%
% This script assumes these variables are defined:
%   pathen - the path (optional) and name of the generated ANN function
%   Inputs - input data.
%   Targets - target data.
clear hist_best_tr hist_best_per
ANN_name = 'kb_friskis_final';
x = Inputs;
t = Targets;

% Choose a Training Function
% For a list of all training functions type: help nntrain
% 'trainlm' is usually fastest.
% 'trainbr' takes longer but may be better for challenging problems.
% 'trainscg' uses less memory. Suitable in low memory situations.
trainFcn = 'trainlm';  % Levenberg-Marquardt backpropagation.

% The number of neurons in the hidden layer, itterate of several different
% to find optimal one. However, do not go to high as it may lead to
% overfitting 
nr_N = [5 10 20 30 40 60 80 100 140];% 180];

% Nummer of repetions for each number of neurons. The performance of the
% network depends on the inital conditions, i.e., several starting
% positions should be investigated.
reps = 10;

best_per = 100000;

%Setup an inital devision of data (could be done with rand as well)
% This should prefarably only be done ones befor you start training your
% algorithm, otherwise there is a risk for overfitting. 
% 
% run('dataDevision.m')
% 
% % 
for i = 1:length(nr_N)


    for j = 1:reps
        
        % Create a Fitting Network (regression, mapping inputs to outputs)
        hiddenLayerSize = nr_N(i);
        net = fitnet(hiddenLayerSize,trainFcn);
        
        %Set the number of validation fails befor training terminates (can
        %also be itterated over)
        net.trainParam.max_fail = 10;
        
        %Set if training window should be displayed
        net.trainParam.showWindow = false;
        % Setup Division of Data for Training, Validation, Testing
        net.divideFcn = 'divideind';
        net.divideParam.trainInd = tr_start.trainInd;
        net.divideParam.valInd = tr_start.valInd;
        net.divideParam.testInd = tr_start.testInd;
        % Train the Network, net is the trained network, 
        [net,tr] = train(net,x,t);

        % Test the Network. Preferably only the training and validation set
        % should be used here, the test set should be excluded and used to
        % report MSE.
        y = net(x);
        e = gsubtract(t,y);
%         performance = perform(net,t,y);
        
        % Here the only the data points for the validation and training
        % datasets are used for evaluating the model.
%         trainInd = tr.trainInd;
%         valInd = tr.valInd;
%         tstOutputs = net(x(:, sort([trainInd valInd])));
%         performance = perform(net, t(sort([trainInd valInd])), tstOutputs);
        
        % Here the only the data points for the validation
        % dataset are used for evaluating the model.
        valInd = tr.valInd;
        tstOutputs = net(x(:,  valInd));
        performance = perform(net, t(valInd), tstOutputs);
        
        
        % Evaluates if the current network performs better than previous
        % networks
        if performance < best_per
            
            hist_best_tr(i) = tr;
            
            hist_best_per(i) = performance;
            
            best_per = performance;

            best_net = net;

            best_net_tr = tr;

            bets_nr_N = hiddenLayerSize;

        end
    end
end
  %  View the Network
view(best_net);

% Generates an ANN function
genFunction(best_net,ANN_name,'MatrixOnly','yes');
save([ANN_name '_stat.mat'],'best_net_tr','bets_nr_N')
    % Plots
    % Uncomment these lines to enable various plots.
    %figure, plotperform(tr)
    %figure, plottrainstate(tr)
    %figure, ploterrhist(e)
    %figure, plotregression(t,y)
    %figure, plotfit(net,x,t)

