require 'yaml'



BRANDS = { 
  'porsche' => { 
    '356' => {
      '356' => {},
      '356a' => {} 
    },
    
    '911' => {
      '911t' => {},
      '993' => {},
      '996' => {},
      '997' => {}
       
    }
  }
}

RULES = {
  'porsche' => {
    type: :brand, 
    checks: { 
      checks: {
        within_size_range: 1..10,
        without_forbidden_characters: %w(o l q) 
      }     
    }, 
    
    '356' => {
      type: :model, 
      checks: { 
        # within_size_range: 5..5
      }
    } 
  }
}

def write_to_yaml(hash) 
  File.open("lib/car_rules.yml", "w") do |file| 
    file.write(hash.to_yaml) 
  end 
end 

write_to_yaml(BRANDS)
write_to_yaml(RULES)
