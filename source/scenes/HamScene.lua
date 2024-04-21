-- MAC VSCODE BUILD AND RUN HOTKEY: CMD + Shift + P

local gfx <const> = playdate.graphics

SceneTemplate = {}
class("HamScene").extends(NobleScene)
local scene = HamScene

-- This is the background color of this scene.
scene.backgroundColor = Graphics.kColorBlack

local levelDataPhrase = "You forgot your _ while _ at the _"

local levelDataWords = {
	{
		{"Apple", 10},	-- row 1
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
	},
	{
		{"Working", 10},	-- row 2
		{"Running", 30},
		{"Driving", 50},
		{"Junk1", 1},
		{"Junk2", 1},
		{"Junk3", 1},
		{"Junk4", 1},
	},
	{
		{"Office", 10},	-- row 3
		{"Home", 30},
		{"Coffee Shop", 50},
		{"Junk1", 1},
		{"Junk2", 50},
	}
}

local signsText = {
	"You forgot your",
	"while",
	"at the",
}

local drawModeIndex = 1
local drawModes = {
	gfx.kDrawModeCopy,
	gfx.kDrawModeWhiteTransparent,
	gfx.kDrawModeBlackTransparent,
	gfx.kDrawModeFillWhite,
	gfx.kDrawModeFillBlack,
	gfx.kDrawModeXOR,
	gfx.kDrawModeNXOR,
	gfx.kDrawModeInverted,
}

local signs = {
	"assets/images/sign_youForgot",
	"assets/images/sign_while",
	"assets/images/sign_atThe",
}

local SELECTION_TIME = 8.5

local SCREEN_WIDTH = 400
local SCREEN_HEIGHT = 240

local NUMBER_OF_SCROLLING_WORDS = 3
local WORD_GAP = 225

local CONFIRM_WIDTH = 175
local CONFIRM_START = SCREEN_WIDTH/2 - CONFIRM_WIDTH/2
local CONFIRM_END = SCREEN_WIDTH/2 + CONFIRM_WIDTH/2

local MIN_VELOCITY = 1
local MAX_VELOCITY = 30

-- This runs when your scene's object is created, which is the
-- first thing that happens when transitining away from another scene.
function scene:init()
	scene.super.init(self)

	scene.score = 0
	scene.crankAcceleration = 0.1
	scene.win = false

	scene.velocity = 0
	scene.startRunning = false

	scene.nextWordIndex = 1
	scene.bringingInNewWord = false

	scene.activeWords = {}
	scene.levelWordSetIndex = 1
	scene.choosingWordIndex = 1

	scene.timer = SELECTION_TIME

	gfx.setImageDrawMode(gfx.kDrawModeCopy)
	
	for i=1, NUMBER_OF_SCROLLING_WORDS, 1 do
		scene:newWord()
	end

    scene.wordFont = gfx.font.new("assets/fonts/Sasser-Slab-EXBold");
	--scene.timerFont = gfx.font.new("assets/fonts/Sasser-Slab-Bold");
    -- kVariantNormal
    -- kVariantBold
    -- kVariantItalic
	gfx.setFont(scene.wordFont, gfx.font.kVariantNormal)

	scene.actors = {}
	scene.brainBg = Actor("assets/images/bgBrain02", 0, 0)
	scene.clock = Actor("assets/images/clock", -10, 180)

	scene.wheel = AnimatedActor("assets/images/wheel-table-400-240",0,0,100)
	scene.wheel.pause = true;

	scene.ham = AnimatedActor("assets/images/hamsteridle-table-56-80",170,150,500)
	scene.ham.useVelocity = false
	--scene.ham = AnimatedActor("assets/images/hamster-table-116-78",150,150,100)
	scene.track1 = AnimatedActor("assets/images/activeSign-table-303-115",50,0,100)

	scene.sign = Actor(signs[1], 110, 10)

	table.insert(scene.actors, scene.wheel)
	table.insert(scene.actors, scene.ham)
	table.insert(scene.actors, scene.track1)

	SetPrompts(signsText)
	ClearChosenWords()
end

function scene:newWord()
	local levelWordSet = levelDataWords[scene.levelWordSetIndex]
	local text = levelWordSet[scene.nextWordIndex][1];
	local score = levelWordSet[scene.nextWordIndex][2];

	local xPos = scene:leftMostWordPos() - WORD_GAP

	if table.getsize(scene.activeWords) <= 0 then 
		xPos = 0;
	end

	table.insert(scene.activeWords, Word(text, xPos, 80, score));
	scene.nextWordIndex = scene.nextWordIndex + 1

	local wordDataCount = Utilities.tableItemCount(levelWordSet)
	if scene.nextWordIndex >= wordDataCount then
		scene.nextWordIndex = 1
	end

	print("Created Word: " .. text .. " from set:" .. scene.levelWordSetIndex)
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
	scene.timer = SELECTION_TIME
end

-- This runs once per frame.
function scene:update()
	scene.super.update(self)

	UpdateTimers()

	if scene.velocity > 0 and scene.win == false then

		if scene.startRunning == false then
			scene.startRunning = true
			scene.wheel.pause = false;
			
			scene.ham:setImageTable("assets/images/hamster-table-116-78")
			scene.ham.useVelocity = true
			scene.ham.posY = 150
			scene.ham.posX = 150

			scene.timer = SELECTION_TIME
		end

		scene.timer = scene.timer - DeltaTimeSeconds()

		if scene.timer <= 0 then 
			scene.timer = 0

			scene:forceLockInWord()
		end

		--print("Start coroutine")
		while scene.bringingInNewWord do
			local dt = coroutine.yield() -- the most important part
			scene:newWordUpdate()
		end
		--print("End coroutine")

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
	


	
end

