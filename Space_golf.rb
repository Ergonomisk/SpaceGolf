require 'ruby2d'

class Ball
  attr_reader :x, :y, :radius, :circle, :speed, :angle, :dragging
  
  def initialize(x, y, radius, color)
    @x = x
    @y = y
    @radius = radius
    @circle = Circle.new(x: x, y: y, radius: radius, sectors: 32, color: color, z: 5)
    @speed = 0
    @angle = 0
    @dragging = false
    @dotted_line = []
    @opposite_line = nil
  end
  
  def update
    if @speed > 0.1
      @x += Math.cos(@angle) * @speed
      @y += Math.sin(@angle) * @speed
      @circle.x = @x
      @circle.y = @y
      @speed -= @speed * 0.027
    else
      @speed = 0
    end
  end
  
  def set_position(x, y)
    @x = x
    @y = y
    @circle.x = x
    @circle.y = y
  end
  
  def hit(target_x, target_y)
    dx = @x - target_x
    dy = @y - target_y
    @angle = Math.atan2(dy, dx)
    @speed = Math.sqrt(dx**2 + dy**2) * 0.05
    clear_aim_lines
    true
  end
  
  def start_drag
    @dragging = true
  end
  
  def stop_drag(release_x, release_y)
    if @dragging
      hit(release_x, release_y)
      @dragging = false
      return true
    end
    false
  end
  
  def update_aim_lines(mouse_x, mouse_y)
    if @dragging
      clear_aim_lines
      
      dx = mouse_x - @x
      dy = mouse_y - @y
      opposite_x = @x - 1.75 * dx
      opposite_y = @y - 1.75 * dy
      
      @opposite_line = Line.new(x1: @x, y1: @y, x2: opposite_x, y2: opposite_y, width: 3, color: 'red', z: 15)
      
      dot_count = 8
      step_x = dx / dot_count.to_f
      step_y = dy / dot_count.to_f
      
      dot_count.times do |i|
        @dotted_line << Circle.new(x: @x + step_x * i, y: @y + step_y * i, radius: 3, color: 'yellow', z: 20)
      end
    end
  end
  
  def clear_aim_lines
    @dotted_line.each(&:remove)
    @dotted_line.clear
    @opposite_line&.remove
    @opposite_line = nil
  end
  
  def contains_point?(point_x, point_y)
    (point_x - @x) ** 2 + (point_y - @y) ** 2 <= @radius ** 2
  end
  
  def will_collide_with?(block)
    next_x_pos = @x + Math.cos(@angle) * @speed
    next_y_pos = @y + Math.sin(@angle) * @speed
    
    if block.is_a?(Rectangle)
      return next_x_pos > block.x - @radius && 
             next_x_pos < block.x + block.width + @radius &&
             next_y_pos > block.y - @radius && 
             next_y_pos < block.y + block.height + @radius
    elsif block.is_a?(Circle)
      distance = Math.sqrt((next_x_pos - block.x)**2 + (next_y_pos - block.y)**2)
      return distance < (@radius + block.radius)
    end
    
    false
  end
  
  def bounce(block)
    if block.is_a?(Rectangle)
      block_center_x = block.x + block.width / 2
      block_center_y = block.y + block.height / 2
      
      dx = (@x - block_center_x) / (block.width / 2)
      dy = (@y - block_center_y) / (block.height / 2)
      
      if dx.abs > dy.abs
        @angle = Math::PI - @angle  # Horizontal bounce
      else
        @angle = -@angle  # Vertical bounce
      end
    elsif block.is_a?(Circle)
      dx = @x - block.x
      dy = @y - block.y
      normal_angle = Math.atan2(dy, dx)
      
      incident_angle = @angle + Math::PI
      reflect_angle = 2 * normal_angle - incident_angle
      @angle = reflect_angle + Math::PI
    end
    
    @speed *= 0.8  # Lose energy on bounce
  end
end

set title: "Space_golf", background: '#39FF14'
set resizable: true
set fullscreen: false
set width: 720 
set height: 405

# Game objects
@play_area = Rectangle.new(x: 0, y: 0, width: 720, height: 405, color: '#281c3c')
@ball = Ball.new(20, 202.5, 10, '#edf1e6')  # Use Ball object instead of Circle directly
@goal = Circle.new(x: 0, y: 0, radius: 11, sectors: 32, color: 'orange')

# Game variables
@menu_visible = true
@strokes = 0
@victory_text = nil
@stroketext = nil

# Audio
@goal_sound = Sound.new('golf-ball-landing-in-hole-joshua-chivers-1-00-01.mp3')
@putt_sound = Sound.new('golf-14-94167.mp3')
@background_music = Music.new('ready-set-drift-michael-grubb-main-version-24555-02-59.mp3')
@background_music.play
@background_music.volume = 20
@background_music.loop = true

