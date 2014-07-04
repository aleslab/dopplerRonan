function screenInfo = preExperiment(monitorWidth, subjectDist, expScreen)
% For own laptop: monitorWidth = 34cm/1920pixels, subjectDist = 100cm,
% expScreen = 0 (default)
rand('seed', sum(100 * clock))
Screen('Preference', 'SkipSyncTests', 1)
Screen('Preference', 'VisualDebugLevel',2)
InitializePsychSound
screenInfo.pahandle = PsychPortAudio('Open', [], [], 0, [], 2)
end