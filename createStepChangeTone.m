function [tone] = createStepChangeTone(samplingRate,dopplerInfo,subjectDistance)
% create a tone that changes between two values



movingFreq = (1 + dopplerInfo.audioVelocity/dopplerInfo.speedOfSound)*dopplerInfo.stimFreq;
duration = dopplerInfo.preStimDuration+dopplerInfo.stimDuration+dopplerInfo.postStimDuration;

t=linspace(0,duration,round(samplingRate*duration));
f=ones(size(t))*dopplerInfo.stimFreq; %initialize f to hold the frequency modulation

preStimLastSamp=round(samplingRate*dopplerInfo.preStimDuration);
stimLastSamp   = round(samplingRate*dopplerInfo.stimDuration)+preStimLastSamp;
preStimIdx  = 1:preStimLastSamp;
stimIdx     = (preStimLastSamp+1):stimLastSamp;
postStimIdx = (stimLastSamp+1):length(t);

tone(preStimIdx) = sin(2*pi*dopplerInfo.stimFreq*t(preStimIdx));
phase = 2*pi*t(preStimIdx(end))*(dopplerInfo.stimFreq-movingFreq);

tone(stimIdx)    = sin(2*pi*movingFreq*t(stimIdx)+phase);

phase = 2*pi*t(stimIdx(end))*(movingFreq-dopplerInfo.stimFreq)+phase;

tone(postStimIdx)    = sin(2*pi*dopplerInfo.stimFreq*t(postStimIdx)+phase);



% Code to change volume:

initialVolume = .5;
%dopplerInfo.audioVelocity
finalDistance = subjectDistance-dopplerInfo.audioVelocity*dopplerInfo.stimDuration;

objectDistance(preStimIdx) = subjectDistance;
objectDistance(stimIdx)    = linspace(subjectDistance, finalDistance ,length(stimIdx));
objectDistance(postStimIdx) = finalDistance;

amplitudeFunction = 1./(objectDistance./subjectDistance);
amplitudeFunction = amplitudeFunction*initialVolume;
%make a quick decay at the end to reduce the click artifacts for abrupt endings amplitude
decayIdx = (length(t)-round(samplingRate*.0167)):length(t);
amplitudeFunction(decayIdx) = linspace(amplitudeFunction(decayIdx(1)),0,length(decayIdx));


%amplitudeFunction(stimLastSamp)

tone = tone.*amplitudeFunction;

% Old code that tried to simulate acceleration
% rampDuration =dopplerInfo.rampDuration; %Ramp duration is around 1 video frame 16 ms
% rampSamples = round(rampDuration*samplingRate);

%f((preStimLastSamp+rampSamples): stimLastSamp) = movingFreq;

% k = (movingFreq-dopplerInfo.stimFreq)/rampDuration;
% f(preStimLastSamp + (1:rampSamples)) = dopplerInfo.stimFreq+(k/2).*(t(preStimLastSamp + (1:rampSamples))-t(preStimLastSamp+1));
% %f(preStimLastSamp + (1:rampSamples)) = linspace(dopplerInfo.stimFreq,movingFreq,rampSamples);
% 
% f((stimLastSamp-rampSamples+1):stimLastSamp) = linspace(movingFreq,dopplerInfo.stimFreq,rampSamples);


  
% beta   = (f1-f0).*(t1.^(-p));
% 
% yvalue = cos(2*pi * ( beta./(1+p).*(t.^(1+p)) + f0.*t + phi/360));

%tone = sin(2.*pi.*f.*t);
%tone = sin(2.*pi.*f.*t);
tone = [tone;tone];