# Menu elements
@menu = Rectangle.new(x: 0, y: 0, width: 720, height: 405, color: '#39FF14', z: 21)
@quit_button = Rectangle.new(x: 0, y: 0, width: 50, height: 23, color: 'red', z: 25)
@quit_text = Text.new('Quit?', x: 0, y: 0, style: 'bold', size: 20, color: 'black', z: 25)
@title = Text.new('SPACE GOLF', x: 220, y: 20, style: 'bold', size: 40, color: 'black', z: 25)
@menu_text = Text.new('Choose a level from 1-5 using your keypad', x: 160, y: 80, style: 'bold', size: 20, color: 'black', z: 21)

# Create obstacle placeholders (7 obstacles per level plus borders)
@obstacles = Array.new(7) { Rectangle.new(x: 0, y: 0, width: 0, height: 0, color: '#39FF14') }
@borders = [
  Rectangle.new(x: 0, y: 0, width: 10, height: 405, color: '#39FF14', z: 21),   # left border
  Rectangle.new(x: 0, y: 0, width: 720, height: 10, color: '#39FF14', z: 21),   # top border
  Rectangle.new(x: 710, y: 0, width: 10, height: 405, color: '#39FF14', z: 21), # right border
  Rectangle.new(x: 0, y: 395, width: 720, height: 10, color: '#39FF14', z: 21)  # lower border
]

# Level definitions (each level is a hash with obstacle definitions, ball position, and goal position)
@levels = {
  1 => {
    obstacles: [
      { x: 0, y: 0, width: 720, height: 142.5, color: '#39FF14' },
      { x: 0, y: 262.5, width: 720, height: 140, color: '#39FF14' },
      { x: 0, y: 0, width: 40, height: 405, color: '#39FF14' },
      { x: 680, y: 0, width: 40, height: 405, color: '#39FF14' },
      { x: 0, y: 0, width: 0, height: 0, color: '#39FF14' },
      { x: 0, y: 0, width: 0, height: 0, color: '#39FF14' },
      { x: 0, y: 0, width: 0, height: 0, color: '#39FF14' }
    ],
    ball: { x: 100, y: 202.5 },
    goal: { x: 620, y: 202.5 }
  },
  
  2 => {
    obstacles: [
      { x: 0, y: 0, width: 720, height: 142.5, color: '#39FF14' },
      { x: 0, y: 262.5, width: 720, height: 140, color: '#39FF14' },
      { x: 0, y: 0, width: 40, height: 405, color: '#39FF14' },
      { x: 680, y: 0, width: 40, height: 405, color: '#39FF14' },
      { x: 300, y: 192.5, width: 80, height: 80, color: '#39FF14' },
      { x: 0, y: 0, width: 0, height: 0, color: '#39FF14' },
      { x: 0, y: 0, width: 0, height: 0, color: '#39FF14' }
    ],
    ball: { x: 100, y: 202.5 },
    goal: { x: 620, y: 202.5 }
  },
  
  3 => {
    obstacles: [
      { x: 0, y: 0, width: 720, height: 142.5, color: '#39FF14' },
      { x: 0, y: 262.5, width: 400, height: 140, color: '#39FF14' },
      { x: 0, y: 0, width: 40, height: 405, color: '#39FF14' },
      { x: 660, y: 0, width: 60, height: 405, color: '#39FF14' },
      { x: 300, y: 192.5, width: 80, height: 80, color: '#39FF14' },
      { x: 0, y: 262.5, width: 560, height: 30, color: '#39FF14' },
      { x: 0, y: 365, width: 720, height: 40, color: '#39FF14' }
    ],
    ball: { x: 100, y: 202.5 },
    goal: { x: 425, y: 325 }
  },
  
  4 => {
    obstacles: [
      { x: 10, y: 10, width: 500, height: 120, color: '#39FF14' },
      { x: 0, y: 0, width: 100, height: 405, color: '#39FF14' },
      { x: 60, y: 235, width: 660, height: 160, color: '#39FF14' },
      { x: 460, y: 180, width: 50, height: 60, color: '#39FF14' },
      { x: 10, y: 10, width: 560, height: 80, color: '#39FF14' },
      { x: 650, y: 0, width: 100, height: 405, color: '#39FF14' },
      { x: 300, y: 100, width: 50, height: 80, color: '#39FF14' }
    ],
    ball: { x: 140, y: 180 },
    goal: { x: 610, y: 40 }
  },
  
  5 => {
    obstacles: [
      { x: 0, y: 0, width: 720, height: 100, color: '#39FF14' },
      { x: 150, y: 150, width: 500, height: 100, color: '#39FF14' },
      { x: 0, y: 0, width: 50, height: 405, color: '#39FF14' },
      { x: 650, y: 0, width: 70, height: 405, color: '#39FF14' },
      { x: 320, y: 100, width: 500, height: 80, color: '#39FF14' },
      { x: 0, y: 300, width: 550, height: 40, color: '#39FF14' },
      { x: 0, y: 375, width: 720, height: 30, color: '#39FF14' }
    ],
    ball: { x: 295, y: 125 },
    goal: { x: 70, y: 355 }
  }
}

