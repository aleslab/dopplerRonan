%function []=analyzeExperiment(experimentData,dopplerInfo)
clear all;

userin = uigetfile('*.mat','MultiSelect','on')
if ~iscell(userin);
    fnames{1} = userin;
else
    fnames = userin;
end

conditionNames = {'con','+150','-150','inc'}
condNameIdx = repmat(1:4,9,1);condNameIdx = condNameIdx(:);

for iName =1:length(fnames);
    
    tmpLoad =load(fnames{iName});
    
        tmpLoad =load(fnames{iName});
    
    if iName ==1
       experimentData = tmpLoad.experimentData; 
    else
        
    experimentData = [experimentData tmpLoad.experimentData];
    end
end

outputName = [fnames{end} '_SPSSOutput_MeanData' datestr(now,'yyyymmdd_HHMMSS') '.txt'];

fidMean = fopen(outputName,'w');


if fidMean==-1;
    error(['Cannot open: ' outputName ' for writing']);
end
fprintf(fidMean,'filename\tconditionName\tvisualVelocity\tmeanresponse\tmeanresponseTime\n')


    
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
        
        
        thisCondName = conditionNames{condNameIdx(iCond)};
        fprintf(fidMean,'%s\t%s\t%f\t%f\t%f\n',fnames{iName}, thisCondName, ...
            visualVelocity(iCond),meanResponse(iCond),meanResponseTime(iCond));
        
    end
    
    


fclose(fidMean);