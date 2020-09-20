class Dog 

  attr_accessor :id, :name, :breed
  
  def initialize(id=nil, name:, breed:)
    @id, @name, @breed = id, name, breed
  end 
  
end