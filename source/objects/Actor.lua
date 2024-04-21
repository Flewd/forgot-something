local gfx <const> = playdate.graphics

class('Actor').extends()

function Actor:init(imagePath, x, y)
    --Word.super.init()
    self.imagePath = imagePath
    self.posX = x
    self.posY = y
    self.scale = 1

    self.image = gfx.image.new(imagePath)
    self.scaleAnchorX = 2
    self.scaleAnchorY = 2
end

function Actor:update()

end

function Actor:render()
   -- self.image:draw(self.posX,self.posY)

    local w, h = self.image:getSize()

    local widthDiff = (w * self.scale) - w
    local heightDiff = (h * self.scale) - h

    self.image:drawScaled(self.posX - (widthDiff/self.scaleAnchorX) ,self.posY - (heightDiff/self.scaleAnchorY), self.scale)


--    self.loop.delay = self.frameTime
 --   self.loop:draw(self.posX,self.posY)
 --   gfx.drawText(self.frameTime, self.posX,self.posY - 10)
end
