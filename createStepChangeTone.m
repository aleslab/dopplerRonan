function [tone] = createStepChangeTone(samplingRate,dopplerInfo,subjectDistance)
% create a tone that changes between two values

%Note:
%Everything needs to be carefully stitched to avoid artificacts on
%transitions. This isn't 100% perfect in this current code. So on some
%transitions there are clicks/pops.  These are caused when there are
%discontinuities in the waveform.  
%

%Create the shifts in frequency using the doppler equations:
%movingFreq=(1+ objectSpeed/speedOfSound)*toneFreq.
movingFreq = (1 + dopplerInfo.audioVelocity/dopplerInfo.speedOfSound)*dopplerInfo.stimFreq;
duration = dopplerInfo.preStimDuration+dopplerInfo.stimDuration+dopplerInfo.postStimDuration;

t=linspace(0,duration,round(samplingRate*duration));
f=ones(size(t))*dopplerInfo.stimFreq; %initialize f to hold the frequency modulation

%Determine which sample indices correspond to stimulus periods. 
preStimLastSamp=round(samplingRate*dopplerInfo.preStimDuration);
stimLastSamp   = round(samplingRate*dopplerInfo.stimDuration)+preStimLastSamp;
preStimIdx  = 1:preStimLastSamp;
stimIdx     = (preStimLastSamp+1):stimLastSamp;
postStimIdx = (stimLastSamp+1):length(t);

%Keep tone constant for the pre-move period
tone(preStimIdx) = sin(2*pi*dopplerInfo.stimFreq*t(preStimIdx));
%determine the phase at the end of the prestim period.
%We need this in order to determine what starting phase to use for the stim
%period.  That attempts to match the waveforms together to minimize
%discontinuity created pops.
phase = 2*pi*t(preStimIdx(end))*(dopplerInfo.stimFreq-movingFreq);

tone(stimIdx)    = sin(2*pi*movingFreq*t(stimIdx)+phase);

%Same for stitched the post-stim on the end. 
phase = 2*pi*t(stimIdx(end))*(movingFreq-dopplerInfo.stimFreq)+phase;

tone(postStimIdx)    = sin(2*pi*dopplerInfo.stimFreq*t(postStimIdx)+phase);



% Code to change volume:


initialVolume = .5;
%dopplerInfo.audioVelocity
%Determine how far the sound of the object should move
finalDistance = subjectDistance-dopplerInfo.audioVelocity*dopplerInfo.stimDuration;

%Set the object distances
objectDistance(preStimIdx) = subjectDistance;
objectDistance(stimIdx)    = linspace(subjectDistance, finalDistance ,length(stimIdx));
objectDistance(postStimIdx) = finalDistance;

%Scale the volume from the starting distance
%Note: This is a bit tricky. Power scales in proportion to 1/r^2
%However, we are manipulating the AMPLITUDE of the sine wave not the POWER. 
%Therefore we scale the amplitude with 1/distance^2.
%If it wasn't a pure tone life would get more complex.
amplitudeFunction = 1./(objectDistance./subjectDistance);
amplitudeFunction = amplitudeFunction*initialVolume;

%When stopping a sound if we just truncate it and reduce to zero it will
%create a pop. 
%make a quick (16.7ms) decay at the end to reduce the click artifacts for abrupt endings amplitude
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

%Make it the same in both stereo channels.
tone = [tone;tone];