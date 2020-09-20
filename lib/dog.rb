class Dog 

  attr_accessor :id, :name, :breed
  
  def initialize(id: nil, name:, breed:)
    @id, @name, @breed = id, name, breed
  end 
  
  def self.create_table
    sql = "CREATE TABLE IF NOT EXISTS dogs (id INTEGER PRIMARY KEY, name TEXT, grade TEXT)"
    DB[:conn].execute(sql)
  end 
  
  def self.drop_table 
    sql = "DROP TABLE dogs"
    DB[:conn].execute(sql)
  end
  
  def save 
    sql = "INSERT INTO dogs (name, breed) VALUES ( ?, ? )"
    DB[:conn].execute(sql, self.name, self.breed)
    id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
    name = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][1]
    breed = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][2]
    Dog.new(id: id, name: name, breed: breed)
  end
  
  def self.create(hash)
    dog = Dog.new(hash)
    dog.save
    dog
  end 
  
  def self.new_from_db(array)
    attributes_hash = {
      :id = array[0],
      :name = array[1],
      :breed = array[2]
    }
    self.new(attributes_hash) 
  end
  
  def self.find_by_id(id)
    sql = "SELECT * FROM dogs WHERE id = ?"
    result = DB[:conn].execute(sql, id)[0]
    Dog.new(id: result[0], name: result[1], breed: result[2])
  end
  
  def self.find_or_create_by(name:, breed:)
    sql = <<-SQL
      SELECT * FROM dogs
      WHERE name = ? AND breed = ?
    SQL
    
    dog = DB[:conn].execute(sql, name, breed).first
    
    if dog 
      new_dog = self.new_from_db(dog)
    else 
      new_dog = self.create({:name => name, :breed => breed})
    end 
    new_dog
  end
  
end
