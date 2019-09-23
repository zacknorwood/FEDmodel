%
% Copyright (c) 2015, Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "license.txt" for license terms.
%
% Project Code: YPML120
% Project Title: Time-Series Prediction using GMDH
% Publisher: Yarpiz (www.yarpiz.com)
% 
% Developer: S. Mostapha Kalami Heris (Member of Yarpiz Team)
% 
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
%

clc;

tic
%% Load Data

w=Edit(1:15288);
y=temp(1:15288);
z=z(1:15288);

Delays1 = [10:100];
Delays2=[10:100];
Delays3=[10:100];
Delays4=[10:100];
[Inputs1, Targets1] = CreateTimeSeriesData(x(1:15288),Delays1);  %demand
[Inputs2, Targets2] = CreateTimeSeriesData(y,Delays2);   %temperature
[Inputs3, Targets3] = CreateTimeSeriesData(z,Delays3);   %temperature
[Inputs4, Targets4] = CreateTimeSeriesData(w,Delays4);   %temperature
[Inputs5, Targets5] = CreateTimeSeriesData(p,Delays4);   %temperature

Inputs=vertcat(Inputs1,Inputs2,Inputs3,Inputs5);
Targets=Targets4;
clear Targets1;clear Delays1;clear Delays2; clear y;clear Targets3;clear Inputs3;
;clear Inputs1;
%{
nData = size(Inputs,2);
% Perm = randperm(nData);
Perm = 1:nData;

% Train Data
pTrain = 0.8;
nTrainData = round(pTrain*nData)
TrainInd = Perm(1:nTrainData);
TrainInputs = Inputs(:,TrainInd);
TrainTargets = Targets(:,TrainInd);

% Test Data
pTest = 1 - pTrain;
nTestData = nData - nTrainData;
TestInd = Perm(nTrainData+1:end);
TestInputs = Inputs(:,TestInd);
TestTargets = Targets(:,TestInd);

%% Create and Train GMDH Network

params.MaxLayerNeurons = 25;   % Maximum Number of Neurons in a Layer
params.MaxLayers = 10;          % Maximum Number of Layers
params.alpha = 0;              % Selection Pressure
params.pTrain = 0.7;           % Train Ratio
gmdh = GMDH(params, TrainInputs, TrainTargets);

%% Evaluate GMDH Network

Outputs = ApplyGMDH(gmdh, Inputs);
TrainOutputs = Outputs(:,TrainInd);
TestOutputs = Outputs(:,TestInd);

%% Show Results

figure;
PlotResults(TrainTargets, TrainOutputs, 'Train Data');

figure;
PlotResults(TestTargets, TestOutputs, 'Test Data');

figure;
PlotResults(Targets, Outputs, 'All Data');

if ~isempty(which('plotregression'))
    figure;
    plotregression(TrainTargets, TrainOutputs, 'Train Data', ...
                   TestTargets, TestOutputs, 'TestData', ...
                   Targets, Outputs, 'All Data');

end
toc
%}