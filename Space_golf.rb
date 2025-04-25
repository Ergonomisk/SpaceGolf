require 'ruby2d'

set title: "Space_golf", background: '#39FF14'
set resizable: true
set fullscreen: false
set width: 720 
set height: 405
@play_area= Rectangle.new(x: 0, y: 0, width: 720, height: 405, color: '#281c3c')
@ball = Circle.new(x: 20, y: 202.5, radius: 10, sectors: 32, color: '#edf1e6', z: 5)
@speed = 6
@angle = 0
@menu_visible = false 
@strokes = 0
@victory_text = nil
@stroketext = nil

#audio

@goal_sound = Sound.new('golf-ball-landing-in-hole-joshua-chivers-1-00-01.mp3')
@putt_sound = Sound.new('golf-14-94167.mp3')
@background_music = Music.new('ready-set-drift-michael-grubb-main-version-24555-02-59.mp3')
@background_music.play
@background_music.volume = 20
@background_music.loop = true
@menu_visible = true
# Variables that store line elements
@dotted_line = []
@opposite_line = nil
@dragging = false
@target_x = nil
@target_y = nil
#Varibles that store obstacle elements
@goal = Circle.new(x: 0, y: 0, radius: 11, sectors: 32, color: 'orange')
Text.new('Welcome to the secret area, to try out you moves!', x: 120, y: 60, style: 'bold', size: 20, color: 'white',)
@obstacle1 = Rectangle.new(x: 0, y: 0, width: 720, height: 60, color: '#39FF14')
@obstacle2 = Rectangle.new(x: 100, y: 100, width: 50, height: 40, color: '#39FF14')
@obstacle3 = Rectangle.new(x: 200, y: 200, width: 50, height: 20, color: 'blue')
@obstacle4 = Rectangle.new(x: 300, y: 300, width: 50, height: 60, color: 'red')
@obstacle5 = Rectangle.new(x: 400, y: 400, width: 50, height: 30, color: 'yellow')
@obstacle6 = Rectangle.new(x: 500, y: 100, width: 50, height: 100, color: 'purple')
@obstacle7 = Rectangle.new(x: 600, y: 300, width: 50, height: 40, color: 'orange')

@block_arr = [
  @obstacle1,
  @obstacle2,
  @obstacle3,
  @obstacle4,
  @obstacle5,
  @obstacle6,
  @obstacle7,
  Rectangle.new(x: 0, y: 0, width: 10, height: 405, color: '#39FF14', z: 21), #left border
  Rectangle.new(x: 0, y: 0, width: 720, height: 10, color: '#39FF14', z: 21), #top border
  Rectangle.new(x: 710, y: 0, width: 10, height: 405, color: '#39FF14', z: 21), #right border
  Rectangle.new(x: 0, y: 395, width: 720, height: 10, color: '#39FF14', z: 21) #Lower border
]
#start menu
@menu = Rectangle.new(x: 0, y: 0, width: 720, height: 405, color: '#39FF14', z:21)
@quit_button = Rectangle.new(x: 0, y: 0, width: 50, height: 23, color: 'red', z:21)
@quit_text = Text.new('Quit?', x: 0, y: 0, style: 'bold', size: 20, color: 'black', z:21)
@title = Text.new('SPACE GOLF', x: 220, y: 20, style: 'bold', size: 40, color: 'black', z:25)
@menu_text = Text.new('Choose a level from 1-5 using your keypad', x: 160, y: 80, style: 'bold', size: 20, color: 'black', z:21)




