' By juliantoro91.  More info: https://github.com/juliantoro91

sub init()
    _initComponents()
    _initObservers()
end sub

sub _initComponents()
    m.background = m.top.findNode("backgroundPoster")
    m.background.uri = "pkg:/images/background_FHD.jpeg"

    m.screenTitle = m.top.findNode("screenTitle")
    m.screenTitle.text = "Select a button"

    m.titleLabel = m.top.findNode("titleLabel")
    m.titleLabel.text = "A rowlist"

    m.rowList = m.top.findNode("rowList")
    rowListContent = CreateObject("roSGNode", "RowListContent")
    for each itemContent in rowListContent.getChild(0).getChildren(rowListContent.getChild(0).getChildCount(), 0)
        itemContent.addField("itemFocused", "boolean", false)
        itemContent.itemFocused = false
    end for
    m.rowlist.content = rowListContent

    m.topButton = m.top.findNode("topButton")

    m.buttonPanel = m.top.findNode("buttonPanel")
    ' New fields for buttonPanel
    m.buttonPanel.addField("enabled", "boolean", false)
    m.buttonPanel.enabled = false
    m.buttonPanel.addField("focusedItem", "integer", false)
    m.buttonPanel.focusedItem = -1

    m.buttonPanelAux = m.buttonPanel.clone(true)

    m.maxButtonsPerRow = 5

    initButtonsPanel()
end sub

sub _initObservers()
    m.top.observeField("focusedChild", "initFocus")
    m.topButton.observeField("buttonSelected", "showDialog")
    m.rowlist.observeField("rowItemFocused", "onRowItemFocused")
    m.rowList.observeField("focusedChild", "onRowlistFocusChange")
end sub

sub initFocus()
    if m.top.visible = true AND m.top.isInFocusChain()
        if NOT m.topButton.hasFocus()
            m.topButton.setFocus(true)
            m.top.unobserveField("focusedChild")
        end if
    end if
end sub

function createButton(buttonId as String, buttonLabel as String, func = "" as String, enable = true as Boolean, visible = true as Boolean) as Object
    if visible = true
        label = createObject("roSGNode", "SimpleLabel")
        ' label.font = "fontUri:SmallBoldSystemFont"
        label.text = buttonLabel

        button = createObject("roSGNode", "Button")
        button.addField("enabled", "boolean", false)
        button.enabled = enable

        button.height = 64

        button.textFont = "font:SmallBoldSystemFont"
        button.focusedTextFont = "font:SmallBoldSystemFont"

        button.focusBitmapUri = "pkg:/images/Button.png"
        button.focusFootprintBitmapUri = "pkg:/images/Button-Unfocused.png"
        button.showFocusFootprint = true

        textColor = "#D8DADC"
        if not enable then textColor = "#686A6C"

        button.focusedTextColor = textColor
        button.textColor = textColor

        button.focusedIconUri = ""
        button.iconUri = ""

        button.minWidth = 0
        button.maxWidth = label.boundingRect()["width"] + 80

        button.text = buttonLabel

        button.id = buttonId + "_button"

        button.observeField("buttonSelected", func)

        return button
    else
        return invalid
    end if
end function

function buttonPanelConfig()
    buttonsConfig = {
        buttons : {
            one : {
                labels : {
                    default : "Button one"
                }
                func : "oneButtonSelected"
            }
            two : {
                labels : {
                    default : "Button two"
                }
                func : "twoButtonSelected"
            }
            three : {
                labels : {
                    default : "Button three"
                }
                func : "threeButtonSelected"
            }
            four : {
                labels : {
                    default : "Button four"
                }
                func : "fourButtonSelected"
            }
            five : {
                labels : {
                    default : "Button five"
                }
                func : "fiveButtonSelected"
            }
            six : {
                labels : {
                    default : "Button six"
                }
                func : "sixButtonSelected"
            }
            seven : {
                labels : {
                    default : "Button seven"
                }
                func : "sevenButtonSelected"
            }
            eight : {
                labels : {
                    default : "Button eight"
                }
                func : "eightButtonSelected"
            }
        }
        visuals : {
            A : ["one", "two", "three", "four", "five"]
            B : ["one", "two", "three", "four", "five", "six", "seven", "eight"]
            C : ["one", "two", "three", "four", "five", "six", "seven", "eight", "one", "two", "three", "four", "five", "six", "seven", "eight"]
        }
    }

    return buttonsConfig
