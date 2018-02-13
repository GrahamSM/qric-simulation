class Property < ApplicationRecord
  belongs_to :team, optional: true
  belongs_to :property_type
  belongs_to :development, optional: true

  def adjust_property_value
    self.value += self.development.value
  end

  def develop(id)
  	message = ''
    @team = Team.find(id)
  	if !(self.development)
  		message << 'No Development Found'
  	else
      # We already know the team can drop their cash balance
      @team.drop_cash_balance(self.development.cost)
      @team.save!
      self.adjust_property_value
      # TODO: Remove in_development field
      self.in_development = true
      self.developed = true
      self.development.used = true
      self.save!
      message << 'Development Initiated Successfully'
    end
    return message
  end

  def getValue()
  	if !(self.developed)
  		return self.value
  	else
  		return self.value + self.development.value
  	end
  end





end
