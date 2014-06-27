function [tone] = createPureTone(samplingRate,freq,duration)
% create a pure tone sound
t=linspace(0,duration,round(samplingRate*duration));
tone = sin(2*pi*freq*t);
tone = [tone;tone];