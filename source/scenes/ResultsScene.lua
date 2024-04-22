-- MAC VSCODE BUILD AND RUN HOTKEY: CMD + Shift + P

--
-- SceneTemplate.lua
--
-- Use this as a starting point for your game's scenes.
-- Copy this file to your root "scenes" directory,
-- and rename it.
--

-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- !!! Rename "SceneTemplate" to your scene's name in these first three lines. !!!
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!


local gfx <const> = playdate.graphics

SceneTemplate = {}
class("ResultsScene").extends(NobleScene)
local scene = ResultsScene

-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
-- !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

-- It is recommended that you declare, but don't yet define,
-- your scene-specific varibles and methods here. Use "local" where possible.
--
-- local variable1 = nil	-- local variable
-- scene.variable2 = nil	-- Scene variable.
--							   When accessed outside this file use `SceneTemplate.variable2`.
-- ...
--

-- This is the background color of this scene.
scene.backgroundColor = Graphics.kColorWhite

local SCROLL_SPEED = 0.5
local MIN_SCROLL = 0
local MAX_SCROLL = 239

local FILL_FRAME_COUT = 12
local OVERSCROLL_SPEED = 0.1

local CARD1_START = 0
local CARD2_START = 240

-- This runs when your scene's object is created, which is the
-- first thing that happens when transitining away from another scene.
function scene:init()
	scene.super.init(self)

	scene.font = gfx.font.new("assets/fonts/Sasser-Slab-EXBold");
    -- kVariantNormal
    -- kVariantBold
    -- kVariantItalic

	scene.overscroll = 0
	scene.endCard = Actor("assets/images/endcardGood", 0, CARD1_START)
	scene.creditsBg = Actor("assets/images/credits", 0, CARD2_START)

	scene.arrows = AnimatedActor("assets/images/arrowSpin-table-42-42",360,200,150)
	scene.arrowsFill = AnimatedActor("assets/images/replaySpin-table-42-42",360,200,9999999)

	scene.scroll = 0
	--scene.background = Graphics.image.new("assets/images/end1")
		
	-- SceneTemplate.variable2 = "string"
end

-- When transitioning from another scene, this runs as soon as this
-- scene needs to be visible (this moment depends on which transition type is used).
function scene:enter()
	scene.super.enter(self)
	-- Your code here
end

-- This runs once a transition from another scene is complete.
function scene:start()
	scene.super.start(self)
	-- Your code here
end

-- This runs once per frame.
function scene:update()
	scene.super.update(self)
	-- Your code here
	if scene.overscroll >= FILL_FRAME_COUT then
		Noble.transition(IntroCutscene, nil, Noble.Transition.DIP_TO_BLACK);
	end
end

-- This runs once per frame, and is meant for drawing code.
function scene:drawBackground()
	scene.super.drawBackground(self)
	-- Your code here

	--scene.background:draw(0,0)

	local words = GetChosenWords()
	local prompts = GetPrompts()
	--print(words[1][1])

	scene.endCard:render()
	scene.creditsBg:render()

	if scene.scroll == MAX_SCROLL then
		scene.arrowsFill:setFrame(math.floor(scene.overscroll))
		scene.arrowsFill:render()
	else
		scene.arrows:render()
	end

	local word = words[1]
	local prompt = prompts[1]

	gfx.setImageDrawMode(gfx.kDrawModeFillWhite)
	
	--local fWidth, fHeight = font:getTextWidth("EDIT"), font:getHeight()

	local screenWidth = 200
	local wordDistance = 60
	local y = 25 - scene.scroll

	gfx.setFont(scene.font, gfx.font.kVariantNormal)

	local width = scene.font:getTextWidth(words[1].text)
	local x = screenWidth - (width/2)
	gfx.drawText(words[1].text, x, y)
	y = y + wordDistance

	width = scene.font:getTextWidth(words[2].text)
	x = screenWidth - (width/2)
	gfx.drawText(words[2].text, x, y)
	y = y + wordDistance

	width = scene.font:getTextWidth(words[3].text)
	x = screenWidth - (width/2)
	gfx.drawText(words[3].text, x, y)
	y = y + wordDistance

	gfx.setImageDrawMode(gfx.kDrawModeCopy)
	-- gfx.drawText("Created By: Amelia & Mike", 0, 200)
	--Noble.Text.draw(score, 20, 20, Noble.Text.ALIGN_LEFT, false, Noble.Text.getCurrentFont())
