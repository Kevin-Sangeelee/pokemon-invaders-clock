function initInvader(sheet, quad, row, column)
  
  invader = {}
  
  invader.sheet = sheet
  invader.quad = quad
  invader.x = (column * 60)
  invader.y = (row * 60)
  invader.row = row
  invader.column = column
  invader.visible = true
  
  invader.draw =
    function(i)
      love.graphics.draw(i.sheet, i.quad, i.x, i.y, 0, 2, 2)
      --love.graphics.rectangle('line', i.x, i.y, 44, 44)
    end
  
  invader.collides =
    function(i, x, y)
      if x > (i.x + 4) and x < (i.x + 40) and y > i.y and y < (i.y + 44) then
        return true;
      end
      return false;
    end
  
  return invader
end

function initInvaders()
  
  local sprite_sheet = love.graphics.newImage("sprites/bugs_invaders.png")
  --local quad = love.graphics.newQuad(8, 6, 22, 22, sprite_sheet:getDimensions())
  local quad = love.graphics.newQuad(115, 56, 22, 22, sprite_sheet:getDimensions())
  
  invaders = {}
  
  invaders.ticks = 1

  for row = 1, 5 do
    invaders[row] = {}
    for column = 1, 10 do
      invaders[row][column] = initInvader(sprite_sheet, quad, row, column)
    end
  end
  
  return invaders

end


function drawInvaders()
  for i = 1, #invaders do
    local row = invaders[i]
    for j = 1, #row do
      if row[j].visible == true then
        row[j]:draw()
      end
    end
  end
end

function updateInvaders()
  
  local ticks = invaders.ticks
  
  for i = 1, #invaders do
    local row = invaders[i]
    for j = 1, #row do
      row[j].x = row[j].x + ( math.sin( math.rad((ticks + i) * 28.8) ) * 2)
      row[j].y = row[j].y + ( math.cos( math.rad((ticks - j) * 28.8) ) * 2)
    end
  end
  
  invaders.ticks = invaders.ticks + 1
end


function collisionWith(x, y)
  
  for i = 1, #invaders do
    local row = invaders[i]
    for j = 1, #row do
      if row[j].visible == true and row[j]:collides(x, y) == true then
        return row[j]
      end
    end
  end
  
  return false
end

function dumpCoords(row, column)
end