-- This runs once per frame, and is meant for drawing code.
function scene:drawBackground()
	scene.super.drawBackground(self)
	scene.brainBg:render()

	gfx.setFont(scene.wordFont, gfx.font.kVariantNormal)
	for i=1, #scene.activeWords do
		local word = scene.activeWords[i]
		word:render()
	end

	for i=1, #scene.actors do
		scene.actors[i]:setVelocity(scene.velocity)
		scene.actors[i]:render()
	end

	--gfx.setColor(gfx.kColorWhite) -- Setting the draw color to white
	--gfx.drawLine(CONFIRM_START,0,CONFIRM_START,200)
	--gfx.drawLine(CONFIRM_END,0,CONFIRM_END,200)

	scene.sign:render()

	scene.clock:render()
	--gfx.setFont(scene.timerFont, gfx.font.kVariantNormal)
	gfx.drawText(math.floor(scene.timer), 10, 205)

end

function scene:waitSeconds(seconds)

	local timer = 0.
	while timer < seconds do
		timer = timer + DeltaTimeSeconds()
		coroutine.yield()
	end
end

function scene:newWordUpdate()

	for i=1, #scene.activeWords do
		scene.activeWords[i] = nil
	end

	-- increment the level data set index
	scene.levelWordSetIndex = scene.levelWordSetIndex + 1
	scene.nextWordIndex = 1

	for i=1, NUMBER_OF_SCROLLING_WORDS, 1 do
		scene:newWord()
	end
	--scene:waitSeconds(1)
	
	scene.bringingInNewWord = false;
	scene.sign = Actor(signs[scene.levelWordSetIndex], 110, 10)

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

function scene:forceLockInWord()

	local midpoint = SCREEN_WIDTH/2
	local closestWord = scene.activeWords[1]
	local dist = math.abs(closestWord.posX - midpoint) 

	for i=2, #scene.activeWords do
		local word = scene.activeWords[i]
		local wordDist = math.abs(word.posX - midpoint) 
		if wordDist < dist then
			dist = wordDist
			closestWord = word
		end
	end

	AddChosenWord(closestWord)
	print("Locked in: " .. closestWord.text .. " at word set " .. scene.levelWordSetIndex)

	if(scene.levelWordSetIndex > 2) then
		scene.win = true
		Noble.transition(ResultsScene, nil, Noble.Transition.DIP_TO_BLACK);
	else
		scene.bringingInNewWord = true;
		scene.timer = SELECTION_TIME
		scene.velocity = MIN_VELOCITY
	end

end

function scene:tryLockInWord()
	for i=1, #scene.activeWords do
		local word = scene.activeWords[i]
		if word.posX >= CONFIRM_START and word.posX <= CONFIRM_END then
			
			AddChosenWord(word)
		
			--table.insert(scene.chosenWords, scene.choosingWordIndex, word)
			print("Locked in: " .. word.text .. " at word set " .. scene.levelWordSetIndex)

			if(scene.levelWordSetIndex > 2) then
				scene.win = true
				Noble.transition(ResultsScene, nil, Noble.Transition.DIP_TO_BLACK);
			else
				scene.bringingInNewWord = true;
				scene.timer = SELECTION_TIME
				scene.velocity = MIN_VELOCITY
			end
		end
	end
end

-- Define the inputHander for this scene here, or use a previously defined inputHandler.
-- scene.inputHandler = someOtherInputHandler
-- OR
scene.inputHandler = {

	-- Crank
	cranked = function(change, acceleratedChange)	-- Runs when the crank is rotated. See Playdate SDK documentation for details.
		scene.score = scene.score + change
		scene.velocity = scene.velocity + (scene.crankAcceleration * change)

		if scene.velocity < MIN_VELOCITY then
			scene.velocity = MIN_VELOCITY
		elseif scene.velocity > MAX_VELOCITY then
			scene.velocity = MAX_VELOCITY
		end

		--scene.wheel.frameTime = scene.wheel.frameTime + (change)
	end,
	crankDocked = function()						-- Runs once when when crank is docked.
	end,
	crankUndocked = function()						-- Runs once when when crank is undocked.
	end,

	-- A button
	AButtonDown = function()			-- Runs once when button is pressed.
		scene:tryLockInWord()
	end,
	AButtonHold = function()			-- Runs every frame while the player is holding button down.
	end,
	AButtonHeld = function()			-- Runs after button is held for 1 second.
	end,
	AButtonUp = function()				-- Runs once when button is released.
	end,

	-- B button
	BButtonDown = function()
		scene:tryLockInWord()
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
		--[[
		drawModeIndex = drawModeIndex + 1
		if drawModeIndex > 8 then 
			drawModeIndex = 1
		end

		print(drawModes[drawModeIndex])
		]]
		
	end,
	upButtonHold = function()
	end,
	upButtonUp = function()
	end,

	-- D-pad down
	downButtonDown = function()
		--[[
		drawModeIndex = drawModeIndex - 1
		if drawModeIndex < 1 then 
			drawModeIndex = 8
		end
		print(drawModes[drawModeIndex])
		]]
	end,
	downButtonHold = function()
	end,
	downButtonUp = function()
	end
}
