require_relative 'lib/cubeRep/cube'
require_relative 'lib/dbmake/corner_pattern_db'

db = CornerPatternDb.new
if File.exist?('resources/corner_pdb.dat')
  db.load('resources/corner_pdb.dat')
else
  db.makeDB
  db.save('resources/corner_db.dat')
end
