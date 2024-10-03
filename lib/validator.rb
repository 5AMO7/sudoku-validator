class Validator
  def initialize(puzzle_string)
    @puzzle_string = puzzle_string
  end

  def self.validate(puzzle_string)
    new(puzzle_string).validate
  end

  def validate
    content = @puzzle_string.split()

    def readNumbers(fileContents)
      numbers = []
      # Puts all of the numbers in an array, ignoring the special characters
      fileContents.each do |i|
        if i.include? "|"
          numbers.append(i[-1])
        elsif !i.include? "-"
          numbers.append(i)
        else
        end
      end

      # Converts the numbers array elements to integers
      numbers = numbers.map(&:to_i)

      numbers
    end

    def dataToArray(data)
      numbers = readNumbers(data)
      # Puts the numbers in a 2D array, resolving in rows for each block
      rows = numbers.each_slice(3).to_a

      # Puts the approporite rows in a their own arrays - blocks
      blocks = []
      (0..rows.length-1).step(9) do |i|
        group = rows[i, 9]
        (0..2).each do |j|
          blocks.push([group[j],group[j + 3],group[j + 6]])
        end
      end

      blocks
    end

    def checkDupes(array)
      return false if array.detect{ |e| array.count(e) > 1 } == 0 || array.detect{ |e| array.count(e) > 1 } == nil
      return true
    end

    def checkBlocks(data)
      data.each do |block|
        numbers = []
        numbers.concat(block[0]).concat(block[1]).concat(block[2])

        if checkDupes(numbers)
          return false
        end

      end
      return true
    end

    def checkRows(data)
      k=0
      (0..2).each do |x|
        (0..2).each do |i|
          row = []
          (k..k+2).each do |j|
            row.concat(data[j][i])
          end

          if checkDupes(row)
            return false
          end

        end
        k+=3
      end
      return true
    end

    def checkColumns(data)
      k=0
        (0..2).each do |y|
          (0..2).each do |z|
            column = []
            (k..k+6).step(3) do |j|
              (0..2).each do |i|
                column.append(data[j][i][z])
              end
            end

            if checkDupes(column)
              return false
            end

          end
          k+=1
        end
        return true
    end

    data = dataToArray(content)

    if !checkBlocks(data) || !checkRows(data) || !checkColumns(data) || (readNumbers(content).any? {|x| x > 9} || readNumbers(content).any? {|x| x < 0})
      return "Sudoku is invalid."
    elsif readNumbers(content).include? 0
      return "Sudoku is valid but incomplete."
    else
      return "Sudoku is valid."
    end

  end
end
