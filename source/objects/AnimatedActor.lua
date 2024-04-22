local gfx <const> = playdate.graphics

class('AnimatedActor').extends()

function AnimatedActor:init(imageTablePath, x, y, frameTime)
    --Word.super.init()
    self.imageTablePath = imageTablePath
    self.posX = x
    self.posY = y
    self.frameTime = frameTime

    self.imageTable = gfx.imagetable.new(imageTablePath)
    self.loop = gfx.animation.loop.new(frameTime, self.imageTable, true)
    self.useVelocity = true
    self.pause = false
end

function AnimatedActor:update()
    
end

function AnimatedActor:setFrame(value)
    self.loop.frame = value
end

function AnimatedActor:setImageTable(imageTablePath)
    self.imageTable = gfx.imagetable.new(imageTablePath)
    self.loop = gfx.animation.loop.new(frameTime, self.imageTable, true)
end

function AnimatedActor:render()
    if self.pause == false then 
        self.loop.delay = self.frameTime
    else
        self.loop.delay = 999999999999
    end
    self.loop:draw(self.posX,self.posY)
-- gfx.drawText(self.frameTime, self.posX,self.posY - 10)
    
end

function AnimatedActor:setVelocity(velocity)
    if self.useVelocity then
        --normalize: (val - min) / (max - min)
        local normalizedVelocity = (velocity - 1) / (30 - 1)

    -- 300 is slowest frame delay, 4 is fastes frame delay
        self.frameTime = playdate.math.lerp(150,30,normalizedVelocity)    
    end
end