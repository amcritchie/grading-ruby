require 'json'
require 'awesome_print'

def compare_grades_to_neighbors(grades)
  last_grade = 100
  differences = []
  grades.each do |grade|
    difference = grade_comparison(grade, last_grade)
    differences.push(difference)
    last_grade = grade
  end
  differences.shift
  differences
end

def grade_comparison(grade, last_grade)
  if grade == last_grade
    difference = 'even'
  elsif grade > last_grade
    difference = 'up'
  elsif grade < last_grade
    difference = 'down'
  end
end

def student_grade_trend(differences)
  up = 0
  down = 0
  last_three_up_downs = []
  differences.each do |difference|
    if difference == 'up'
      up += 1
      last_three_up_downs.push('up')
    elsif difference == 'down'
      down += 1
      last_three_up_downs.push('down')
    end
    if last_three_up_downs.length >= 4
      last_three_up_downs.shift
    end
  end
  trend = trend(last_three_up_downs)
end

def trend(last_three)

  last_three.each do |trend|
    if trend == 'up'
      return 'not in decline'
    end
  end
  'in decline'
end



file = File.read('data/grades.json')
data_hash = JSON.parse(file)

complete_data = {}
p trend_count = {:up => 0, :down => 0}
p trend_up = 0
p trend_down = 0

data_hash.each do |student|

  differences = compare_grades_to_neighbors(student[1])
  trend = student_grade_trend(differences)

  if trend == "not in decline"
    trend_up += 1
  elsif trend == 'in decline'
    trend_down += 1
  end


  complete_data[student[0]] = {
      :grades => student[1],
      :differences => differences,
      :trend => trend
  }
end

ap complete_data
p "Students not in decline :#{trend_up}"
p "Students in decline :#{trend_down}"