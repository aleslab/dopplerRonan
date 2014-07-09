%function []=analyzeExperiment(experimentData,dopplerInfo)


validData = experimentData(validTrialList);

%Let's get our condition list.  NB tricky use of [] to pull out vector
conditionOrder = [experimentData(:).condNumber];
%Let's loop over conditions and organize the data
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
    %This is a naive calculation of standard error (assuming gaussian, when data is binomial,
    %but useful for prelimplotting 
    stdErrResponse(iCond) = std(perConditionData(iCond).responseList)/sqrt(length(perConditionData(iCond).responseList));
    
    visualVelocity(iCond) = dopplerInfo(iCond).visualVelocity;
    audioVelocity(iCond)  = dopplerInfo(iCond).audioVelocity;
end


errorbar(visualVelocity,meanResponse,stdErrResponse);





