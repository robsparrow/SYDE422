clear all; clc;

%===============================================================================
% Title: Evolutionary Image Registration for Mosaicing of Remotely Sensed Images
% Author: Rob Sparrow, Systes Design Engineering, University of Waterloo
% April 4th, 2012
%===============================================================================
 
%-------------------------------------------------------------------------------
% Section Title: Setup and execute the differential evolution algorithm
%-------------------------------------------------------------------------------

%Col1:Sample reference,2:trial reference,3: Initial xTrans, 4: Initial yTrans
% 5:Recovered xTrans,6:recovered yTrans,7:number of evals,8=xTrans error,
% 9=yTrans error
performance=zeros(7,10,9);
% Col1: Sample, 2: average x error, 3: average y error
avgPerformance=zeros(7,3);
%Col1:Sample reference,2:trial reference,3: Initial xTrans, 4: Initial yTrans
% 5:Recovered xTrans,6:recovered yTrans,7:number of evals,8=xTrans error,
% 9=yTrans error
bestPerformance=zeros(7,10);

%Create the matrix of random translation values generated from the command
%window. Done outside of .m file so same translations applied in each
%algorithm.
randTranslations=[13 79; 165 137; 170 9; 191 89; 38 41; 40 96; 103 154; 47 ...
    199; 8 25; 195 56];

for i=4:10
    for n=1:10
        
%       Show the image and trial number as sanity check
        disp('Sample');
        disp(i);
        disp('Trial');
        disp(n);  
        
        sample=num2str(i);
        trial=num2str(n);
        
        % Load original image
        targetFolder = 'Samples';
        original = strcat(targetFolder, '\', sample, '.png');
        original = imread(original);
        original = rgb2gray(original);
        
        % Setup transformations
        % Note: pass [0 0 0 0] if the image is not cropped
        theta = 0; % degree rotation counterclockwise
        scale = 1; %Resizing of image after cropping
        xCoord=randTranslations(n,1);
        yCoord=randTranslations(n,1);
        windowSize = 300;
        cropWindow = [xCoord yCoord windowSize windowSize]; %Specify crop window of the model ([xmin ymin width height])
        
        %Apply all transformations to the image
        [distorted] = imprepare(original, theta, cropWindow, scale);
        
        %Save images for access later
        targetFolder = 'Test Data Differential';
        image = 'model';
        image = strcat(targetFolder, '\', image, sample, '-', trial, '.png');
        imwrite(original, image, 'png');
        image = 'scene';
        image = strcat(targetFolder, '\', image, sample, '-', trial, '.png');
        imwrite(distorted, image, 'png');
        
        %Run the DE
        %(population,# of parameters,step size,crossover probability,itermax,strategy);
        [bestmem,nfeval] = diffevolution_function(1000,2,1,.2,1000,1, original, distorted);
        xError = abs(bestmem(1)-xCoord)/abs(xCoord);
        yError = abs(bestmem(2)-yCoord)/abs(yCoord);
        
        %       Sow the xError and yError to track results as they are generated
        disp('X Actual');
        disp(xCoord);
        disp('X Recovered');
        disp(bestmem(1));
        disp('Y Actual');
        disp(yCoord);
        disp('Y Recovered');
        disp(bestmem(2));
        disp('xError');
        disp(xError);
        disp('yError');
        disp(yError);
        
        performance(i-3,n,1)=i-3;
        performance(i-3,n,2)=n;
        performance(i-3,n,3)=xCoord;
        performance(i-3,n,4)=yCoord;
        performance(i-3,n,5)=bestmem(1);
        performance(i-3,n,6)=bestmem(2);
        performance(i-3,n,7)=nfeval;
        performance(i-3,n,8)=xError;
        performance(i-3,n,9)=yError;
        
        % Show the scene image extracted and the macthed part of the model
        im_matched=original(xCoord:(xCoord+windowSize-1),yCoord:(yCoord+windowSize-1));
        H.Position=[502 258 259 402];
        figure(H)
        subplot(2,1,1)
        imagesc(distorted)
        title('Scene')
        subplot(2,1,2)
        imagesc(im_matched)
        title('Matched section of Model')
        colormap (gray)
             
    end
    %     Write the average performance for the sample to an array
    avgXError=sum(performance(i-3,:,8))/10;
    avgYError=sum(performance(i-3,:,9))/10;
    avgPerformance(i-3,1)=i-3;
    avgPerformance(i-3,2)=avgXError;
    avgPerformance(i-3,3)=avgYError;
    
    % Determine the best performance of all trials for the sample
    bestVal=1000;
    for b=1:10
        if (performance(i-3,b,8)+performance(i-3,b,9))/2<bestVal
            bestVal=(performance(i-3,b,8)+performance(i-3,b,9))/2;
            bestTrial=b;
        end
    end
    
    %     Write the best performance for all trials using the sample to an
    %     array    
    bestPerformance(i-3,1)=i;
    bestPerformance(i-3,2)=b;
    bestPerformance(i-3,3)=performance(i-3,b,3);
    bestPerformance(i-3,4)=performance(i-3,b,4);
    bestPerformance(i-3,5)=performance(i-3,b,5);
    bestPerformance(i-3,6)=performance(i-3,b,6);
    bestPerformance(i-3,7)=performance(i-3,b,7);
    bestPerformance(i-3,8)=performance(i-3,b,8);
    bestPerformance(i-3,9)=performance(i-3,b,9);
end