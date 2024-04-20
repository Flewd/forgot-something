-- MAC VSCODE BUILD AND RUN HOTKEY: CMD + Shift + P

local gfx <const> = playdate.graphics

SceneTemplate = {}
class("HamScene").extends(NobleScene)
local scene = HamScene

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

local SCREEN_WIDTH = 400
local SCREEN_HEIGHT = 240

local NUMBER_OF_SCROLLING_WORDS = 3
local WORD_GAP = 80

-- This runs when your scene's object is created, which is the
-- first thing that happens when transitining away from another scene.
function scene:init()
	scene.super.init(self)

	scene.score = 0
	scene.crankAcceleration = 0.1

	scene.minVelocity = 1
	scene.maxVelocity = 40

	scene.velocity = scene.minVelocity

	scene.nextWordIndex = 1
	scene.activeWords = {}

	for i=1, NUMBER_OF_SCROLLING_WORDS, 1 do
		scene:newWord()
	end

    local font = gfx.font.new("assets/fonts/diamond_20");
    -- kVariantNormal
    -- kVariantBold
    -- kVariantItalic
	gfx.setFont(font, gfx.font.kVariantNormal)


	scene.actors = {}
	scene.wheel = AnimatedActor("assets/images/wheel-table-400-240",0,0,100)
	scene.ham = AnimatedActor("assets/images/hamster-table-116-78",150,150,100)

	table.insert(scene.actors, scene.wheel)
	table.insert(scene.actors, scene.ham)

end

function scene:newWord()
	local text = levelDataWords1[scene.nextWordIndex][1];
	local score = levelDataWords1[scene.nextWordIndex][2];

	local xPos = scene:leftMostWordPos() - WORD_GAP

	table.insert(scene.activeWords, Word(text, xPos, 50, score));
	scene.nextWordIndex = scene.nextWordIndex + 1

	local wordDataCount = Utilities.tableItemCount(levelDataWords1)
	if scene.nextWordIndex >= wordDataCount then
		scene.nextWordIndex = 1
	end

	print("Created Word: " .. text)
end

function scene:leftMostWordPos()

	local lowestXPos = 0

	for i=1, #scene.activeWords do
		local word = scene.activeWords[i]
		if word.posX < lowestXPos then
			lowestXPos = word.posX
		end
	end

	return lowestXPos
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

	gfx.setImageDrawMode(gfx.kDrawModeNXOR)

	local removeList = {}

	for i=1, #scene.activeWords do
		local word = scene.activeWords[i]
		word.posX = word.posX + scene.velocity
		word:update()

		if word.posX > SCREEN_WIDTH then
			table.insert(removeList,i)
		end
	end

	for i=1, #removeList do
		table.remove(scene.activeWords, removeList[i])
	end

	local activeWordCount = Utilities.tableItemCount(scene.activeWords)
	if activeWordCount < NUMBER_OF_SCROLLING_WORDS then
		scene:newWord()
	end
end

-- This runs once per frame, and is meant for drawing code.
function scene:drawBackground()
	scene.super.drawBackground(self)

	for i=1, #scene.actors do
		scene.actors[i]:setVelocity(scene.velocity)
		scene.actors[i]:render()
	end

	for i=1, #scene.activeWords do
		local word = scene.activeWords[i]
		word:render()
	end

	--gfx.drawText("velocity: " .. tostring( scene.wheel.frameTime), 0,0)
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

	-- A button
	AButtonDown = function()			-- Runs once when button is pressed.
	end,
	AButtonHold = function()			-- Runs every frame while the player is holding button down.
	end,
	AButtonHeld = function()			-- Runs after button is held for 1 second.
	end,
	AButtonUp = function()				-- Runs once when button is released.
	end,

	-- B button
	BButtonDown = function()
	end,
	BButtonHeld = function()
	end,
	BButtonHold = function()
	end,
	BButtonUp = function()
	end,

	-- D-pad left
	leftButtonDown = function()
	end,
	leftButtonHold = function()
	end,
	leftButtonUp = function()
	end,

	-- D-pad right
	rightButtonDown = function()
	end,
	rightButtonHold = function()
	end,
	rightButtonUp = function()
	end,

	-- D-pad up
	upButtonDown = function()
	end,
	upButtonHold = function()
	end,
	upButtonUp = function()
	end,

	-- D-pad down
	downButtonDown = function()
	end,
	downButtonHold = function()
	end,
	downButtonUp = function()
	end,

	-- Crank
	cranked = function(change, acceleratedChange)	-- Runs when the crank is rotated. See Playdate SDK documentation for details.
		scene.score = scene.score + change
		scene.velocity = scene.velocity + (scene.crankAcceleration * change)

		if scene.velocity < scene.minVelocity then
			scene.velocity = scene.minVelocity
		elseif scene.velocity > scene.maxVelocity then
			scene.velocity = scene.maxVelocity
		end

		--scene.wheel.frameTime = scene.wheel.frameTime + (change)
	end,
	crankDocked = function()						-- Runs once when when crank is docked.
	end,
	crankUndocked = function()						-- Runs once when when crank is undocked.
	end
}