end function

sub addButtonsToScreen()
    m.newButtonRow = false
    num = 0
    for each buttonKey in m.buttonsToShow
        keys = m.buttonsConfig.buttons[buttonKey].primaryKey

        key = "default"

        label = m.buttonsConfig.buttons[buttonKey].labels[key]

        func = m.buttonsConfig.buttons[buttonKey].func

        enable = true
        if m.buttonsSettings.enable[buttonKey] <> invalid then enable = m.buttonsSettings.enable[buttonKey]

        visible = true
        if m.buttonsSettings.visible[buttonKey] <> invalid then visible = m.buttonsSettings.visible[buttonKey]

        buttonId = num.toStr() + "_" + buttonKey

        button = createButton(buttonId, label, func, enable, visible)

        if m.buttonPanel.getChildCount() < 5
            m.buttonPanel.appendChild(button)
            if enable = true AND visible = true AND m.buttonPanel.enabled = false
                m.buttonPanel.enabled = true
                m.titleLabel.translation = [120, 571]
                m.rowlist.translation = [120, 636]
            end if
        else
            if NOT m.newButtonRow
                m.newButtonRow = true

                m.buttonPanelAux.translation = [120, 524]
                m.buttonPanelAux.id = "buttonPanelAux"

                m.buttonPanelAux.enabled = false

                m.buttonPanelAux.focusedItem = 0

                m.top.appendChild(m.buttonPanelAux)

                m.titleLabel.translation = [120, 656]
                m.rowlist.translation = [120, 721]
            end if
            if m.buttonPanelAux.getChildCount() < m.maxButtonsPerRow
                m.buttonPanelAux.appendChild(button)
                if enable = true  AND visible = true AND m.buttonPanelAux.enabled = false
                    m.buttonPanelAux.enabled = true
                end if
            end if
        end if

        num ++
    end for
end sub

sub initButtonsPanel(option = "A" as String)
    m.buttonsConfig = buttonPanelConfig()

    m.buttonsSettings = {
        visible : {
            one : false
        }
        enable : {
            three : false
        }
    }

    m.buttonsToShow = m.buttonsConfig.visuals[option]

    addButtonsToScreen()
end sub

sub focusButtonPanel(buttonPanel, direction = "" as String) ' Direction could be right or left
    if buttonPanel.focusedItem = -1 then buttonPanel.focusedItem = 0

    if buttonPanel.enabled
        index = buttonPanel.focusedItem

        button = buttonPanel.getChild(index)
        if direction = "" AND button <> invalid
            if button.enabled AND button.visible
                button.setFocus(true)
                return
            end if
        end if

        increase = 1
        if direction = "left" then increase = -1

        index = buttonPanel.focusedItem + increase
        while true
            if increase < 0
                if index < 0 then index = buttonPanel.getChildCount() - 1
            else if increase > 0
                if index >= buttonPanel.getChildCount() then index = 0
            end if

            if index = buttonPanel.focusedItem then exit while

            if buttonPanel.getChild(index).enabled
                button = buttonPanel.getChild(index)
                if button <> invalid
                    button.setFocus(true)
                    buttonPanel.focusedItem = index
                end if
                exit while
            end if
            index = index + increase
        end while
    end if
end sub

sub showdialog()
    dialog = createObject("roSGNode", "Dialog")
    dialog.title = "Buttons Panel mode"
    dialog.optionsDialog = true
    dialog.message = "Select the desired buttons panel mode"
    dialog.buttons = ["A", "B", "C"]
    dialog.observeField("buttonSelected", "onDialogButtonSelected")
    m.top.GetScene().dialog = dialog
end sub

sub onDialogButtonSelected(event as Object)
    option = event.getData().toStr()
    m.top.GetScene().dialog = invalid

    availableOptions = {
        "0": "A"
        "1": "B"
        "2": "C"
    }

    m.top.selectedOption = availableOptions[option]
end sub

sub onOptionSelected(event as Object)
    option = event.getData()

    m.buttonPanel.removeChildrenIndex(m.buttonPanel.getChildCount(), 0)
    m.buttonPanel.enabled = false
    m.buttonPanelAux.removeChildrenIndex(m.buttonPanelAux.getChildCount(), 0)
    m.buttonPanelAux.enabled = false

    initButtonsPanel(option)
