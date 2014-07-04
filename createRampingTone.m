function [tone] = createRampingTone(samplingRate,startFreq,endFreq,duration)
% create a pure tone sound
t=linspace(0,duration,round(samplingRate*duration));

%This uses a matlab signal processing function to generate a sweeping tone
tone=chirp(t,startFreq,t(end),endFreq)
%Make it stereo!
tone = [tone;tone];