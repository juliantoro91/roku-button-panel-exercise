' By juliantoro91.  More info: https://github.com/juliantoro91

sub Init()
    m.top.id = "MainScene"
    m.top.backgroundColor = "0x000000"

    initScreenWithButtons()
end sub

sub initScreenWithButtons()
    screen = CreateObject("roSGNode", "ScreenWithButtons")

    m.top.appendChild(screen)
    screen.visible = true
    screen.setFocus(true)
end sub