# Test Cases

require './toy_robot.rb'

RSpec.describe ".validate_first_input" do
  it "check if the initial input is correct" do
    expect(("PLACE 4,0,WEST")).to match(/PLACE [0-4],[0-4],(NORTH|SOUTH|EAST|WEST)\z/)
  end

  it "must be within boundary" do
    expect(Robot.within_boundary([3,4])).to eq(true)
  end

  it "should ignore if not within boundary" do
    expect(Robot.within_boundary([5,4])).to eq(false)
  end
end

RSpec.describe ".validate_other_commands" do
  it "all later commands should be valid" do
    expect(Robot.valid_commands(["MOVE","LEFT","REPORT"])).to eq(true)
  end

  it "any incorrect commands should return false" do
    expect(Robot.valid_commands(["MOVE","NONE","REPORT"])).to eq(false)
  end
end

RSpec.describe ".verify_end_result" do
  let(:lines) {["PLACE 4,0,WEST", "MOVE", "LEFT", "REPORT"] }
  let(:result) {Robot.execute_robot_move(lines)}
  
  it "should be within the boundary" do
    expect(Robot.within_boundary((result).first(2))).to eq(true)
  end

  it "should return expected result" do
    expect(result).to eq([3, 0, "SOUTH"])
  end
 
end