end sub

sub onRowItemFocused(event as Object)
    row = event.getData()[0]
    index = event.getData()[1]

    rowContent = m.rowlist.content.getChild(row)

    for i = 0 to rowContent.getChildCount() - 1
        itemContent = rowContent.getChild(i)
        if i = index
            itemContent.itemFocused = true
        else
            itemContent.itemFocused = false
        end if
    end for
end sub

sub onRowlistFocusChange()
    if NOT m.rowlist.isInFocusChain()
        for i = 0 to m.rowlist.content.getChildCount() - 1
            rowContent = m.rowlist.content.getChild(i)
            for j = 0 to rowContent.getChildCount() - 1
                itemContent = rowContent.getChild(j)
                itemContent.itemFocused = false
            end for
        end for
    end if
end sub

sub oneButtonSelected(event as Object)
    m.selectedButtonId = event.getRoSGNode().id
    msg = "Button one has been selected"
    onButtonSelected(msg)
end sub

sub twoButtonSelected(event as Object)
    m.selectedButtonId = event.getRoSGNode().id
    msg = "Button two has been selected"
    onButtonSelected(msg)
end sub

sub threeButtonSelected(event as Object)
    m.selectedButtonId = event.getRoSGNode().id
    msg = "Button three has been selected"
    onButtonSelected(msg)
end sub

sub fourButtonSelected(event as Object)
    m.selectedButtonId = event.getRoSGNode().id
    msg = "Button four has been selected"
    onButtonSelected(msg)
end sub

sub fiveButtonSelected(event as Object)
    m.selectedButtonId = event.getRoSGNode().id
    msg = "Button five has been selected"
    onButtonSelected(msg)
end sub

sub sixButtonSelected(event as Object)
    m.selectedButtonId = event.getRoSGNode().id
    msg = "Button six has been selected"
    onButtonSelected(msg)
end sub

sub sevenButtonSelected(event as Object)
    m.selectedButtonId = event.getRoSGNode().id
    msg = "Button seven has been selected"
    onButtonSelected(msg)
end sub

sub eightButtonSelected(event as Object)
    m.selectedButtonId = event.getRoSGNode().id
    msg = "Button eight has been selected"
    onButtonSelected(msg)
end sub

sub onButtonSelected(msg as String)
    m.screenTitle.text = msg
end sub

function onKeyEvent(key as String, press as Boolean) as Boolean
    result = false

    if press
        if key = "back"
            result = true
        else if key = "down"
            if m.topButton.isInFocusChain()
                if m.buttonPanel.enabled = true
                    focusButtonPanel(m.buttonPanel)
                else if m.buttonPanelAux.enabled = true
                        focusButtonPanel(m.buttonPanelAux)
                else
                    m.rowlist.setFocus(true)
                end if
            else if m.buttonPanel.isInFocusChain()
                if m.buttonPanelAux.enabled = true
                    focusButtonPanel(m.buttonPanelAux)
                else
                    m.rowlist.setFocus(true)
                end if
            else if m.buttonPanelAux.isInFocusChain()
                m.rowlist.setFocus(true)
            end if
            result = true
        else if key = "up"
            if m.rowlist.isInFocusChain()
                if m.buttonPanelAux.enabled = true
                    focusButtonPanel(m.buttonPanelAux)
                else if m.buttonPanel.enabled = true
                    focusButtonPanel(m.buttonPanel)
                else
                    m.topButton.setFocus(true)
                end if
            else if m.buttonPanelAux.isInFocusChain()
                if m.buttonPanel.enabled = true
                    focusButtonPanel(m.buttonPanel)
                else
                    m.topButton.setFocus(true)
                end if
            else if m.buttonPanel.isInFocusChain()
                m.topButton.setFocus(true)
            end if
            result = true
        else if key = "right" OR key = "left"
            if m.buttonPanel.isInFocusChain()
                focusButtonPanel(m.buttonPanel, key)
                result = true
            else if m.buttonPanelAux.isInFocusChain()
                focusButtonPanel(m.buttonPanelAux, key)
                result = true
            end if
        end if
    end if

    return result
end function