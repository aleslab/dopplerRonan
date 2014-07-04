function [trialData] = dopplerTrial(screenInfo, dopplerInfo)

totalDuration = dopplerInfo.postStimDuration+dopplerInfo.stimDuration+dopplerInfo.postStimDuration;
nFrames = round(totalDuration / screenInfo.ifi);
trialData.actualDuration = nFrames*screenInfo.ifi;


%Generate sound:
movingFreq = (1 + dopplerInfo.audioVelocity/dopplerInfo.speedOfSound)*dopplerInfo.stimFreq;
audioStatus = PsychPortAudio('GetStatus', screenInfo.pahandle);
preStimSound  = createPureTone(audioStatus.SampleRate,dopplerInfo.stimFreq,dopplerInfo.preStimDuration);
stimSound     = createPureTone(audioStatus.SampleRate,movingFreq,dopplerInfo.stimDuration);
postStimSound = createPureTone(audioStatus.SampleRate,dopplerInfo.stimFreq,dopplerInfo.postStimDuration);

mySound = [preStimSound stimSound postStimSound];
PsychPortAudio('FillBuffer', screenInfo.pahandle, mySound);



%Strictly speaking this probably isn't the _best_ way to setup the timing
%for rendering the stimulus but whatever.
dopplerInfo.stimStartTime = GetSecs; %Get current time to start the clock
flipTimes = nan(nFrames,1);

t1 = PsychPortAudio('Start', screenInfo.pahandle, 1, 0, 1);
 
for iFrame = 1:nFrames
    
    thisTime =  GetSecs - dopplerInfo.stimStartTime-dopplerInfo.preStimDuration; 
    %How long has it been since last draw?

    %relcalculate time to account for pre and post stim
    %
    dopplerInfo.stimTime = min(max(thisTime,0),dopplerInfo.stimDuration);   
    stimRect = calculateStimSize(screenInfo,dopplerInfo);
    Screen('fillOval', screenInfo.curWindow, [255 0 0], stimRect);
    
    Screen('DrawingFinished',screenInfo.curWindow,screenInfo.dontclear);
    flipTimes(iFrame)=Screen('Flip', screenInfo.curWindow);
    
    
end

trialData.flipTimes = flipTimes;
Screen('Flip', screenInfo.curWindow);
end

function stimRect = calculateStimSize(screenInfo,dopplerInfo)


%calculate object distance given starting size and how long the stimulus has been on;
objectDistance = screenInfo.subjectDist-dopplerInfo.stimTime*dopplerInfo.visualVelocity;

%given the object is simulated to have moved to objectDistance calculate
%the pixel size of the stimulus
stimRadiusDegrees = atand(dopplerInfo.stimRadiusCm/objectDistance);
stimRadiusPixels  = round(screenInfo.ppd*stimRadiusDegrees);


stimLeft    = screenInfo.center(1) - stimRadiusPixels;
stimTop     = screenInfo.center(2) - stimRadiusPixels;
stimRight   = screenInfo.center(1) + stimRadiusPixels;
stimBottom  = screenInfo.center(2) + stimRadiusPixels;

stimRect = [stimLeft stimTop stimRight stimBottom];
end
