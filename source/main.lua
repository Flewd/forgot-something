import 'libraries/noble/Noble'

import "utilities/global"
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
import 'scenes/ResultsScene'

import "objects/Word"
import "objects/Actor"
import "objects/AnimatedActor"

Noble.Settings.setup({
	Difficulty = "Medium"
})

Noble.GameData.setup({
})

Noble.showFPS = true
playdate.display.setRefreshRate(50) -- Sets framerate to 50 fps

-- Noble.new(ExampleScene)
--Noble.new(TitleScene)
Noble.new(IntroCutscene)