require_relative 'lib/cubeRep/cube'

cube = Cube.new
puts cube.cube.join(' ')
6.times do
  cube.moves("R U R' U'")
  puts cube.cube.join(' ')
end
