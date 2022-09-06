' By juliantoro91.  More info: https://github.com/juliantoro91

sub main(args)
	showChannelSGScreen(args)
end sub

sub showChannelSGScreen(args)
	screen = CreateObject("roSGScreen")
	m.port = CreateObject("roMessagePort")

	screen.setMessagePort(m.port)
	scene = screen.CreateScene("MainScene")
	screen.Show()

	while(true)
		msg = wait(0, m.port)
		msgType = type(msg)

		if msgType = "roSGScreenEvent"
			if msg.isScreenClosed() then return
		end if
	end while
end sub
