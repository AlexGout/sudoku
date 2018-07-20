require 'pp'

class Cell
  @available = (1..Sudoku.dim).to_a

  def initialize(value)
    @value = value
    if (@value > 0)
      remove(@value)
    end
  end

  def value
    @value
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
    @available.delete(to_remove)
  end
end

class FileParser
  def parse(string)
    lines = File.readlines(string)
    Sudoku.dim = lines.length
    result = Array.new(Sudoku.dim)
    lines.each_with_index do |line, l|
      result[l] = Array.new(line.chomp!.length)
      line.chars.each_with_index do |c, i|
        cell = Cell.new(c.to_i)
        result[l][i] = cell
      end
    end
    result
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
    @matrix = FileParser.new.parse(f_name)
  end
end

def pass_through
  @matrix.each_with_index do |row, row_index|
    row.each_with_index do |cell, col_index|
      # check each column
      (1..@@dim).each do |i|
        cell.remove(@matrix[row_index][i].value)
      end
      # check each row
      (1..@@dim).each do |i|
        cell.remove(@matrix[i][col_index].value)
      end
      # check squares
    end
  end
end

s = Sudoku.new
f_name = "data/example1.txt"
exists = File.file?(f_name)
if (!exists)
  raise ArgumentError, "file #{f_name} does not exist"
end
s.read_from_file("data/example1.txt")