on :key_down do |event|
  if event.key == 'escape'
    if @menu_visible
      # Remove menu elements
      @menu.remove
      @quit_button.remove
      @quit_text.remove
      @stroketext&.remove
      @menu_text&.remove
      @victory_text&.remove 
      @menu_text.remove
      @menu_visible = false

      
    else
      # Create menu elements
      @menu = Rectangle.new(x: 0, y: 0, width: 720, height: 405, color: '#39FF14', z:21)
      @quit_button = Rectangle.new(x: 0, y: 0, width: 50, height: 23, color: 'red', z:21)
      @quit_text = Text.new('Quit?', x: 0, y: 0, style: 'bold', size: 20, color: 'black', z:21)
      @menu_text = Text.new('Choose a level from 1-5 using your keypad', x: 160, y: 80, style: 'bold', size: 20, color: 'black', z:21)
      @menu_visible = true
      
    end
  end
  # level 1
  if event.key == '1'
    if @menu_visible
      @strokes = 0
      @obstacle1.remove
      @obstacle2.remove
      @obstacle3.remove
      @obstacle4.remove
      @obstacle5.remove
      @obstacle6.remove
      @obstacle7.remove
      @obstacle1 = Rectangle.new(x: 0, y: 0, width: 720, height: 142.5, color: '#39FF14')
      @obstacle2 = Rectangle.new(x: 0, y: 262.5, width: 720, height: 140, color: '#39FF14')
      @obstacle3 = Rectangle.new(x: 0, y: 0, width: 40, height: 405, color: '#39FF14')
      @obstacle4 = Rectangle.new(x: 680, y: 0, width: 40, height: 405, color: '#39FF14')
      @obstacle5 = Rectangle.new(x: 0, y: 0, width: 0, height: 0, color: '#39FF14')
      @obstacle6 = Rectangle.new(x: 0, y: 0, width: 0, height: 0, color: '#39FF14')
      @obstacle7 = Rectangle.new(x: 0, y: 0, width: 0, height: 0, color: '#39FF14')
      @goal.x = 620
      @goal.y = 202.5
      @ball.x = 100
      @ball.y = 202.5
      @speed = 0

      @block_arr[0] = @obstacle1
      @block_arr[1] = @obstacle2
      @block_arr[2] = @obstacle3
      @block_arr[3] = @obstacle4
      @block_arr[4] = @obstacle5
      @block_arr[5] = @obstacle6
      @block_arr[6] = @obstacle7
      @menu.remove
      @quit_button.remove
      @quit_text.remove
      @victory_text&.remove 
      @stroketext&.remove
      @menu_text&.remove
      @menu_visible = false
    end
  end
#level 2
  if event.key == '2'
    if @menu_visible
      @strokes = 0
      @obstacle1.remove
      @obstacle2.remove
      @obstacle3.remove
      @obstacle4.remove
      @obstacle5.remove
      @obstacle6.remove
      @obstacle7.remove

      @obstacle1 = Rectangle.new(x: 0, y: 0, width: 720, height: 142.5, color: '#39FF14')
      @obstacle2 = Rectangle.new(x: 0, y: 262.5, width: 720, height: 140, color: '#39FF14')
      @obstacle3 = Rectangle.new(x: 0, y: 0, width: 40, height: 405, color: '#39FF14')
      @obstacle4 = Rectangle.new(x: 680, y: 0, width: 40, height: 405, color: '#39FF14')
      @obstacle5 = Rectangle.new(x: 300, y: 192.5, width: 80, height: 80, color: '#39FF14')
      @obstacle6 = Rectangle.new(x: 0, y: 0, width: 0, height: 0, color: '#39FF14')
      @obstacle7 = Rectangle.new(x: 0, y: 0, width: 0, height: 0, color: '#39FF14')

      @goal.x = 620
      @goal.y = 202.5
      @ball.x = 100
      @ball.y = 202.5
      @speed = 0

      @block_arr[0] = @obstacle1
      @block_arr[1] = @obstacle2
      @block_arr[2] = @obstacle3
      @block_arr[3] = @obstacle4
      @block_arr[4] = @obstacle5
      @block_arr[5] = @obstacle6
      @block_arr[6] = @obstacle7
      @menu.remove
      @quit_button.remove
      @quit_text.remove
      @victory_text&.remove
      @stroketext&.remove
      @menu_text&.remove
      @menu_visible = false
    end
  end
#level 3
  if event.key == '3'
    if @menu_visible
      @strokes = 0
      @obstacle1.remove
      @obstacle2.remove
      @obstacle3.remove
      @obstacle4.remove
      @obstacle5.remove
      @obstacle6.remove
      @obstacle7.remove

      @obstacle1 = Rectangle.new(x: 0, y: 0, width: 720, height: 142.5, color: '#39FF14')
      @obstacle2 = Rectangle.new(x: 0, y: 262.5, width: 400, height: 140, color: '#39FF14')
      @obstacle3 = Rectangle.new(x: 0, y: 0, width: 40, height: 405, color: '#39FF14')
      @obstacle4 = Rectangle.new(x: 660, y: 0, width: 60, height: 405, color: '#39FF14')
      @obstacle5 = Rectangle.new(x: 300, y: 192.5, width: 80, height: 80, color: '#39FF14')
      @obstacle6 = Rectangle.new(x: 0, y: 262.5, width: 560, height: 30, color: '#39FF14')
      @obstacle7 = Rectangle.new(x: 0, y: 365, width: 720, height: 40, color: '#39FF14')

      @goal.x = 425
      @goal.y = 325
      @ball.x = 100
      @ball.y = 202.5
      @speed = 0

      @block_arr[0] = @obstacle1
      @block_arr[1] = @obstacle2
      @block_arr[2] = @obstacle3
      @block_arr[3] = @obstacle4
      @block_arr[4] = @obstacle5
      @block_arr[5] = @obstacle6
      @block_arr[6] = @obstacle7
      @menu.remove
      @quit_button.remove
      @quit_text.remove
      @victory_text&.remove 
      @stroketext&.remove
      @menu_text&.remove
      @menu_visible = false
    end
  end
