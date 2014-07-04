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
    
    dopplerInfo(1).visualVelocity = 200;   %Stimulus velocity in cm per second
    dopplerInfo(1).audioVelocity  = 200;
    dopplerInfo(1).speedOfSound   = 34000; %speed of sound in cm per second
    dopplerInfo(1).stimRadiusCm   = 1;    %stimulus size in cm;
    dopplerInfo(1).stimFreq       = 1000;  %Audio Stimulus frequency in Hz
    dopplerInfo(1).rampDuration   = 32/1000; %Ramp duration is around 1 video frame 16 ms

    %Condition 2: towards consistent
    dopplerInfo(2) = dopplerInfo(1); %Use the same settings for condition 1
    %Change the velocity values
    dopplerInfo(2).visualVelocity = -200;   %Stimulus velocity in cm per second
    dopplerInfo(2).audioVelocity  = -200;
    
    
    nConditions = length(dopplerInfo);
    nReps = 3;
    
    %lets enumerate the total number of trials we need.
    conditionList = repmat(1:nConditions,1,nReps);
    
    %Now lets do a quick randomization
    [~,idx]=sort(rand(size(conditionList)));
    conditionList = conditionList(idx);
    
    nTrials = nReps*nConditions;
    for iTrial =1:nTrials
        thisCond = conditionList(iTrial);
        
        [trialData] = dopplerTrial(screenInfo,dopplerInfo(thisCond));
        
        WaitSecs(dopplerInfo(thisCond).isi);
    end
    
    
    
    
    closeExperiment;
catch
    disp('caught')
    errorMsg = lasterror;
    closeExperiment;
    psychrethrow(psychlasterror);
    
end;
