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
class("HamScene").extends(NobleScene)
local scene = HamScene

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
scene.backgroundColor = Graphics.kColorBlack

local levelDataPhrase = "You forgot your _ while _ at the _"
local levelDataWords1 = {
	{"Apple", 10},
	{"Junk1", 1},
	{"Junk2", 1},
	{"Junk3", 1},
	{"Junk4", 1},
	{"Keys", 30},
	{"Junk5", 1},
	{"Junk6", 1},
	{"Junk7", 1},
	{"Junk8", 1},
	{"Kiss", 50},
	{"Junk9", 1},
	{"Junk10", 1},
	{"Junk11", 1},
	{"Junk12", 1},
	}

local levelDataWords2 = {
	{"Working", 10},
	{"Running", 30},
	{"Driving", 50},
	}

local levelDataWords2 = {
	{"Office", 10},
	{"Home", 30},
	{"Coffe Shop", 50},

	{"Junk", 1},
	{"Junk", 50},
	}


-- This runs when your scene's object is created, which is the
-- first thing that happens when transitining away from another scene.
function scene:init()
	scene.super.init(self)

	scene.score = 0
	scene.crankAcceleration = 0.1

	scene.minVelocity = 1
	scene.maxVelocity = 300


	scene.velocity = scene.minVelocity
	--scene.wordTest = Word("HAM HELLO", 0, 50)

	scene.nextWordIndex = 1
	scene.activeWords = {}


	for i=1, 3, 1 do
	--for i=1, #levelDataWords1 do
		local text = levelDataWords1[i][1];
		local score = levelDataWords1[i][2];

		table.insert(scene.activeWords, Word(text, 50 * i, 50, score));
		nextWordIndex = i + 1
	end


    local font = gfx.font.new("assets/fonts/diamond_20");
    -- kVariantNormal
    -- kVariantBold
    -- kVariantItalic
	gfx.setFont(font, gfx.font.kVariantNormal)

	-- SceneTemplate.variable2 = "string"
	-- ...

	--scene.wheel = NobleSprite("assets/images/wheelWIP")
	--scene.wheel = gfx.image.new("assets/images/wheelWIP")


	--scene.wheel = gfx.image.new("assets/images/wheelInverted")

	scene.frameTime = 100
	scene.wheel = gfx.imagetable.new("assets/images/wheel-table-400-240")
	scene.wheelLoop = gfx.animation.loop.new(scene.frameTime, scene.wheel, true)
	
	
	
	--scene.wheel = gfx.sprite.new(wheelImage)
	--scene.wheel:moveTo(200, 40)
	--scene.wheel:add()


	-- Your code here
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

	--local wheelRot = scene.wheel:getRotation()
	--scene.wheel:setRotation(wheelRot + 1)

	gfx.setImageDrawMode(gfx.kDrawModeNXOR)

	scene.wheelLoop:draw(0,0)


	for i=1, #scene.activeWords do
		print(scene.activeWords[i])
	end

	local removeList = {}


	for i=1, #scene.activeWords do
		local word = scene.activeWords[i]
		word.posX = word.posX + scene.velocity
		word:update()

		if word.posX > 400 then -- 400 = screen width
			
			table.insert(removeList,i)
			print("REMOVED: " .. word.text )

			for i=1, #scene.activeWords do
				print(scene.activeWords[i])
			end
		end
	end

	for i=1, #removeList do
		table.remove(scene.activeWords, removeList[i])
	end


	local activeWordCount = Utilities.tableItemCount(scene.activeWords)
	print("Count: " .. tostring(activeWordCount) )

	if activeWordCount < 3 then
		local text = levelDataWords1[nextWordIndex][1];
		local score = levelDataWords1[nextWordIndex][2];
		local newWord = Word(text, -50, 50, score)
		table.insert(scene.activeWords, newWord);
		print("ADDED: " .. newWord.text )
		nextWordIndex = nextWordIndex + 1

		
		if nextWordIndex >= Utilities.tableItemCount(levelDataWords1) then
			nextWordIndex = 1
		end


	end
end

local backgroundAngle = 0


-- This runs once per frame, and is meant for drawing code.
function scene:drawBackground()
	scene.super.drawBackground(self)
	-- Your code here



--	scene.wheel:draw(-200,-550)


	

	gfx.drawText("velocity: " .. tostring( scene.wheelLoop.delay), 0,0)
	
	--scene.wordTest:render()

	for i=1, #scene.activeWords do
		local word = scene.activeWords[i]
		word:render()
	end


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
		-- Your code here

--[[
local score = Noble.GameData.get("Score")
	score = score + change
	Noble.GameData.set("Score", score)
--]]

		-- Noble.GameData.score = Noble.GameData.score + change
		scene.score = scene.score + change
		scene.velocity = scene.velocity + (scene.crankAcceleration * change)

		if scene.velocity < scene.minVelocity then
			scene.velocity = scene.minVelocity
		elseif scene.velocity > scene.maxVelocity then
			scene.velocity = scene.maxVelocity
		end


		scene.wheelLoop.delay = scene.wheelLoop.delay + (change)



	end,
	crankDocked = function()						-- Runs once when when crank is docked.
		-- Your code here
	end,
	crankUndocked = function()						-- Runs once when when crank is undocked.
		-- Your code here
	end
}
