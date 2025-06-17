' Create a function to initialize the quiz
sub vstestInit()
    ? "[vstest] Initializing quiz..."
    
    ' Quiz data
    m.questionList = [
        "Who is the founder and CEO of Roku?",
        "What year was the first Roku device released?",
        "Which company did Roku partner with for its first streaming device?",
        "What does the word Roku mean in Japanese?"
    ]
    
    m.answersList = [
        "Reed Hastings", "Anthony Wood", "Kerry Krempasky", "Steve Jobs",                
        "2010", "2008", "2015", "2005",                
        "Amazon", "Hulu", "Netflix", "Disney+", 
        "Three", "Four", "Five", "Six"
    ]
    
    m.checkan = [
        "n", "y", "n", "n",               
        "n", "y", "n", "n",                
        "n", "n", "y", "n",                
        "n", "n", "n", "y"          
    ]

    ' Timer setup
    m.timeLeft = 10  ' 10 seconds per question
    m.currentQuestion = 0
    
    ' Find UI components
    m.instructions = m.top.findNode("instructionLabel")
    if m.instructions <> invalid then
        m.instructions.text = "Hint: Press the asterisk and refresh to reset data"
    end if
    
    m.questionLabel = m.top.findNode("questionLabel")
    m.feedbackLabel = m.top.findNode("feedbackLabel")
    m.label = m.top.findNode("timerLabel")
    m.timer = m.top.findNode("countdownTimer")
    
    if m.timer <> invalid then
        m.timer.observeField("fire", "onCountdownUpdate")
    end if
    
    ' Find answer buttons
    m.btnA = m.top.findNode("btnA")
    m.btnB = m.top.findNode("btnB")
    m.btnC = m.top.findNode("btnC")
    m.btnD = m.top.findNode("btnD")
    m.nextbtn = m.top.findNode("next")
    
    ' Make next button visible and set up observer
    if m.nextbtn <> invalid then
        m.nextbtn.visible = true  ' Always visible during quiz
        m.nextbtn.observeField("buttonSelected", "onNextQuestion")
        ? "[vstest] Next button made visible and observer set"
    end if
    
    ' Set up button observers
    if m.btnA <> invalid then
        m.btnA.observeField("buttonSelected", "onSelected")
    end if
    
    if m.btnB <> invalid then
        m.btnB.observeField("buttonSelected", "onSelected")
    end if
    
    if m.btnC <> invalid then
        m.btnC.observeField("buttonSelected", "onSelected")
    end if
    
    if m.btnD <> invalid then
        m.btnD.observeField("buttonSelected", "onSelected")
    end if
    
    ' Start the timer
    startTimer()
    
    ? "[vstest] Quiz initialization complete"
end sub

' Add timer functions to vstest.brs
sub startTimer()
    if m.timer <> invalid then
        m.timeLeft = 10
        updateTimerDisplay()
        m.timer.control = "start"
        ? "[vstest] Timer started"
    end if
end sub

sub onCountdownUpdate()
    m.timeLeft = m.timeLeft - 1
    updateTimerDisplay()
    
    if m.timeLeft <= 0 then
        ? "[vstest] Time's up!"
        m.timer.control = "stop"
        
        ' Show feedback for timeout
        if m.feedbackLabel <> invalid then
            m.feedbackLabel.text = "Time's up! Moving to next question..."
            m.feedbackLabel.color = "0xFF0000FF"  ' Red
        end if
        
        ' Auto move to next question after 2 seconds
        ' You can add logic here to move to next question
    end if
end sub

sub updateTimerDisplay()
    if m.label <> invalid then
        m.label.text = "Time: " + m.timeLeft.toStr()
        
        ' Change color when time is running low
        if m.timeLeft <= 3 then
            m.label.color = "0xFF0000FF"  ' Red
        else
            m.label.color = "0xFFFFFFFF"  ' Black
        end if
    end if
end sub

sub onSelected()
    ? "[vstest] Answer selected"
    
    ' Stop the timer
    if m.timer <> invalid then
        m.timer.control = "stop"
        ? "[vstest] Timer stopped"
    end if
    
    ' Get which button was selected
    selectedButton = invalid
    selectedIndex = -1
    
    if m.btnA <> invalid and m.btnA.hasFocus() then
        selectedButton = m.btnA
        selectedIndex = 0
    else if m.btnB <> invalid and m.btnB.hasFocus() then
        selectedButton = m.btnB
        selectedIndex = 1
    else if m.btnC <> invalid and m.btnC.hasFocus() then
        selectedButton = m.btnC
        selectedIndex = 2
    else if m.btnD <> invalid and m.btnD.hasFocus() then
        selectedButton = m.btnD
        selectedIndex = 3
    end if
    
    ? "[vstest] Selected button ID:", selectedButton.id, "Index:", selectedIndex
    ? "[vstest] Current question:", m.currentQuestion
    
    if selectedButton <> invalid and selectedIndex >= 0 then
        ' Calculate the correct answer index for current question
        answerStartIndex = m.currentQuestion * 4
        correctAnswerIndex = answerStartIndex + selectedIndex
        
        ? "[vstest] Answer start index:", answerStartIndex
        ? "[vstest] Checking index:", correctAnswerIndex
        ? "[vstest] Check value:", m.checkan[correctAnswerIndex]
        
        ' Check if answer is correct
        isCorrect = (m.checkan[correctAnswerIndex] = "y")
        
        ? "[vstest] Is correct:", isCorrect
        
        ' Show feedback
        showAnswerFeedback(isCorrect, selectedButton)
        
        ' Don't call showNextButton() - button is always visible
    end if
