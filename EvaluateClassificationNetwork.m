%% 
%This program evaluates the performance of a classification network assigned 
%to the variable "net" on images in an image datastore "imds"
%%
%Assign network to be evaluated to the variable named "net"
%%
net= networkToEvaluate;%Provide the name of network loaded in workspace
%% 
%Assign to the variable "imds" the image data store with path to 
%the desired image data folder instead of 'PathToImageDataFolder'
imds = imageDatastore('PathToImageDataFolder','IncludeSubfolders',true,'LabelSource','foldernames');
%% 
%Perform classification with "net" on data from "imds"
[preds,probs] = classify(net,imds);
%% 
%Plot Confusion Matrix
plotconfusion(imds.Labels,preds);
%%
% Calculate Accuracy
%%Accuracy
accuracy = mean(preds == imds.Labels) ;
disp(" Accuracy is :")
disp(accuracy)
%% Assign Confusion Matrix to variable "cm"
cm=confusionmat(imds.Labels,preds);
%% Calculate Precision
% Preciscion=[TruePositives/(TruePositives+FalsePositives)]
precision = diag(cm)./sum(cm,2);
disp(precision)
%% Calculate Recall
%Recall=[TruePositives/(TruePositives+FalseNegatives)]
recall = diag(cm)./sum(cm,1)';
disp(recall)
%%
% Display the misclassified images
incrt_img_ind=find(imds.Labels~=preds);
num_incrt=numel(incrt_img_ind);
missed_imgs=cell(num_incrt,1);
for i=1:num_incrt
    missed_imgs{i}=imread(string(imds.Files(incrt_img_ind(i))));
    %[Y,~]=classify(net,missed_imgs{i});%Uncomment to double check
end

figure
montage(missed_imgs,'BorderSize',10)