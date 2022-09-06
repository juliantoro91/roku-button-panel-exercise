' By juliantoro91.  More info: https://github.com/juliantoro91

sub init()
    m.itemposter = m.top.findNode("itemPoster")
    m.itemmask = m.top.findNode("itemMask")
end sub

sub showcontent()
    itemcontent = m.top.itemContent
    m.itemposter.uri = itemcontent.HDPosterUrl

    itemContent.observeField("itemFocused", "onItemFocused")
end sub

sub onItemFocused()
    if m.top.itemContent.itemFocused = true
        scale = 1.08
    else
        scale = 1.0
    end if
    m.itemposter.scale = [scale, scale]
end sub
