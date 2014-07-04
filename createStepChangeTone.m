function [tone] = createStepChangeTone(samplingRate,dopplerInfo)
% create a tone that changes between two values

rampDuration =dopplerInfo.rampDuration; %Ramp duration is around 1 video frame 16 ms
rampSamples = round(rampDuration*samplingRate);
movingFreq = (1 + dopplerInfo.audioVelocity/dopplerInfo.speedOfSound)*dopplerInfo.stimFreq;
duration = dopplerInfo.postStimDuration+dopplerInfo.stimDuration+dopplerInfo.postStimDuration;

t=linspace(0,duration,round(samplingRate*duration));
f=ones(size(t))*dopplerInfo.stimFreq; %initialize f to hold the frequency modulation
preStimLastSamp=round(samplingRate*dopplerInfo.preStimDuration);
stimLastSamp   = round(samplingRate*dopplerInfo.stimDuration)+preStimLastSamp;

f((preStimLastSamp+rampSamples): stimLastSamp) = movingFreq;
f(preStimLastSamp + (1:rampSamples)) = linspace(dopplerInfo.stimFreq,movingFreq,rampSamples);
f((stimLastSamp-rampSamples+1):stimLastSamp) = linspace(movingFreq,dopplerInfo.stimFreq,rampSamples);


tone = sin(2.*pi.*f.*t);
tone = [tone;tone];