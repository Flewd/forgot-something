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
class("IntroCutscene").extends(NobleScene)
local scene = IntroCutscene

-- This is the background color of this scene.
scene.backgroundColor = Graphics.kColorBlack

local TITLE_START = 10
local TITLE_TARGET = -150

local PERSON_START = 58
local PERSON_TARGET = -20

local ARM_START = 240
local ARM_TARGET = 80

local ZOOM_START = 1
local ZOOM_TARGET = 3
local ZOOM_SPEED = 0.005

function scene:init()
	scene.super.init(self)
	scene.title = Actor("assets/images/titleText_black", 20, TITLE_START)
	scene.person = Actor("assets/images/head", 50, PERSON_START)

	local isApple = IsApple()

	if isApple == true then
		scene.arm = Actor("assets/images/handApple", 70, ARM_START)
	else
		scene.arm = Actor("assets/images/handKeys", 70, ARM_START)
	end

	scene.arm.scaleAnchorX = 0.5
end

-- When transitioning from another scene, this runs as soon as this
-- scene needs to be visible (this moment depends on which transition type is used).
function scene:enter()
	scene.super.enter(self)
end

-- This runs once a transition from another scene is complete.
function scene:start()
	scene.super.start(self)
end

-- This runs once per frame.
function scene:update()
	scene.super.update(self)
end

-- This runs once per frame, and is meant for drawing code.
function scene:drawBackground()
	scene.super.drawBackground(self)

	gfx.setImageDrawMode(gfx.kDrawModeNXOR)

	--scene.background:draw(0,0)
	scene.title:render()
	scene.person:render()
	scene.arm:render()
end

-- This runs as as soon as a transition to another scene begins.
function scene:exit()
	scene.super.exit(self)
end

-- This runs once a transition to another scene completes.
function scene:finish()
	scene.super.finish(self)
end

function scene:pause()
	scene.super.pause(self)
end

function scene:resume()
	scene.super.resume(self)
end

-- Define the inputHander for this scene here, or use a previously defined inputHandler.

-- scene.inputHandler = someOtherInputHandler
-- OR
scene.inputHandler = {
	-- Crank
	--
	cranked = function(change, acceleratedChange)	-- Runs when the crank is rotated. See Playdate SDK documentation for details.
		-- Your code here

		-- scene.person.scale = scene.person.scale + (change*ZOOM_SPEED)

		
		if change > 0 then
			if scene.title.posY > TITLE_TARGET then
				scene.title.posY = scene.title.posY - change
				-- clamp
				if scene.title.posY < TITLE_TARGET then 
					scene.title.posY = TITLE_TARGET
				end

			elseif scene.person.posY > PERSON_TARGET then
				scene.person.posY = scene.person.posY - change
				-- clamp
				if scene.person.posY < PERSON_TARGET then 
					scene.person.posY = PERSON_TARGET
				end

			elseif scene.arm.posY > ARM_TARGET then
				scene.arm.posY = scene.arm.posY - change
				-- clamp
				if scene.arm.posY < ARM_TARGET then 
					scene.arm.posY = ARM_TARGET
				end

			elseif scene.person.scale < ZOOM_TARGET then
				scene.person.scale = scene.person.scale + (change * ZOOM_SPEED)
				scene.arm.scale = scene.person.scale
				-- clamp
				if scene.person.scale > ZOOM_TARGET then 
					scene.person.scale = ZOOM_TARGET
					scene.arm.scale = scene.person.scale
				end

			else
				-- Noble.transition(HamScene, nil, Noble.Transition.Spotlight);
				Noble.transition(HamScene, nil, Noble.Transition.SpotlightMask);
			end
		else
			if scene.person.scale > ZOOM_START then
				scene.person.scale = scene.person.scale + (change * ZOOM_SPEED)
				scene.arm.scale = scene.person.scale
				-- clamp
				if scene.person.scale < ZOOM_START then 
					scene.person.scale = ZOOM_START
					scene.arm.scale = scene.person.scale
				end
			elseif scene.arm.posY < ARM_START then
				scene.arm.posY = scene.arm.posY - change
				-- clamp
				if scene.arm.posY > ARM_START then 
					scene.arm.posY = ARM_START
				end
			elseif scene.person.posY < PERSON_START then
				scene.person.posY = scene.person.posY - change
				-- clamp
				if scene.person.posY > PERSON_START then 
					scene.person.posY = PERSON_START
				end
			elseif scene.title.posY < TITLE_START then
				scene.title.posY = scene.title.posY - change
				-- clamp
				if scene.title.posY > TITLE_START then 
					scene.title.posY = TITLE_START
				end
			end
		end		

	end,
	crankDocked = function()						-- Runs once when when crank is docked.
		-- Your code here
	end,
	crankUndocked = function()						-- Runs once when when crank is undocked.
		-- Your code here
	end,

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

	
}
