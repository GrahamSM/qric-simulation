class TradeRequest < ApplicationRecord

	validate :property_or_money_outgoing
	validate :property_or_money_incoming
	validates :offeror_id, presence: true
	validates :offeree_id, presence: true


	#Carries out the trade by swapping properties and cash.
	def execute_trade
		offeror = Team.find(self.offeror_id)
		offeree = Team.find(self.offeree_id)
		outgoing_properties = self.outgoing_properties
		incoming_properties = self.incoming_properties
		outgoing_cash = self.outgoing_cash
		incoming_cash = self.incoming_cash
		swap_properties(offeror, outgoing_properties, offeree, incoming_properties)
		swap_cash(offeror, offeree, outgoing_cash, incoming_cash)
	end

	def valid_trade
		return false if !self.cash_valid
		# return false if !TradeRequest.tradeable(self.incoming_properties)
		# return false if !TradeRequest.tradeable(self.outgoing_properties)
		return false if !self.properties_valid
		return true
	end

	#Validate property swap for the trade. Returns false if properties are no longer in possession of a given team.
	def properties_valid
		offeror = Team.find(self.offeror_id)
		offeree = Team.find(self.offeree_id)
		if incoming_properties
			incoming_properties.each do |prop|
				property = Property.find(prop.to_i)
				return false if property.team_id != offeree.id
			end
		end
		if outgoing_properties
			outgoing_properties.each do |prop|
				property = Property.find(prop.to_i)
				return false if  property.team_id != offeror.id
			end
		end
		return true
	end

	#Validate cash swap for the trade. Returns false if cash is outside max limits or is greater than a teams cash balance.
	def cash_valid
		if self.incoming_cash
			if ! self.incoming_cash.between?(0,1000000000)
				return false
			end
			if self.incoming_cash > Team.find(self.offeree_id).cash_balance
				return false
			end
		end
		if self.outgoing_cash
			if ! self.outgoing_cash.between?(0,1000000000)
				return false
			end
			if self.outgoing_cash > Team.find(self.offeror_id).cash_balance
				return false
			end
		end
		return true
	end

	#Cash swapping method - simply exchanges the tendered cash amounts between the two parties.
	def swap_cash(u1, u2, c1, c2)
		if c1
			u1.cash_balance -= c1
			u2.cash_balance += c1
		end
		if c2
			u2.cash_balance -= c2
			u1.cash_balance += c2
		end
		u2.save!
		u1.save!
	end

	#Ensures that something is being offered.
	def property_or_money_outgoing
		if (!outgoing_properties && !outgoing_cash)
			errors[:base] << "Specify properties, cash, or both."
		end
	end

	#Ensures that something is being requested.
	def property_or_money_incoming
		if (!incoming_properties == 0 && !incoming_cash)
			errors[:base] << "Specify properties, cash, or both."
		end
	end

	#Employs helper methods to swap properties offered by each team.
	def swap_properties(offeror, offeror_properties, offeree, offeree_properties)
		pass_and_delete_properties(offeror_properties, offeror, offeree)
		pass_and_delete_properties(offeree_properties, offeree, offeror)
	end

	#Passes properties tendered by one team to the other, and deletes traded properties from the passing teams portfolio.
	def pass_and_delete_properties(props, sender, receiver)
		if props
			props.each do |prop|
				property = Property.find(prop)
				receiver.properties << property
				sender.properties.delete(Property.find(property.id))
			end
			receiver.save!
			sender.save!
		end
	end

	#Returns the id of the opposite party for a given trade request. Self is used because we are operating on this instance. 
	def self.getOtherParty(tr, id)
		(tr.offeror_id == id) ? tr.offeree_id : tr.offeror_id
	end

	#Verifies that the properties in a given request are not developed. If they are, the trade request is deemed invalid.
	def self.tradeable(props)
		tradeable = true
		if (props)
			props.each do |prop|
				property = Property.find(prop)
				tradeable = !property.developed?
			end
		end
		return tradeable
	end

end
