  function drawClock(now)
    
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

  love.graphics.pop()
  
end
