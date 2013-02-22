class Calc
  
  
  
  ###
  ##
  ###
  def self.kelly(prob)
    prob = prob.to_f
    b = 1.0 / prob
    (prob * (b + 1) - 1) / b
  end
  
  def self.hand_prob(hand, distinct = 7462.0)
    1 - ((hand - 1) / distinct)
  end
  
  def self.ev_call(prob, pot, call)
    prob = prob.to_f
    pot = pot.to_f
    call = call.to_f
    (prob * pot) + (1 - prob) * (-call)
  end
  
  def self.get_hand_rank(value)
    case value
    when 1..10
      :straight_flush
    when 11..166
      :four_of_a_kind
    when 167..322
      :full_house
    when 323..1599
      :flush
    when 1600..1609
      :straight
    when 1610..2467
      :three_of_a_kind
    when 2468..3325
      :two_pair
    when 3326..6185
      :one_pair
    when 6186..7462
      :high_card
    end
  end
  
  def self.ev_raise(prob, pot, call, kelly, bankroll)
    prob = prob.to_f
    pot = pot.to_f
    call = call.to_f
    kelly = kelly.to_f
    bankroll = bankroll.to_f
    (prob * pot) + ((1 - prob) * (-call - (kelly * bankroll)))
  end
    
end