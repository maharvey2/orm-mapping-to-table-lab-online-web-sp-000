class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]

  attr_accessor :name, :grade

  attr_reader :id

  def initialize(name, grade, id=nil)
    @id = id 
    @name = name
    @grade = grade
  end

  def self.create_table
    sql = <<-SQL
      Create Table IF Not Exists
      students (
        id Integer Primary Key,
        name Text,
        grade Text
      )
      SQL
      DB[:conn].execute(sql)
    end

    def self.drop_table
      sql = <<-SQL
      Drop Table students
      SQL
      DB[:conn].execute(sql)
    end
  
    def save
      sql = <<-SQL
      Insert Into students (name, grade)
        Values (?, ?)
      SQL

      DB[:conn].execute(sql, self.name, self.grade)
      @id = DB[:conn].execute("Select last_insert_rowid() From students")[0][0]
    end

    def self.create(name:, grade:)
      student = Student.new(name, grade)
      student.save
      student
    end


end