# Combine all collision objects
@block_arr = @obstacles + @borders

# Function to load a level by number
def load_level(level_num)
  return unless @levels.key?(level_num)
  
  # Reset strokes
  @strokes = 0
  
  # Load level data
  level_data = @levels[level_num]
  
  # Update obstacles
  level_data[:obstacles].each_with_index do |obs_data, index|
    @obstacles[index].remove
    @obstacles[index] = Rectangle.new(
      x: obs_data[:x],
      y: obs_data[:y],
      width: obs_data[:width],
      height: obs_data[:height],
      color: obs_data[:color]
    )
  end
  
  # Update ball and goal positions
  @ball.set_position(level_data[:ball][:x], level_data[:ball][:y])
  @goal.x = level_data[:goal][:x]
  @goal.y = level_data[:goal][:y]
  
  # Update block array
  @block_arr = @obstacles + @borders
  
  # Hide menu
  hide_menu
end

# Function to show menu
def show_menu
  @menu = Rectangle.new(x: 0, y: 0, width: 720, height: 405, color: '#39FF14', z: 21)
  @quit_button = Rectangle.new(x: 0, y: 0, width: 50, height: 23, color: 'red', z: 21)
  @quit_text = Text.new('Quit?', x: 0, y: 0, style: 'bold', size: 20, color: 'black', z: 21)
  @menu_text = Text.new('Choose a level from 1-5 using your keypad', x: 160, y: 80, style: 'bold', size: 20, color: 'black', z: 21)
  @menu_visible = true
end

# Function to hide menu
def hide_menu
  @menu.remove
  @quit_button.remove
  @quit_text.remove
  @menu_text.remove
  @victory_text&.remove 
  @stroketext&.remove
  @menu_visible = false
end

# Function to show victory screen
def show_victory
  @menu_visible = true
  @menu = Rectangle.new(x: 0, y: 0, width: 720, height: 405, color: 'blue', z: 21)
  @quit_button = Rectangle.new(x: 0, y: 0, width: 50, height: 23, color: 'red', z: 21)
  @quit_text = Text.new('Quit?', x: 0, y: 0, style: 'bold', size: 20, color: 'black', z: 21)
  @victory_text = Text.new('You won!!! Choose a new map from 1-5 using the keypad', x: 60, y: 110, style: 'bold', size: 20, color: 'black', z: 21)
  @stroketext = Text.new("You won in #{@strokes} strokes", x: 60, y: 130, style: 'bold', size: 20, color: 'black', z: 21)
end

# Renaming show_victory to show_victory_menu for consistency with the call
alias :show_victory_menu :show_victory

# Keyboard event handler
on :key_down do |event|
  # Toggle menu with escape key
  if event.key == 'escape'
    @menu_visible ? hide_menu : show_menu
  end
  
  # Load levels with number keys
  if event.key.between?('1', '5') && @menu_visible
    level_num = event.key.to_i
    load_level(level_num)
  end
end

# Mouse press event (start dragging)
on :mouse_down do |event|
  if @menu_visible && event.x.between?(0, 50) && event.y.between?(0, 23)
    close
  end
  
  if event.button == :left && !@menu_visible && @ball.contains_point?(event.x, event.y)
    @ball.start_drag
  end
end

# Mouse release event (stop dragging)
on :mouse_up do |event|
  if event.button == :left && @ball.stop_drag(event.x, event.y)
    @putt_sound.play
    @strokes += 1
  end
end

# Mouse drag event (update lines)
on :mouse_move do |event|
  @ball.update_aim_lines(event.x, event.y)
end

# Game update loop
update do
  @ball.update
  
  # Check for goal collision
  if !@menu_visible && @ball.will_collide_with?(@goal) && @ball.speed < 0.1
    @goal_sound.play
    show_victory_menu
  end

  # Check for collisions with obstacles
  @block_arr.each do |block|
    if block && !@menu_visible && @ball.will_collide_with?(block)
      @ball.bounce(block)
    end
  end
end

# Initialize game with a test area
Text.new('Welcome to the secret area, try out your moves!', x: 120, y: 60, style: 'bold', size: 20, color: 'white')

show