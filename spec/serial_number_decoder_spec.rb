require 'spec_helper' 

describe SerialNumberDecoder do

  Given(:rules)      { {} }
  Given(:deductions) { {} } 
  Given(:serial)     { '' }  
  Given(:decoder)    { SerialNumberDecoder.new(rules, serial) }

  Given(:brand_rule) { 
    { brand: 
      { 
        name: 'porsche',
        checks: { } 
      } 
    } 
  }
  
  Then { assert_equal decoder.class, SerialNumberDecoder }

  describe 'character_at_index' do
    
    Given(:ford_serial)     { '1f3456' }
    Given(:not_ford_serial) { '1z3456' }
    
    describe 'when serial number may be for a ford' do 
      
      Given(:serial) { ford_serial }
      Given(:actual) { decoder.character_at_index( 'f', 1 )}
      
      Given(:expected) { 'might be a ford' }
      Then { assert_equal expected, actual }
    end
    # describe 'when serial number cannot be for a ford' do 
    #   Given(:serial) { ford_serial }
    
    #   Then { assert_equal decoder.character_at_index( 'f', 1 ), 'might be a ford' 
    # end 
  end 
  
  describe '#build_graph' do         
    
    Given { brand_rule[:brand][:checks].merge!( within_size_range: 1..10 ) }
    Given { rules.merge! brand_rule }
    
    Given(:deductions)   { decoder.deductions[:brand]['porsche'] }
    Given(:valid_serial) { '123456' }
    
    describe 'character count check' do      
      describe 'inclusion' do

        Given(:serial)   { valid_serial }
        Given(:expected) { ["character count matches"]}
      
        Then { assert_equal deductions[:pass], expected }
      end 
      
      describe 'exclusion' do 

        Given(:serial_out_of_range)    { '12345678901234'}        
        Given(:serial)   { serial_out_of_range }
        Given(:expected) { "character count does not match"}
        
        Then { assert_equal deductions[:fail], [expected] }
      end 
    end
    
    describe 'forbidden character check' do
      
      Given(:checks) { brand_rule[:brand][:checks] } 
      Given { checks.replace( without_forbidden_characters: %w(o l q) ) }

      describe 'exclusion' do 
        
        Given(:serial)   { valid_serial }
        Given(:expected) { "has correct characters"}
        
        Then { assert_equal [expected], deductions[:pass] }
      end 
      
      describe 'inclusion' do
        
        Given(:serial_with_forbidden_characters) { '1234oiq'}
        Given(:serial)   { serial_with_forbidden_characters }
        Given(:expected) { "has wrong characters"}
        
        Then { assert_equal deductions[:fail], [expected] }
      end 
    end
  end
end