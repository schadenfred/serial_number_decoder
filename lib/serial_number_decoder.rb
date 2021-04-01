require 'byebug' 

class SerialNumberDecoder
  class SerialNumberDecoderError < StandardError; end
  class UnderflowError < SerialNumberDecoderError; end

  attr_reader :rules, :serial, :deductions
  
  def initialize(rules, serial)
    @serial     = serial
    @rules      = rules
    @deductions = {}
    build_graph(@rules)  
  end

  def build_graph(rules, graph={})
    rules.each do |key, value|
      graph[key] = { value[:name] => checks_met?(value[:checks]) } 
    end
    @deductions = graph
  end 
  
  def checks_met?(checks) 
    @checks = { 
      pass: [],
      fail: [] }
    checks.each do |check, arg|
      send(check, arg) 
    end
    @checks
  end 
   
  def without_forbidden_characters(array) 
    if @serial.match /[#{array.join}]/  
      @checks[:fail] << 'has wrong characters' 
    else 
      @checks[:pass] << 'has correct characters' 
    end
  end 
  
  def character_at_index(character, index) 
     serial_to_array = @serial.scan /\w/
     
     if character = serial_to_array[index]
        "might be a ford"
     end
  end
  
  def within_size_range(argument) 
    if argument.include?(@serial.size) 
      @checks[:pass] << 'character count matches' 
    else 
      @checks[:fail] << 'character count does not match' 
    end
  end 
end