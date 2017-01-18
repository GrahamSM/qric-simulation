class Property < ApplicationRecord
  belongs_to :team, optional: true
  belongs_to :property_type, optional: true
  belongs_to :development


  def adjust_property_value(prop, dev)

  end

  def develop(id)
  	binding.pry()
  	message = ''
    @team = Team.find(id)
  	if !(self.development)
  		message << 'No Development Found'
  	else
      @team.drop_cash_balance(self.development.cost)
      @team.save!
      self.in_development = true
      self.developed = true
      self.value += self.development.value
      self.development.used = true
      self.save!
      binding.pry()
      message << 'Development Initiated Successfully'
    end
    return message
  end



end
