try
    clear all
    sca;
    
    % For own laptop: monitorWidth = 34cm/1920pixels, subjectDist = 100cm,
    monitorWidth = 34; subjectDist = 200;
    screenInfo = preExperiment(monitorWidth,subjectDist);
    
%     white = 1
%     black = 0
       
    
    %Condition definitions
    %Condition 1: Away consistent
    dopplerInfo(1).stimDuration     = 0.250; %approximate stimulus duration in seconds
    dopplerInfo(1).preStimDuration  = 0.5;  %Static time before stimulus change
    dopplerInfo(1).postStimDuration = 0.5;  %static time aftter stimulus change
    dopplerInfo(1).isi              = 1;     %Inter Stimulus Interval
    dopplerInfo(1).responseDuration = 1;    %Post trial window for waiting for a response
    
    dopplerInfo(1).visualVelocity = 0;   %Stimulus velocity in cm per second
    dopplerInfo(1).audioVelocity  = 400;
    dopplerInfo(1).speedOfSound   = 34000; %speed of sound in cm per second
    dopplerInfo(1).stimRadiusCm   = 1;    %stimulus size in cm;
    dopplerInfo(1).stimFreq       = 2000;  %Audio Stimulus frequency in Hz
    dopplerInfo(1).rampDuration   = 32/1000; %Ramp duration is around 1 video frame 16 ms

    %Condition 2: towards consistent
    dopplerInfo(2) = dopplerInfo(1); %Use the same settings for condition 1
    %Change the velocity values
    dopplerInfo(2).visualVelocity = -0;   %Stimulus velocity in cm per second
    dopplerInfo(2).audioVelocity  = -400;
    
    
    nConditions = length(dopplerInfo);
    nReps = 3;
    
    %lets enumerate the total number of trials we need.
    conditionList = repmat(1:nConditions,1,nReps);
    
    %Now lets do a quick randomization
    [~,idx]=sort(rand(size(conditionList)));
    conditionList = conditionList(idx);
    
    %Now lets setup response gathering
    % Wait for the "a" key with KbQueueWait.
    keysOfInterest=zeros(1,256);
    keysOfInterest(KbName({'f' 'j' 'ESCAPE'}))=1;
    KbQueueCreate(screenInfo.deviceIndex, keysOfInterest);
    KbQueueStart(deviceIndex);
    
    %Now lets begin the experiment and loop over the conditions to show.
    
    nTrials = nReps*nConditions;
    %
    while iTrial <=length(conditionList)
        
        %ISI happens before a trial starts
        WaitSecs(dopplerInfo(thisCond).isi);
          
        thisCond = conditionList(iTrial);
        
        [trialData(iTrial)] = dopplerTrial(screenInfo,dopplerInfo(thisCond));
        trialData(iTrial).condNumber = thisCond;
        
        %Determine what should be done depending on keypresses
        numKeysPressed = sum((trialData(iTrial).firstPress>0));
        
        if numKeysPressed ~= 1  %No valid response made. Let's repeat that trial
        
            conditionList(end+1) = conditionList(iTrial);  
            
        else %valid response made
            if trialData.firstPress(KbName('ESCAPE'))
                %pressed escape lets abort experiment;
                break;
            elseif trialData.firstPress(KbName('f'))
            elseif trialData.firstPress(KbName('g'))
            end
        end
        
            
      iTrial = iTrial+1;
    end
    
    
    
    
    closeExperiment;
catch
    disp('caught')
    errorMsg = lasterror;
    closeExperiment;
    psychrethrow(psychlasterror);
    
end;
