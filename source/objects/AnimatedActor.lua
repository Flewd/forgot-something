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
end

function AnimatedActor:update()


end

function AnimatedActor:render()
    self.loop.delay = self.frameTime
    self.loop:draw(self.posX,self.posY)
   -- gfx.drawText(self.frameTime, self.posX,self.posY - 10)
end

function AnimatedActor:setVelocity(velocity)
   
    --normalize: (val - min) / (max - min)
    local normalizedVelocity = (velocity - 1) / (40 - 1)

-- 300 is slowest frame delay, 4 is fastes frame delay
    self.frameTime = playdate.math.lerp(100,10,normalizedVelocity)
end