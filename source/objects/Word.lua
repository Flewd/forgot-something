local gfx <const> = playdate.graphics

class('Word').extends()

function Word:init(text, x, y, score)
    --Word.super.init()
    self.text = text
    self.posX = x
    self.posY = y
    self.score = score
end

function Word:update()


end

function Word:render()
    --renderShards(self)
    --renderExplosion(self)

    gfx.drawText(self.text, self.posX, self.posY)
    --gfx.drawText(self.posX, self.posX,self.posY + 40)

end
