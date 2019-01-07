require("invaders")

-- This allows e.g. ZeroBrane to show output on the console
-- Otherwise, stdout is buffered until the process finishes.
io.stdout:setvbuf("no")

-- moonshine is a library for shader effects
local moonshine = require 'moonshine'

local invaders = initInvaders()

local ticks = 0

local bullet = {}
bullet.active = false
bullet.x = 0
bullet.y = 0

for tmp = 0, 359 do
  print ( math.sin( math.rad(tmp) ) )
end

if 1 == 2 then os.exit() end

function createBeeSprite()
  
  local sprite = {}
  sprite.images = {}
  for f = 1, 6 do
    sprite.images[f] = love.graphics.newImage("sprites/bee/" .. f .. ".png")
  end
  
  sprite.frame = 1
  sprite.image = sprite.images[sprite.frame]
  
  sprite.x = 0
  sprite.y = 0
  sprite.direction = 1;
  
  sprite.draw = function()
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(sprite.image, sprite.x, sprite.y, math.rad(180), 0.5 * sprite.direction, 0.5, sprite.image:getWidth() / 2, sprite.image:getHeight() / 2)
    --love.graphics.circle('fill', sprite.x, sprite.y, 10)
  end
  
  return sprite
  
end


function love.load()
  
  --love.window.setFullscreen(true)
  
  effect = moonshine(moonshine.effects.boxblur).chain(moonshine.effects.scanlines)
  chompy = love.graphics.newImage("sprites/Rayquaza.png")
  
  bee_sprite = createBeeSprite()
  
  particle1 = love.graphics.newImage("sprites/particles/particle5.png")
  psystem = love.graphics.newParticleSystem(particle1, 1000)
end


function love.draw()
  
  -- Get the time right now
  local now = os.date("*t")
  
  local hour = now['hour'] % 12
  local minute = now['min']
  local second = now['sec']
  
  -- Calculate the angles of each hand (zero degrees 00:00)
  local hour_angle = (360 / 720) * (hour * 60 + minute)
  local minute_angle = (360 / 60) * minute
  local second_angle = (360 / 60) * second
  
  love.graphics.setColor(1, 1, 1, 1)
  
  effect.draw( function() love.graphics.draw(
        chompy,
        love.graphics.getWidth() / 2, love.graphics.getHeight() / 2,
        0,
        2, 2,
        chompy:getWidth() / 2, chompy:getHeight() / 2)
      end)
  
  love.graphics.push()
  
  -- Translate the co-ordinate system so that (0,0) is the centre of the screen.
  -- Rotate the co-ordinate system so that zero degrees is straight up.
  love.graphics.translate(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2, 50, 50)
  love.graphics.rotate( math.rad(180) )

  -- Draw the tick marks
  love.graphics.setColor(1, 1, 1)
  for tick = 0, 11 do
    if tick % 3 == 0 then
      love.graphics.rectangle('line', -1, 195, 2, 20)
    else
      love.graphics.rectangle('line', -1, 210, 2, 10)
    end
    love.graphics.rotate(math.rad(30))
  end  
  -- Second hand
  love.graphics.push()
    love.graphics.setColor(0.9,0.4,0.4)
    love.graphics.rotate(math.rad(second_angle))
    love.graphics.rectangle('fill', -3, 0, 6, 200)
    love.graphics.rectangle('line', -3, 200, 6, 10)
  love.graphics.pop()
  
  -- Minute hand
  love.graphics.push()
    love.graphics.setColor(0.2,0.2,1)
    love.graphics.rotate(math.rad(minute_angle))
    love.graphics.rectangle('fill', -10, 0, 20, 180)
    love.graphics.rectangle('line', -10, 180, 20, 10)
  love.graphics.pop()
  
  -- Hour hand
  love.graphics.push()
    love.graphics.setColor(0.3,0.3,1)
    love.graphics.rotate(math.rad(hour_angle))
    love.graphics.rectangle('fill', -10, 0, 20, 120)
    love.graphics.rectangle('line', -10, 120, 20, 10)
  love.graphics.pop()

  bee_sprite.draw()
  
  love.graphics.pop()
  
  love.graphics.push()
    love.graphics.translate(30 + math.sin(math.rad(ticks)) * 70, 0)
    drawInvaders()
  love.graphics.pop()
  
  if bullet.active == true then
    love.graphics.rectangle('fill', bullet.x, bullet.y, 3, 6)
  end
  
  love.graphics.draw(psystem)

end

function love.update(dt)
  
  ticks = ticks + 1
  
  bee_sprite.x = bee_sprite.x + (6 * bee_sprite.direction)
  
  if bee_sprite.x < -2000 or bee_sprite.x > 2000 then
    bee_sprite.direction = bee_sprite.direction * -1
  end
  
  bee_sprite.y = math.sin( math.rad(ticks * 5) ) * 50
  
  if ticks % 5 == 0 then
    bee_sprite.frame = bee_sprite.frame + 1
    if bee_sprite.frame == 7 then bee_sprite.frame = 1 end
    bee_sprite.image = bee_sprite.images[bee_sprite.frame]
    
  end
  
  if ticks % 3 == 0 then
    updateInvaders()
  end

  if bullet.active == true then
    bullet.y = bullet.y - 10
    if bullet.y <= 0 then bullet.active = false end
    
    local x_offset = 30 + math.sin(math.rad(ticks)) * 70
    local y_offset = 0
    
    local hit = collisionWith(bullet.x - x_offset, bullet.y - y_offset)
    
    if hit ~= false then
      print('Hit at', math.floor(hit.x), math.floor(hit.y))
      hit.visible = false
      bullet.active = false
      
      -- Set up the particle emitter at the point of collision and start it.
      psystem:setPosition(hit.x + x_offset + 22, hit.y + y_offset + 22)
          
      psystem:setParticleLifetime(1, 2) -- Particles live at least 2s and at most 5s.
      psystem:setEmissionRate(1000)
      psystem:setEmitterLifetime(0.25)
      psystem:setSizeVariation(1)
      psystem:setSpeed(250)
      psystem:setLinearAcceleration(-400, 200, 400, 400) -- Random movement in all directions.
      psystem:setLinearDamping(3, 3)
      psystem:setTangentialAcceleration(40, 100)
      psystem:setEmissionArea('uniform', 5, 5, math.rad(359), true)
      psystem:setColors(255, 255, 255, 255, 255, 0, 255, 0.9) -- Fade to transparency.
      psystem:emit(64)
          
      psystem:start()

    end
  end
  
  psystem:update(dt)

end
  
function love.mousepressed(x, y, button, isTouch)
  
  if bullet.active == false then
    bullet.active = true
    bullet.x = x
    bullet.y = 550
  end
  
  -- match the transform used to a) offset the batch of aliens, and b) scale the aliens
  --local t = love.math.newTransform(100 + math.sin(math.rad(ticks)) * 70, 50, 0, 2, 2)
  --local newx, newy = t:transformPoint(x, y)
  
  --print(x,  ', ',  y,  ', ',  math.floor(newx),  ', ',  math.floor(newy),  ', ',  button,  hit)
  --print(x,  ', ',  y,  ', ',  button,  hit)
end

function love.keypressed(key)
  if key == 'escape' then
    os.exit()
  end
end
