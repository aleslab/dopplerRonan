try
    clear all
    sca;
    
    % For own laptop: monitorWidth = 34cm/1920pixels, subjectDist = 100cm,
    monitorWidth = 34; subjectDist = 300;
    expScreen = max(Screen('Screens'))
    screenInfo = preExperiment(monitorWidth,subjectDist,expScreen);
    
    
    screenInfo.useKbQueue = false;
    %     white = 1
    %     black = 0
    
    
    %Pushed condition definitions to separate script.  Makes keeping track
    %of different conditions, and experiment changes simpler
    defineConditions;
    
    
    nConditions = length(dopplerInfo);
    nReps = 5;
    
    %lets enumerate the total number of trials we need.
    conditionList = repmat(1:nConditions,1,nReps);
    
    %Now lets do a quick randomization
    [~,idx]=sort(rand(size(conditionList)));
    conditionList = conditionList(idx);
    
    %Now lets setup response gathering
    
    if screenInfo.useKbQueue
        % Wait for the "a" key with KbQueueWait.
        keysOfInterest=zeros(1,256);
        keysOfInterest(KbName({'f' 'j' 'ESCAPE'}))=1;
        KbQueueCreate(screenInfo.deviceIndex, keysOfInterest);
        KbQueueStart(screenInfo.deviceIndex);
    else
    end
    
    %Now lets begin the experiment and loop over the conditions to show.
    
    nTrials = nReps*nConditions;
    %
    iTrial = 1;
    while iTrial <=length(conditionList)
        validTrialList(iTrial)= true;  %initialize this index variable to keep track of bad/aborted trials
          
        thisCond = conditionList(iTrial);
                
        %ISI happens before a trial starts
        WaitSecs(dopplerInfo(thisCond).isi);

        [trialData] = dopplerTrial(screenInfo,dopplerInfo(thisCond));
        experimentData(iTrial).condNumber = thisCond;
        
        %Determine what should be done depending on keypresses
        numKeysPressed = sum((trialData.firstPress>0));
        
        if numKeysPressed ~= 1  %No valid response made. Let's repeat that trial
        
            %Should add a message to the subject that they were too slow.
            conditionList(end+1) = conditionList(iTrial);  
            validTrialList(iTrial) = false;

            
        else %valid response made
            if trialData.firstPress(KbName('ESCAPE'))
                %pressed escape lets abort experiment;
                validTrialList(iTrial) = false;
                break;
            elseif trialData.firstPress(KbName('f'))
                experimentData(iTrial).response = 'f';
                experimentData(iTrial).responseTime = ...
                    trialData.firstPress(KbName('f'))-trialData.flipTimes(end);
            elseif trialData.firstPress(KbName('j'))
                experimentData(iTrial).response = 'j';
                experimentData(iTrial).responseTime = ...
                    trialData.firstPress(KbName('j'))-trialData.flipTimes(end);
            else %Wait a minute this isn't a valid response
                conditionList(end+1) = conditionList(iTrial);
                validTrialList(iTrial) = false;
            end
        end
        
      
      experimentData(iTrial).trialData = trialData;
      iTrial = iTrial+1;
      
    end
    
    
   if screenInfo.useKbQueue
       KbQueueRelease(screenInfo.deviceIndex);
   end
    closeExperiment;
catch
    if screenInfo.useKbQueue
        KbQueueRelease(screenInfo.deviceIndex);
    end
    disp('caught')
    errorMsg = lasterror;
    closeExperiment;
    psychrethrow(psychlasterror);
    
end;
