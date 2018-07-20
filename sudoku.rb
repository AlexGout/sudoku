require 'pp'
require './util'

class Cell
  def initialize(value, x, y)
    @strval = "(#{x},#{y})"
    @available = []
    @value = value
    if (@value == 0)
      @available = (1..Sudoku.dim).to_a
    end
  end

  def value
    @value
  end

  def strval
    @strval
  end

  def value=(value)
    @value = value
    @available = []
  end

  def is_set
    @value && @value > 0
  end

  def available_values
    @available
  end

  def remove(to_remove)
    removed = @available.delete(to_remove)
    if (@available.length == 1)
      @value = @available[0]
      @available.pop
    end
    removed
  end
end

class FileParser
  def parse(string)
    lines = File.readlines(string)
    Sudoku.dim = lines.length
    sudoku_matrix = Array.new(Sudoku.dim)
    entity_matrix_array = Array.new(Sudoku.dim) {[]}

    lines.each_with_index do |line, l|
      sudoku_matrix[l] = Array.new(Sudoku.dim)
      line.split(" ").each_with_index do |c, i|
        cell = Cell.new(c.to_i, l, i)
        sudoku_matrix[l][i] = cell
        entity_matrix_array[entity_for_coordinates(l, i)].push(cell)
      end
    end
    return sudoku_matrix, entity_matrix_array
  end

end

class Sudoku
  @@dim = 0

  def self.dim
    @@dim
  end

  def self.dim=(dim)
    @@dim = dim
  end

  def read_from_file(f_name)
    @matrix, @entities = FileParser.new.parse(f_name)
  end
end

def pass_through
  r1, r2, r3 = false
  @matrix.each_with_index do |row, row_index|
    row.each_with_index do |cell, col_index|
      # check each column
      (1..@@dim).each do |i|
        r1 = r1 || cell.remove(@matrix[row_index][i].value)
      end
      # check each row
      (1..@@dim).each do |i|
        r2 = r2 || cell.remove(@matrix[i][col_index].value)
      end
      # check entity squares
      entity = @entities[entity_for_coordinates(row_index, col_index)]
      @entities[entity].each do |c|
        r3 = r3 || cell.remove(c.value)
      end
    end
  end
  r1 || r2 || r3
end

s = Sudoku.new
f_name = "data/example1.txt"
s.read_from_file(f_name)