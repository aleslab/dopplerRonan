clear dopplerInfo;


% %Condition definitions
% %Condition 1: Away consistent
% dopplerInfo(1).stimDuration     = 0.30; %approximate stimulus duration in seconds
% dopplerInfo(1).preStimDuration  = 0.5;  %Static time before stimulus change
% dopplerInfo(1).postStimDuration = 0;  %static time aftter stimulus change
% dopplerInfo(1).isi              = 1;     %Inter Stimulus Interval
% dopplerInfo(1).responseDuration = 1;    %Post trial window for waiting for a response
% 
% dopplerInfo(1).visualVelocity = 200;   %Stimulus velocity in cm per second
% dopplerInfo(1).audioVelocity  = 200;
% dopplerInfo(1).speedOfSound   = 34000; %speed of sound in cm per second
% dopplerInfo(1).stimRadiusCm   = 1;    %stimulus size in cm;
% dopplerInfo(1).stimFreq       = 500;  %Audio Stimulus frequency in Hz
% dopplerInfo(1).rampDuration   = 32/1000; %Ramp duration is around 1 video frame 16 ms
% 
% 
% 
% %Condition 2: towards consistent
% dopplerInfo(2) = dopplerInfo(1); %Use the same settings for condition 1
% %Change the velocity values
% dopplerInfo(2).visualVelocity = -200;   %Stimulus velocity in cm per second
% dopplerInfo(2).audioVelocity  = -200;
%
% %Condition 3: away inconsistent
% dopplerInfo(3) = dopplerInfo(1); %Use the same settings for condition 1
% %Change the velocity values
% dopplerInfo(3).visualVelocity = 200;   %Stimulus velocity in cm per second
% dopplerInfo(3).audioVelocity  = -200;


% %Condition definitions
%Condition 1, lets set some defaults:
dopplerInfo(1).stimDuration     = 0.15; %approximate stimulus duration in seconds
dopplerInfo(1).preStimDuration  = 0.5;  %Static time before stimulus change
dopplerInfo(1).postStimDuration = 0;  %static time aftter stimulus change
dopplerInfo(1).isi              = 1;     %Inter Stimulus Interval
dopplerInfo(1).responseDuration = 1;    %Post trial window for waiting for a response

dopplerInfo(1).visualVelocity = 200;   %Stimulus velocity in cm per second
dopplerInfo(1).audioVelocity  = 200;
dopplerInfo(1).speedOfSound   = 34000; %speed of sound in cm per second
dopplerInfo(1).stimRadiusCm   = 1;    %stimulus size in cm;
dopplerInfo(1).stimFreq       = 500;  %Audio Stimulus frequency in Hz
dopplerInfo(1).rampDuration   = 32/1000; %Ramp duration is around 1 video frame 16 ms

%lets just code up the stimulus list by hand, first 5 are consistent 2nd 5
%are inconsistent

% visualVelocityList = [-200 -100 0 100 200 -200  -100 0  100  200];
% audioVelocityList  = [-200 -100 0 100 200  200   100 0 -100 -200];
% visualVelocityList = [ 400    400 ];%-200 200 ]
% audioVelocityList  = [400 -400 ];% 0   0 ]

velocityList = [-300:50:300]
visualVelocityList = [velocityList velocityList velocityList velocityList];
audioVelocityList  = [velocityList velocityList+150 velocityList-150 -velocityList];



for iCond = 1:length(visualVelocityList)
    dopplerInfo(iCond) = dopplerInfo(1);
    dopplerInfo(iCond).visualVelocity = visualVelocityList(iCond);
    dopplerInfo(iCond).audioVelocity = audioVelocityList(iCond);
end
