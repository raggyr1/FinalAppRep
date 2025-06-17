' filepath: /Users/stutipuranik/Documents/switchscene/components/mainscene.brs

' Main initialization function - called automatically when component is created
function init()
    ? "[MainScene] Initializing MainScene - START"
    
    try
        setupMainScene()
        ? "[MainScene] setupMainScene completed successfully"
    catch e
        ? "[MainScene] ERROR in setupMainScene:", e
    end try
    
    ? "[MainScene] Initializing MainScene - END"
end function

' Function containing all your MainScene logic
sub setupMainScene()
    ? "[MainScene] Setting up main scene components - START"
    
    ' Find UI components with error checking
    m.backgroundImage = m.top.findNode("backgroundImage")
    ? "[MainScene] Found backgroundImage:", (m.backgroundImage <> invalid)
    
    m.titleLabel = m.top.findNode("titleLabel")
    ? "[MainScene] Found titleLabel:", (m.titleLabel <> invalid)
    
    m.startButton = m.top.findNode("startButton")
    ? "[MainScene] Found startButton:", (m.startButton <> invalid)
    
    ' CHECK FOR NEXT BUTTON
    nextBtn = m.top.findNode("next")
    ? "[MainScene] Found next button:", (nextBtn <> invalid)
    if nextBtn <> invalid then
        ? "[MainScene] Next button visible:", nextBtn.visible
        ? "[MainScene] Next button text:", nextBtn.text
        ? "[MainScene] Next button translation:", nextBtn.translation
    end if
    
    if m.startButton <> invalid then
        m.startButton.observeField("buttonSelected", "onStartButtonPressed")
        m.startButton.setFocus(true)
        ? "[MainScene] Button observer and focus set"
    else
        ? "[MainScene] ERROR: startButton not found!"
    end if
    
    ? "[MainScene] MainScene setup complete"
end sub

' Handle start button press - REPLACE THIS FUNCTION
sub onStartButtonPressed()
    ? "[MainScene] Start button pressed - Starting Quiz!"
    
    ' Hide the start screen elements
    m.startButton.visible = false
    m.titleLabel.text = "Starting Quiz..."
    
    ' Hide the background image
    if m.backgroundImage <> invalid then
        m.backgroundImage.visible = false
        ? "[MainScene] Background image hidden"
    end if
    
    ' Call the vstest initialization function
    vstestInit()
    
    ' Show the quiz UI and set focus
    quizGroup = m.top.findNode("group")
    if quizGroup <> invalid then
        quizGroup.visible = true
        quizGroup.setFocus(true)
        ? "[MainScene] Quiz UI group made visible and focused"
    else
        ? "[MainScene] ERROR: Could not find quiz group"
    end if
    
    ' Load the first question
    loadFirstQuestion()
end sub

' Add this function to load and display the first question
sub loadFirstQuestion()
    questionLabel = m.top.findNode("questionLabel")
    if questionLabel <> invalid then
        questionLabel.text = "Who is the founder and CEO of Roku?"
        ? "[MainScene] First question loaded"
    end if
    
    ' Show instructions
    feedbackLabel = m.top.findNode("feedbackLabel")
    if feedbackLabel <> invalid then
        feedbackLabel.text = "Use arrow keys to navigate. Press OK to select an answer or skip."
        feedbackLabel.color = "0xFFFFFFFF"  ' White
    end if
    
    ' Set the answer buttons with the first set of answers
    btnA = m.top.findNode("btnA")
    btnB = m.top.findNode("btnB")
    btnC = m.top.findNode("btnC")
    btnD = m.top.findNode("btnD")
    
    if btnA <> invalid then btnA.text = "A. Reed Hastings"
    if btnB <> invalid then btnB.text = "B. Anthony Wood"      ' CORRECT ANSWER
    if btnC <> invalid then btnC.text = "C. Kerry Krempasky"
    if btnD <> invalid then btnD.text = "D. Steve Jobs"
    
    ' Set focus to first answer button
    if btnA <> invalid then
        btnA.setFocus(true)
        ? "[MainScene] Focus set to first answer button"
    end if
end sub

' Handle key events
function onKeyEvent(key as String, press as Boolean) as Boolean
    ? "[MainScene] Key pressed:", key
    
    if press then
        ' Check if quiz is active
        quizGroup = m.top.findNode("group")
        if quizGroup <> invalid and quizGroup.visible = true then
            return handleQuizNavigation(key)
        end if
    end if
    
    return false
end function

function handleQuizNavigation(key as String) as Boolean
    btnA = m.top.findNode("btnA")
    btnB = m.top.findNode("btnB")
    btnC = m.top.findNode("btnC")
    btnD = m.top.findNode("btnD")
    nextBtn = m.top.findNode("next")
    
    if key = "up" then
        if btnD <> invalid and btnD.hasFocus() then
            btnC.setFocus(true)
            return true
        else if btnC <> invalid and btnC.hasFocus() then
            btnB.setFocus(true)
            return true
        else if btnB <> invalid and btnB.hasFocus() then
            btnA.setFocus(true)
            return true
        else if nextBtn <> invalid and nextBtn.hasFocus() and nextBtn.visible then
            btnD.setFocus(true)
            return true
        end if
    else if key = "down" then
        if btnA <> invalid and btnA.hasFocus() then
            btnB.setFocus(true)
            return true
        else if btnB <> invalid and btnB.hasFocus() then
            btnC.setFocus(true)
            return true
        else if btnC <> invalid and btnC.hasFocus() then
            btnD.setFocus(true)
            return true
        else if btnD <> invalid and btnD.hasFocus() and nextBtn <> invalid and nextBtn.visible then
            nextBtn.setFocus(true)
            return true
        end if
    end if
    
    return false
end function