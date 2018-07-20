def entity_for_coordinates(row, col)
  root = Math.sqrt(Sudoku.dim).to_i
  row / root + col / root + (row / root) * (root - 1)
end