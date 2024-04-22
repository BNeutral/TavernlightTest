jumpWindow = nil
topBarButton = nil
jumpButton = nil
needsReposition = false

-- TODO: Move from code to config
width = 200
height = 200
counter = 0
nextHeight = 0

topSpacing = 0
bottomSpacing = 0
leftSpacing = 0
rightSpacing = 0

function update()
    if not jumpWindow:isVisible() then
        return
    end

    -- FIXME: This is called each ... periodicalEvent ? .. and moves a fixed amount, but instead should move based on elapsed time so it's framerate independent
    counter = counter + 3
    jumpButton:show()

    local nextX = jumpWindow:getX() + jumpWindow:getWidth() - counter - jumpButton:getWidth()
    if nextX < jumpWindow:getX() + jumpWindow:getMarginLeft() + jumpWindow:getPaddingLeft() then
      randomlyRepositionJumpButton()
      jumpButton:hide() -- Hack: Hides single frame layout issue when repositioning. Unsure about cuase
    end
    

    local nextY = jumpWindow:getY() + topSpacing + nextHeight
    local point = { x = nextX, y = nextY }
    jumpButton:setPosition(point)
end

function randomlyRepositionJumpButton()
  counter = 0
  local possibleHeights = jumpWindow:getHeight() - topSpacing - bottomSpacing - jumpButton:getHeight()
  nextHeight = possibleHeights * math.random()
end

function init()
  jumpWindow = g_ui.displayUI('jump')
  leftSpacing = jumpWindow:getMarginLeft() + jumpWindow:getPaddingLeft()
  rightSpacing = jumpWindow:getMarginRight() + jumpWindow:getPaddingRight()
  topSpacing = jumpWindow:getMarginTop() + jumpWindow:getPaddingTop()
  bottomSpacing = jumpWindow:getMarginBottom() + jumpWindow:getPaddingBottom()

  jumpWindow:hide()
  
  topBarButton = modules.client_topmenu.addLeftButton('jumpMinigameButton', 'Jump Minigame', '/images/topbuttons/terminal', toggle)

  jumpButton = jumpWindow:recursiveGetChildById('jumpButton')
  randomlyRepositionJumpButton()

  -- Poor man's Update() calls  
  periodicalEvent(update, nil, nil, nil)
end

function terminate()
  -- FIXME: periodicalEvent needs to be dealt with here so we don't try to call update after destroying these things
  jumpButton:destroy()
  jumpWindow:destroy()
  topBarButton:destroy()
end

function hide()
  jumpWindow:hide()
end

function show()
  jumpWindow:show()
  jumpWindow:raise()
  jumpWindow:focus()
end

function toggle()
  if jumpWindow:isVisible() then
      hide()
  else
      show()
  end
end

function jumpClicked()
  randomlyRepositionJumpButton()
end