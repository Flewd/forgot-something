import 'libraries/noble/Noble'

import "utilities/time"
import 'utilities/Utilities'

import "CoreLibs/object"
import "CoreLibs/graphics"
import "CoreLibs/math"
import "CoreLibs/sprites"
import "CoreLibs/timer"

import 'scenes/ExampleScene'
import 'scenes/ExampleScene2'
import 'scenes/TitleScene'
import 'scenes/HamScene'
import 'scenes/IntroCutscene'

import "objects/Word"
import "objects/Actor"
import "objects/AnimatedActor"

Noble.Settings.setup({
	Difficulty = "Medium"
})

Noble.GameData.setup({
	Score = 0
})

Noble.showFPS = true

-- Noble.new(ExampleScene)
--Noble.new(TitleScene)
Noble.new(HamScene)

