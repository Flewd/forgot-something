local prompts = {}
local chosenWords = {}
local isApple = true

function AddChosenWord(value)
	table.insert(chosenWords, value)
end

function AddChosenWordAt(index,value)
	table.insert(chosenWords,index,value)
end

function ClearChosenWords()
	chosenWords = {}
end

function SetChosenWords(newWords)
	chosenWords = newWords
end

function GetChosenWords()
	return chosenWords
end

function SetPrompts(value)
	prompts = value
end

function GetPrompts()
	return prompts
end

function FlipContent()
	if  isApple == true then
		isApple = false
	else
		isApple = true
	end
end

function IsApple()
	return isApple
end