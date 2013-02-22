class Replace
  
  def self.replace(rank, hand)
    case rank
    when :straight_flush
      replace = []
    when :four_of_a_kind
      ranks = freq_rank(hand)
      replace = find_odd_from_foak(hand, ranks)
    when :full_house
      replace = []
    when :flush
      replace = []
    when :straight
      replace = []
    when :three_of_a_kind
      ranks = freq_rank(hand)
      replace = find_odds_from_pairs_or_triples(hand, ranks)
    when :two_pair
      ranks = freq_rank(hand)
      replace = find_odds_from_pairs_or_triples(hand, ranks)
    when :one_pair
      suits = freq_suit(hand)
      most_suit = suits.max
      if most_suit == 4
        replace = odd_out_of_four_same_suit(hand, suits)
      else
        ranks = freq_rank(hand)
        replace = find_odds_from_pairs_or_triples(hand, ranks)
      end
    when :high_card
      suits = freq_suit(hand)
      most_suit = suits.max
      if most_suit == 4
        replace = odd_out_of_four_same_suit(hand, suits)
      else
        replace = extract_n_lowest_ranked(hand, 3)
      end
    end
    replace
  end
  
  def self.freq_rank(hand)
    freqs = [0,0,0,0,0,0,0,0,0,0,0,0,0]
    
    hand.each do |card|
      freqs[rank_to_index(card[0])] += 1
    end
    freqs
  end
  
  def self.freq_suit(hand)
    suits = [0,0,0,0]
    hand.each do |card|
      case card[1].upcase
      when "C"
        suits[0] += 1
      when "D"
        suits[1] += 1
      when "H"
        suits[2] += 1
      when "S"
        suits[3] += 1
      end
    end
    suits
  end
      
  
  def self.find_odd_from_foak(hand, ranks)
    hand.each do |card|
      if card[0] <= '5'
        return [card] if ranks[rank_to_index(card[0])] == 1
      else
        return [''] if ranks[rank_to_index(card[0])] == 1
      end
    end
    throw "Error find_odd_from_foak got hand #{hand}"
  end
  
  def self.find_odds_from_pairs_or_triples(hand, ranks)
    discards = Array.new
    hand.each do |card|
      discards << card if ranks[rank_to_index(card[0])] == 1
    end
    discards
  end
  
  def self.odd_out_of_four_same_suit(hand, suits)
    hand.each do |card|
      case card[1].upcase
      when "C"
        return [card] if suits[0] == 1
      when "D"
        return [card] if suits[1] == 1
      when "H"
        return [card] if suits[2] == 1
      when "S"
        return [card] if suits[3] == 1
      end
    end
  end
  
  def self.extract_n_lowest_ranked(hand, n)
    hand.sort! { |x, y| rank_to_index(x[0]) <=> rank_to_index(y[0]) }
    hand[0..(n-1)]
  end
  
  
  private
    def self.rank_to_index(rank)
      case rank.upcase
      when "2".."9"
        rank.to_i - 2
      when "T"
        8
      when "J"
        9
      when "Q"
        10
      when "K"
        11
      when "A"
        12
      else
        throw "Error: got card rank #{card[0]}"
      end
    end
end