end sub

sub showAnswerFeedback(isCorrect as Boolean, selectedButton as Object)
    if m.feedbackLabel <> invalid then
        if isCorrect then
            m.feedbackLabel.text = "Correct! Well done!"
            ? "[vstest] Correct answer selected"
        else
            m.feedbackLabel.text = "Wrong! Try the next question."
            ? "[vstest] Wrong answer selected"
        end if
    end if
    
    ' Use the selectedButton parameter to avoid warning
    ? "[vstest] Selected button type:", type(selectedButton)
end sub

sub highlightCorrectAnswer()
    ' Find which answer is correct for current question
    answerStartIndex = m.currentQuestion * 4
    
    for i = 0 to 3
        if m.checkan[answerStartIndex + i] = "y" then
            ' Highlight the correct button
            if i = 0 and m.btnA <> invalid then
                m.btnA.color = "0x00FF00FF"  ' Green
            else if i = 1 and m.btnB <> invalid then
                m.btnB.color = "0x00FF00FF"  ' Green
            else if i = 2 and m.btnC <> invalid then
                m.btnC.color = "0x00FF00FF"  ' Green
            else if i = 3 and m.btnD <> invalid then
                m.btnD.color = "0x00FF00FF"  ' Green
            end if
            exit for
        end if
    end for
end sub

sub showNextButton()
    ? "[vstest] showNextButton() called - SHOULD SEE BUTTON NOW!"
    
    nextBtn = m.top.findNode("next")
    ? "[vstest] Found next button:", (nextBtn <> invalid)
    
    if nextBtn <> invalid then
        ? "[vstest] Before - Next button visible:", nextBtn.visible
        ? "[vstest] Before - Next button translation:", nextBtn.translation
        
        nextBtn.visible = true
        nextBtn.setFocus(true)
        
        ? "[vstest] After - Next button visible:", nextBtn.visible
        ? "[vstest] After - Next button has focus:", nextBtn.hasFocus()
        ? "[vstest] NEXT BUTTON SHOULD BE VISIBLE NOW!"
    else
        ? "[vstest] ERROR: Could not find next button!"
    end if
end sub

sub onNextQuestion()
    ? "[vstest] Next question selected"
    
    ' Move to next question
    m.currentQuestion = m.currentQuestion + 1
    
    ' Check if there are more questions
    if m.currentQuestion < m.questionList.Count() then
        ' Load next question
        loadQuestion(m.currentQuestion)
        
        ' Reset UI for next question
        resetQuestionUI()
        
        ' Start timer again
        startTimer()
    else
        ' Quiz is complete
        showQuizComplete()
    end if
end sub

sub resetQuestionUI()
    ' DON'T hide next button - keep it visible
    ' if m.nextbtn <> invalid then
    '     m.nextbtn.visible = false
    ' end if
    
    ' Clear feedback
    if m.feedbackLabel <> invalid then
        m.feedbackLabel.text = ""
    end if
    
    ' Set focus back to first answer
    if m.btnA <> invalid then
        m.btnA.setFocus(true)
    end if
end sub

sub showQuizComplete()
    if m.questionLabel <> invalid then
        m.questionLabel.text = "Quiz Complete! Thanks for playing!"
    end if
    
    if m.feedbackLabel <> invalid then
        m.feedbackLabel.text = "Press Back to return to main menu"
        m.feedbackLabel.color = "0x00FF00FF"
    end if
    
    ' Hide answer buttons
    if m.btnA <> invalid then m.btnA.visible = false
    if m.btnB <> invalid then m.btnB.visible = false
    if m.btnC <> invalid then m.btnC.visible = false
    if m.btnD <> invalid then m.btnD.visible = false
    if m.nextbtn <> invalid then m.nextbtn.visible = false
end sub

' Loads the question and answer choices for the given index
sub loadQuestion(questionIndex as Integer)
    if m.questionLabel <> invalid then
        m.questionLabel.text = m.questionList[questionIndex]
    end if

    answerStartIndex = questionIndex * 4
    if m.btnA <> invalid then m.btnA.text = m.answersList[answerStartIndex]
    if m.btnB <> invalid then m.btnB.text = m.answersList[answerStartIndex + 1]
    if m.btnC <> invalid then m.btnC.text = m.answersList[answerStartIndex + 2]
    if m.btnD <> invalid then m.btnD.text = m.answersList[answerStartIndex + 3]
end sub