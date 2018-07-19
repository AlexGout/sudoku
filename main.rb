require 'pp'

dim = 9
root = Math.sqrt(dim).to_i

matrix = Array.new(dim,[])
(0..dim-1).each do |i|
  matrix[i] = Array.new(dim,0)
end

matrix.each_with_index do |r,i|
  r.each_with_index do |c, j|
    matrix[i][j] = i / root + j / root + (i/root)*(root - 1)
  end
end

pp matrix