#level 4
  if event.key == '4'
    if @menu_visible
      @strokes = 0
      @obstacle1.remove
      @obstacle2.remove
      @obstacle3.remove
      @obstacle4.remove
      @obstacle5.remove
      @obstacle6.remove
      @obstacle7.remove
      @obstacle1 = Rectangle.new(x: 10, y: 10, width: 500, height: 120, color: '#39FF14')
      @obstacle2 = Rectangle.new(x: 0, y: 0, width: 100, height: 405, color: '#39FF14')
      @obstacle3 = Rectangle.new(x: 60, y: 235, width: 660, height: 160, color: '#39FF14')
      @obstacle4 = Rectangle.new(x: 460, y: 180, width: 50, height: 60, color: '#39FF14') #block
      @obstacle5 = Rectangle.new(x: 10, y: 10, width: 560, height: 80, color: '#39FF14')
      @obstacle6 = Rectangle.new(x: 650, y: 0, width: 100, height: 405, color: '#39FF14')
      @obstacle7 = Rectangle.new(x: 300, y: 100, width: 50, height: 80, color: '#39FF14')
      @ball.x = 140
      @ball.y = 180
      @goal.x = 610
      @goal.y = 40
      @speed = 0
      @block_arr[0] = @obstacle1
      @block_arr[1] = @obstacle2
      @block_arr[2] = @obstacle3
      @block_arr[3] = @obstacle4
      @block_arr[4] = @obstacle5
      @block_arr[5] = @obstacle6
      @block_arr[6] = @obstacle7
      @menu.remove
      @quit_button.remove
      @quit_text.remove
      @victory_text&.remove 
      @stroketext&.remove
      @menu_text&.remove
      @menu_visible = false
    end
  end
#level 5
  if event.key == '5'
    if @menu_visible
      @strokes = 0
      @obstacle1.remove
      @obstacle2.remove
      @obstacle3.remove
      @obstacle4.remove
      @obstacle5.remove
      @obstacle6.remove
      @obstacle7.remove

      @obstacle1 = Rectangle.new(x: 0, y: 0, width: 720, height: 100, color: '#39FF14')  # Top barrier
      @obstacle2 = Rectangle.new(x: 150, y: 150, width: 500, height: 100, color: '#39FF14')  # Mid platform
      @obstacle3 = Rectangle.new(x: 0, y: 0, width: 50, height: 405, color: '#39FF14')  # Left side wall
      @obstacle4 = Rectangle.new(x: 650, y: 0, width: 70, height: 405, color: '#39FF14')  # Right side wall
      @obstacle5 = Rectangle.new(x: 320, y: 100, width: 500, height: 80, color: '#39FF14')  # Center obstacle
      @obstacle6 = Rectangle.new(x: 0, y: 300, width: 550, height: 40, color: '#39FF14')  # Narrow platform
      @obstacle7 = Rectangle.new(x: 0, y: 375, width: 720, height: 30, color: '#39FF14')  # Bottom platform

      # Goal and Ball Setup
      @goal.x = 70
      @goal.y = 355
      @ball.x = 295  
      @ball.y = 125  
      @speed = 0


      @block_arr[0] = @obstacle1
      @block_arr[1] = @obstacle2
      @block_arr[2] = @obstacle3
      @block_arr[3] = @obstacle4
      @block_arr[4] = @obstacle5
      @block_arr[5] = @obstacle6
      @block_arr[6] = @obstacle7
      @menu.remove
      @quit_button.remove
      @quit_text.remove
      @victory_text&.remove 
      @stroketext&.remove
      @menu_text&.remove
      @menu_visible = false
    end
  end

end


# Mouse Press Event (Start Dragging)
on :mouse_down do |event|
  if @menu_visible && event.x.between?(0, 50) && event.y.between?(0, 23)
    close
  end
  if event.button == :left && ((event.x - @ball.x) ** 2 + (event.y - @ball.y) ** 2 <= @ball.radius ** 2)
    @dragging = true
  end
  
end

# Mouse Release Event (Stop Dragging)
on :mouse_up do |event|
  if event.button == :left && @dragging
    dx = @ball.x - event.x
    dy = @ball.y - event.y
    @angle = Math.atan2(dy, dx)  # Store direction angle
    @speed = Math.sqrt(dx**2 + dy**2) * 0.05  # Scale speed by drag distance
    @dragging = false
    @dotted_line.each(&:remove)
    @dotted_line.clear
    @opposite_line&.remove
    @opposite_line = nil
    @putt_sound.play
    @strokes+=1
  end

