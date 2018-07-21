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
      @value = @available.pop
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

  def solve(f_name)
    @matrix, @entities = FileParser.new.parse(f_name)
    while pass_through do

    end
    print_sudoku(@matrix)
  end

  def pass_through
    r = false
    @matrix.each_with_index do |row, row_index|
      row.each_with_index do |cell, col_index|
        # check each column
        (1..@@dim).each do |i|
          r = cell.remove(@matrix[row_index][i - 1].value) || r
        end
        # check each row
        (1..@@dim).each do |i|
          r = cell.remove(@matrix[i - 1][col_index].value) || r
        end
        # check entity squares
        entity = @entities[entity_for_coordinates(row_index, col_index)]
        entity.each do |c|
          r = cell.remove(c.value) || r
        end
      end
    end
    r
  end
end

s = Sudoku.new
f_name = "data/example3.txt"
s.solve(f_name)