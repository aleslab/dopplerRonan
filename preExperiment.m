function screenInfo = preExperiment(monitorWidth, subjectDist, expScreen)
% For own laptop: monitorWidth = 34cm/1920pixels, subjectDist = 100cm,
% expScreen = 0 (default)
rand('seed', sum(100 * clock));
PsychDefaultSetup(2);
HideCursor
if nargin < 3
    expScreen = 0;
end
Screen('Preference', 'SkipSyncTests', 1);
Screen('Preference', 'VisualDebugLevel',2);

% Set the background to the background value.
screenInfo.bckgnd = 0;
[screenInfo.curWindow, screenInfo.screenRect] = Screen('OpenWindow', expScreen, screenInfo.bckgnd,[],32, 2);
screenInfo.dontclear = 0; % 1 gives incremental drawing (does not clear buffer after flip)
topPriorityLevel = MaxPriority(screenInfo.curWindow);

%screenInfo.monRefresh = Screen(curWindow,'FrameRate');
screenInfo.ifi =Screen('GetFlipInterval', screenInfo.curWindow);      % seconds per frame
screenInfo.monRefresh = 1/screenInfo.ifi;    % frames per second
screenInfo.frameDur = 1000/screenInfo.monRefresh;

screenInfo.center = [screenInfo.screenRect(3) screenInfo.screenRect(4)]/2;   	% coordinates of screen center (pixels)

% determine pixels per degree
% (pix/screen) * ... (screen/rad) * ... rad/deg
screenInfo.ppd = pi * screenInfo.screenRect(3) / atan(monitorWidth/subjectDist/2) / 360;    % pixels per degree
screenInfo.subjectDist=subjectDist;

screenInfo.ifi = Screen('GetFlipInterval', screenInfo.curWindow);
 

InitializePsychSound

screenInfo.pahandle = PsychPortAudio('Open', [], [], 0, [], 2);


end