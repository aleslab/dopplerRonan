close all
clear all
sca
PsychDefaultSetup(2)
preExperiment
white = 1
black = 0
screenNumber = max(0)
[window, windowRect] = PsychImaging('OpenWindow', screenNumber, white)
[screenXpixels, screenYpixels] = Screen('WindowSize', window)
[xCenter, yCenter] = RectCenter(windowRect)
Screen('BlendFunction', window, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA)
ifi = Screen('GetFlipInterval', window)
topPriorityLevel = MaxPriority(window)
numSecs = .05
numFrames = round(numSecs / ifi)
waitframes = 1
HideCursor
v = 10
a = 860
b = 440
c = 1060
d = 640

Screen('fillOval', window, [255 0 0], [a b c d])
Screen('Flip', window)
for frames = 0
    WaitSecs(3)
    Screen('fillOval', window, [255 0 0], [a b c d])
    Screen('Flip', window)
end
for frames = 0:numFrames
    Screen('fillOval', window, [255 0 0], [a b c d])
    Screen('Flip', window)
    a = a+v*-2 
    b = b+v*-2 
    c = c+v*2 
    d = d+v*2
end
for frames = 0
    Screen('fillOval', window, [255 255 255], [a b c d])
    Screen('Flip', window)
end
KbStrokeWait
sca