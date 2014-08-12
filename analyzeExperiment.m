%function []=analyzeExperiment(experimentData,dopplerInfo)
clear all;

userin = uigetfile('*.mat','MultiSelect','on')

if ~iscell(userin);
    fnames{1} = userin;
else
    fnames = userin;
end

for iName =1:length(fnames);
   
    tmpLoad =load(fnames{iName});
    
    if iName ==1
       experimentData = tmpLoad.experimentData; 
    else
        
    experimentData = [experimentData tmpLoad.experimentData];
    end
end
    

validTrialList = [experimentData(:).validTrial];
validData = experimentData(validTrialList);
experimentData = validData;


%Let's get our condition list.  NB tricky use of [] to pull out vector
conditionOrder = [experimentData(:).condNumber];
%Let's loop over conditions and organize the data
nConditions = max(conditionOrder);
for iCond = 1:nConditions
    
    %This finds which trial correponds to this condition.
    [condIdx] = find(conditionOrder==iCond);

    
    %Doing a lot with this line.  Gathering all the responses and recoding
    %any 'j' presses to the number 1;
    %reason to keep it in a structure at this point is to deal with the
    %possibility of unequal number of trials;
    perConditionData(iCond).responseList=[experimentData(condIdx).response]=='j';
    %Gather response times
    perConditionData(iCond).responseTimes=[experimentData(condIdx).responseTime];

    %Let's take a mean of the choice
    meanResponse(iCond)   = mean(perConditionData(iCond).responseList);
    meanResponseTime(iCond)   = mean(perConditionData(iCond).responseTimes);
    %This is a naive calculation of standard error (assuming gaussian, when data is binomial,
    %but useful for prelimplotting 
    stdErrResponse(iCond) = std(perConditionData(iCond).responseList)/sqrt(length(perConditionData(iCond).responseList));
    stdErrResponseTime(iCond) = std(perConditionData(iCond).responseTimes)/sqrt(length(perConditionData(iCond).responseTimes));
    
    visualVelocity(iCond) = experimentData(condIdx(1)).dopplerInfo.visualVelocity;
    audioVelocity(iCond)  = experimentData(condIdx(1)).dopplerInfo.audioVelocity;
    
    
    
end

%%
% 
% 
% errorbar(visualVelocity,meanResponse,stdErrResponse);

visVel = reshape(visualVelocity,9,4)
audVel = reshape(audioVelocity,9,4)

r = reshape(meanResponse,9,4)
rStdE = reshape(stdErrResponse,9,4)
rt= reshape(meanResponseTime,9,4)
rtStdE = reshape(stdErrResponse,9,4)

figure(1)
clf;
errorbar(visVel,r,rStdE);
legend('con','+150','-150','inc')

figure(2)
clf;
errorbar(visVel,rt,rtStdE);

legend('con','+150','-150','inc')

figure(3)
clf;
errorbar(r,rt,rtStdE);

legend('con','+150','-150','inc')

rDiff(:,1) = r(:,2) - r(:,1);
rDiff(:,2) = r(:,3) - r(:,1);
rDiff(:,3) = r(:,4) - r(:,1);
figure(101)
clf;
plot(visVel(:,1:3),rDiff)
legend('+150','-150','inc')


rtDiff(:,1) = rt(:,2) - rt(:,1);
rtDiff(:,2) = rt(:,3) - rt(:,1);
rtDiff(:,3) = rt(:,4) - rt(:,1);
figure(102)
clf;
plot(visVel(:,1:3),rtDiff)
legend('+150','-150','inc')
% figure(102)
% clf;
% errorbar(visVel,rt,rtStdE);
% 
% legend('con','+150','-150','inc')



% figure(101)
% clf;
% errorbar(audVel,r,rStdE);
% legend('con','+150','-150','inc')
% xlabel('AUDIO velocity')
% 
% figure(102)
% clf;
% errorbar(audVel,rt,rtStdE);
% 
% legend('con','+150','-150','inc')
% xlabel('AUDIO velocity')

