class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    new_stud = Student.new()

    new_stud.id = row[0]
    new_stud.name = row[1]
    new_stud.grade = row[2]
    new_stud
  end
# pat = Student.new
# sam = Student.new
# jess = Student.new
  def self.all
    sql = "SELECT * FROM students"

    DB[:conn].execute(sql).map { |row| Student.new_from_db(row) }
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT *
      FROM students s
      WHERE s.name = ?
      SQL

    row = DB[:conn].execute(sql, name).flatten

    Student.new_from_db(row)
    # find the student in the database given a name
    # return a new instance of the Student class
  end

  def self.all_students_in_grade_9
    Student.all.select { |student| student.grade.to_i == 9 }
  end

  def self.students_below_12th_grade
    Student.all.select { |student| student.grade.to_i < 12 }
  end

  def self.first_X_students_in_grade_10(num_students)
    Student.all.select { |student| student.grade.to_i == 10}
        .sort_by { |student| student.id }.first(num_students)
  end

  def self.first_student_in_grade_10
    Student.first_X_students_in_grade_10(1)[0]
  end

  def self.all_students_in_grade_X(grade)
    Student.all.select { |student| student.grade.to_i == grade }
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
