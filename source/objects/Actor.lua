local gfx <const> = playdate.graphics

class('Actor').extends()

function Actor:init(imagePath, x, y)
    --Word.super.init()
    self.imagePath = imagePath
    self.posX = x
    self.posY = y

    self.image = gfx.image.new(imagePath)
end

function Actor:update()


end

function Actor:render()
    self.image:draw(self.posX,self.posY)

--    self.loop.delay = self.frameTime
 --   self.loop:draw(self.posX,self.posY)
 --   gfx.drawText(self.frameTime, self.posX,self.posY - 10)
end
