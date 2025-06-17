sub Main()
    ? "Quiz App starting..."
    
    ' Create the screen
    screen = CreateObject("roSGScreen")
    m.port = CreateObject("roMessagePort")
    screen.setMessagePort(m.port)
    
    ' Set MainScene as the entry point
    m.scene = screen.CreateScene("MainScene")
    screen.show()
    
    ? "MainScene displayed, entering message loop..."
    
    ' Message loop to keep app running
    while(true)
        msg = wait(0, m.port)
        msgType = type(msg)
        if msgType = "roSGScreenEvent"
            if msg.isScreenClosed() 
                ? "Screen closed, exiting app"
                return
            end if
        end if
    end while
end sub