end


# Mouse Drag Event (Update Lines)
on :mouse_move do |event|
  if @dragging
    @dotted_line.each(&:remove)
    @dotted_line.clear
    @opposite_line&.remove

    dx = event.x - @ball.x
    dy = event.y - @ball.y
    opposite_x = @ball.x - 1.75 * dx
    opposite_y = @ball.y - 1.75 * dy

    @opposite_line = Line.new(x1: @ball.x, y1: @ball.y, x2: opposite_x, y2: opposite_y, width: 3, color: 'red', z: 15)

    dot_count = 8
    step_x = dx / dot_count.to_f
    step_y = dy / dot_count.to_f

    dot_count.times do |i|
      @dotted_line << Circle.new(x: @ball.x + step_x * i, y: @ball.y + step_y * i, radius: 3, color: 'yellow', z: 20)
    end
  end
end

# Input: A rectangel or a Circle 
# return: Boolion if the Ball is inside the obstical
# Checks if the the ball is going to colide with an obstical
def collision(block)
  # First check if block is a Rectangle
  if block.is_a?(Rectangle)
    step_x = Math.cos(@angle) * @speed
    step_y = Math.sin(@angle) * @speed

    next_x_pos = @ball.x + step_x
    next_y_pos = @ball.y + step_y

    # Check if ball will collide with the rectangle
    return next_x_pos > block.x - @ball.radius && 
           next_x_pos < block.x + block.width + @ball.radius &&
           next_y_pos > block.y - @ball.radius && 
           next_y_pos < block.y + block.height + @ball.radius
  
  # Check if block is a Circle (like the goal)
  elsif block.is_a?(Circle)
    step_x = Math.cos(@angle) * @speed
    step_y = Math.sin(@angle) * @speed
    
    next_x_pos = @ball.x + step_x
    next_y_pos = @ball.y + step_y
    
    # Calculate distance between centers
    distance = Math.sqrt((next_x_pos - block.x)**2 + (next_y_pos - block.y)**2)
    return distance < (@ball.radius + block.radius)
  end
  
  # If it's neither a Rectangle nor a Circle, return false
  return false
end
# Input: A rectangel or a Circle 
#return: Nothing
# Calulates which diration the ball is going to bounce when hitting an obstical
def bounce(block)
  if block.is_a?(Rectangle)
    # Calculate which side was hit
    ball_center_x = @ball.x
    ball_center_y = @ball.y
    block_center_x = block.x + block.width / 2
    block_center_y = block.y + block.height / 2
    
    # Find collision normal
    dx = (ball_center_x - block_center_x) / (block.width / 2)
    dy = (ball_center_y - block_center_y) / (block.height / 2)
    
    # Determine if collision is more horizontal or vertical
    if dx.abs > dy.abs
      @angle = Math::PI - @angle  # Horizontal bounce
    else
      @angle = -@angle  # Vertical bounce
    end
  elsif block.is_a?(Circle)
    # Calculate angle of collision
    dx = @ball.x - block.x
    dy = @ball.y - block.y
    normal_angle = Math.atan2(dy, dx)
    
    # Reflect the ball's direction
    incident_angle = @angle + Math::PI  # Opposite direction ball is moving
    reflect_angle = 2 * normal_angle - incident_angle
    @angle = reflect_angle + Math::PI  # Convert back to direction ball is moving
  end
  
  @speed *= 0.7  # Lose energy on bounce
end

update do
  if @speed > 0.1
    @ball.x += Math.cos(@angle) * @speed
    @ball.y += Math.sin(@angle) * @speed
    @speed -= @speed * 0.027

    # Check for goal collision
    if @goal && collision(@goal) && @speed<0.1
      @goal_sound.play
      @menu_visible = true
      @menu = Rectangle.new(x: 0, y: 0, width: 720, height: 405, color: 'blue', z:21)
      @quit_button = Rectangle.new(x: 0, y: 0, width: 50, height: 23, color: 'red', z:21)
      @quit_text = Text.new('Quit?', x: 0, y: 0, style: 'bold', size: 20, color: 'black', z:21)
      @victory_text = Text.new('You won!!! Choose a new map from 1-5 using the keypad', x: 60, y: 110, style: 'bold', size: 20, color: 'black', z:21)
      @stroketext = Text.new("You won in #{@strokes} strokes", x: 60, y: 130, style: 'bold', size: 20, color: 'black', z:21)
      @won = true

    end

    # Check for collisions with obstacles
    @block_arr.each do |block|
      if block && collision(block)
        bounce(block)
      end
    end
  else
    @speed = 0
  end

end

show