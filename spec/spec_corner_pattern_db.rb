require 'rspec'
require_relative '../lib/cubeRep/cube'
require_relative '../lib/cubeRep/moves'
require_relative '../lib/dbmake/corner_pattern_db'

RSpec.describe CornerPatternDb do
  let(:db) { CornerPatternDb.new }
  let(:cube) { Cube.new }

  describe '#encode' do
    it 'encodes solved state to 0' do
      expect(db.encode(cube.cube[0..7])).to eq(0)
    end

    it 'encodes within valid range' do
      expect(db.encode(cube.cube[0..7])).to be_between(0, 88_179_839)
    end

    it 'produces unique encodings for different states' do
      encodings = []
      state = cube.cube.dup

      %w[R U F L D B].each do |move|
        db.parse_move(state, move)
        enc = db.encode(state[0..7])
        expect(encodings).not_to include(enc)
        encodings << enc
      end
    end

    it 'produces different encoding after a move' do
      original = db.encode(cube.cube[0..7])
      state = cube.cube.dup
      db.parse_move(state, 'R')
      expect(db.encode(state[0..7])).not_to eq(original)
    end

    it 'returns same encoding for same state' do
      state = cube.cube.dup
      db.parse_move(state, 'R')
      enc1 = db.encode(state[0..7])
      enc2 = db.encode(state[0..7])
      expect(enc1).to eq(enc2)
    end

    it 'returns original encoding after inverse move' do
      original = db.encode(cube.cube[0..7])
      state = cube.cube.dup
      db.parse_move(state, 'R')
      db.parse_move(state, "R'")
      expect(db.encode(state[0..7])).to eq(original)
    end

    it 'debug inverse' do
      state = cube.cube.dup
      puts "before: #{state[0..7]}"
      db.parse_move(state, 'R')
      puts "after R: #{state[0..7]}"
      db.parse_move(state, "R'")
      puts "after R': #{state[0..7]}"
      puts "solved: #{cube.cube[0..7]}"
    end
  end

  describe '#lehmer' do
    it 'returns 0 for identity permutation' do
      solved_ids = cube.cube[0..7].map { |v| v / 3 }
      # identity [0,1,2,3,4,5,6,7] should give lehmer 0
      expect(db.lehmer(8, cube.cube[0..7])).to eq(0)
    end
  end

  describe '#orientation_id' do
    it 'returns 0 for solved state' do
      expect(db.orientation_id(cube.cube[0..7])).to eq(0)
    end
  end
end
