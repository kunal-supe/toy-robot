class Robot
  class << self
    # Define left/right directions and its moves
    MOVES = {"left_direction": {"NORTH": "WEST", "WEST": "SOUTH", "EAST": "NORTH", "SOUTH": "EAST"},
            "right_direction":{"NORTH": "EAST", "WEST": "NORTH", "EAST": "SOUTH", "SOUTH": "WEST"},
            "step": {"NORTH": [0,1], "WEST": [-1,0], "EAST": [1,0], "SOUTH": [0,-1]}}
    
    def run
      file = File.open("toy-robot.txt", "r")
      lines = []
      file.each_line {|line| lines << line.split("\n") }
      lines = lines.flatten
      p execute_robot_move(lines) if validate_inputs(lines)
    end

    # Define Boundary
    def within_boundary(next_step_coordinates)
      x = ((next_step_coordinates[0] < 5) and (next_step_coordinates[0] > -1))
      y = ((next_step_coordinates[1] < 5) and (next_step_coordinates[1] > -1))
      x and y
    end

    def valid_commands(commands)
      all_valid_commands = ["MOVE","LEFT","RIGHT","REPORT"]
      (commands - all_valid_commands).empty? && commands.last == "REPORT"
    end

    def execute_robot_move(lines)
      # Get the initial position of robot
      get_position = lines.first.split(' ').last
      robot_position = get_position.split(',')

      # Process the later commands
      lines[1..lines.count-1].each do |cmd|
        case cmd
        when "LEFT","RIGHT"
          robot_direction = robot_position.last
          new_direction = change_direction(robot_direction,cmd)
          robot_position[2] = new_direction
        when "MOVE"
          robot_coordinates = next_step(robot_position)
          robot_position[0] = robot_coordinates[0]
          robot_position[1] = robot_coordinates[1]
        when "REPORT"
          robot_position
        else
        end
      end
      robot_position
    end    

    private
    
    def validate_inputs(lines)
      n = lines.count
      # Commands validation check
      return puts "The initial line is invalid. Enter valid command." if !(initial_line_validator(lines.first))
      return puts "The later commands are invalid." if !valid_commands(lines[1..n-1])
      true
    end  

    def next_step(robot_position)
      robot_coordinates = robot_position.first(2).map(&:to_i)
      robot_direction = robot_position.last

      # Calculate the next step, & check if it is within the boundary
      next_step_coordinates = [robot_coordinates,MOVES[:step][robot_direction.to_sym]].transpose.map(&:sum)
      if within_boundary(next_step_coordinates)
        new_coordinates = next_step_coordinates
      else
        new_coordinates = robot_coordinates
      end
      new_coordinates
    end

    def change_direction(robot_position,direction)
      if direction == "LEFT"
        new_direction = MOVES[:left_direction][robot_position.to_sym]
      elsif direction == "RIGHT"
        new_direction = MOVES[:right_direction][robot_position.to_sym]
      else
        new_direction = "NORTH" #Default
      end
    end

    # Validation methods
    def initial_line_validator(line)
      initial_line_regex = /PLACE [0-4],[0-4],(NORTH|SOUTH|EAST|WEST)\z/
      return true if line.match?(initial_line_regex)
    end
  end
end
Robot.run