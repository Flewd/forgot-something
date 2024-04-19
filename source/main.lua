import 'libraries/noble/Noble'

import 'utilities/Utilities'

import 'scenes/ExampleScene'
import 'scenes/ExampleScene2'
import 'scenes/GameStartScene'

Noble.Settings.setup({
	Difficulty = "Medium"
})

Noble.GameData.setup({
	Score = 0
})

Noble.showFPS = true

-- Noble.new(ExampleScene)
Noble.new(GameStartScene)