end

-- This runs as as soon as a transition to another scene begins.
function scene:exit()
	scene.super.exit(self)
	-- Your code here
end

-- This runs once a transition to another scene completes.
function scene:finish()
	scene.super.finish(self)
	-- Your code here
end

function scene:pause()
	scene.super.pause(self)
	-- Your code here
end
function scene:resume()
	scene.super.resume(self)
	-- Your code here
end

-- Define the inputHander for this scene here, or use a previously defined inputHandler.

-- scene.inputHandler = someOtherInputHandler
-- OR
scene.inputHandler = {

	-- A button
	--
	AButtonDown = function()			-- Runs once when button is pressed.
		-- Your code here
	end,
	AButtonHold = function()			-- Runs every frame while the player is holding button down.
		-- Your code here
	end,
	AButtonHeld = function()			-- Runs after button is held for 1 second.
		-- Your code here
	end,
	AButtonUp = function()				-- Runs once when button is released.
		-- Your code here
	end,

	-- B button
	--
	BButtonDown = function()
		-- Your code here
	end,
	BButtonHeld = function()
		-- Your code here
	end,
	BButtonHold = function()
		-- Your code here
	end,
	BButtonUp = function()
		-- Your code here
	end,

	-- D-pad left
	--
	leftButtonDown = function()
		-- Your code here
	end,
	leftButtonHold = function()
		-- Your code here
	end,
	leftButtonUp = function()
		-- Your code here
	end,

	-- D-pad right
	--
	rightButtonDown = function()
		-- Your code here
	end,
	rightButtonHold = function()
		-- Your code here
	end,
	rightButtonUp = function()
		-- Your code here
	end,

	-- D-pad up
	--
	upButtonDown = function()
		-- Your code here
	end,
	upButtonHold = function()
		-- Your code here
	end,
	upButtonUp = function()
		-- Your code here
	end,

	-- D-pad down
	--
	downButtonDown = function()
		-- Your code here
	end,
	downButtonHold = function()
		-- Your code here
	end,
	downButtonUp = function()
		-- Your code here
	end,

	-- Crank
	--
	cranked = function(change, acceleratedChange)	-- Runs when the crank is rotated. See Playdate SDK documentation for details.

		if scene.scroll >= MAX_SCROLL then
	
			local amount = (change * SCROLL_SPEED)
			scene.overscroll = scene.overscroll + (amount * OVERSCROLL_SPEED)

			if scene.overscroll < 0 then
				scene.scroll = MAX_SCROLL - 1
				scene.overscroll = 0
			end

			if scene.overscroll > FILL_FRAME_COUT then
				scene.overscroll = FILL_FRAME_COUT
			end

		else
			local amount = (change * SCROLL_SPEED)
			
			scene.scroll = scene.scroll + amount

			if scene.scroll > MAX_SCROLL then
				scene.scroll = MAX_SCROLL
			elseif scene.scroll < MIN_SCROLL then
				scene.scroll = MIN_SCROLL
			end

			scene.endCard.posY = CARD1_START - scene.scroll
			scene.creditsBg.posY = CARD2_START - scene.scroll

		end

	end,
	crankDocked = function()						-- Runs once when when crank is docked.
		-- Your code here
	end,
	crankUndocked = function()						-- Runs once when when crank is undocked.
		-- Your code here
	end
}
