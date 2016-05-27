require_relative 'deck'

class Hand

  def initialize
    start_game
  end

  def start_game
    @new_deck = Deck.new
    @new_deck.create_deck

    player_hand = @new_deck.get_card(2)
    @hand1 = player_hand
    dealer_hand = @new_deck.get_card(2)
    table = @new_deck.get_card(5)
    puts "You have: #{ player_hand }"
    puts "Table: #{ table }"
    player_combination = player_hand.concat table
    
    player_combination = create_rank(player_combination)
    
    one = score(player_combination)
    
    which_combination one
  end

  def which_combination(sum)
    case
      when sum == 2000
        puts 'royal-flush'
      when sum == 1500
        puts 'straight-flush'
      when sum == 1200
        puts 'care'
      when sum == 1000
        puts 'full-house'
      when sum == 700
        puts 'flush'
      when sum == 500
        puts 'straight with ace'
      when sum == 450
        puts 'straight'
      when sum == 300
        puts 'one pair'
      when sum == 350
        puts 'two pairs'
      when sum == 200
        puts 'high card'
      else
        puts 'fail!'
    end
  end

  def score(hand)#save hand and big straight
    score = 0
    if straight?(hand)&&flush?(hand)        #royal-flush
      score += 2000
    elsif straight?(hand)&&flush?(hand)   #straight-flush
      score += 1500
    elsif care? hand
      score += 1200
    elsif three?(hand)&&one_pair?(hand)     #full-house
      score += 1000
    elsif flush?(hand)                   #flush
      score += 700
    elsif straight?(hand)              #straight_up
      score += 500
    elsif straight?(hand)                 #straight_down
      score += 450
    elsif three?(hand)
      score += 400
    elsif one_pair?(hand)
      score += 300
    elsif two_pair?(hand)
      score += 350
    else high_card(hand)
      score += 200
    end
    score
  end

  def high_card(combination)
    combination.to_h.keys.sort.last
  end

  def one_pair?(combination)#call after two_pair?
    number_of_rank(combination, 2)
  end

  def two_pair?(combination)
    count = Hash.new(0)
    combination.flatten.each_with_index do |rank, index|
      count[rank] += 1 if index.even?
    end
    num = 0
    count.values.each do |item|
      if item == 2
        num+=1
      end
    end
    num == 2
  end

  def three?(combination)
    number_of_rank(combination, 3)
  end

  def care?(combination)
    number_of_rank(combination, 4)
  end

  def flush?(combination)
    count_of_rank = Hash.new(0)
    combination.flatten.each_with_index do |suit, index|
      count_of_rank[suit] += 1 unless index.even?
    end
    count_of_rank.has_value?(5)
  end

  def straight?(combination)
    @answer1 = false
    @answer2 = false
    if combination.to_h.has_key?(14)
      @answer1 = each_street(combination)
      combination.flatten.map! { |e| e == 14 ? 1 : e }
      @answer2 = each_street(combination)
    end
    @answer2 = each_street(combination)
    @answer1||@answer2
  end

  def each_street(combination_for)
    answer = false
    count_of_rank = Hash.new(0)
    combination_for.combination(5).to_a.each do |five_cards|
      five_cards.flatten.each_with_index do |rank, index|
        count_of_rank[rank] += 1 if index.even?
      end
      answer = count_of_rank.keys.sort.each_cons(2).all? { |x,y| y == x + 1 }
      count_of_rank = Hash.new(0)
    end
    answer if answer
  end

  def number_of_rank(combination_for, number)
    count_of_rank = Hash.new(0)
    combination_for.flatten.each_with_index do |rank, index|
      count_of_rank[rank] += 1 if index.even?
    end
    count_of_rank.has_value?(number)
  end

  def create_rank(combination)
    combination.each do |card|
      case
        when card[0] == 'T'
          card[0] = 10
        when card[0] == 'J'
          card[0] = 11
        when card[0] == 'Q'
          card[0] = 12
        when card[0] == 'K'
          card[0] = 13
        when card[0] == 'A'
          card[0] = 14
      end
      combination
    end
  end
end
Hand.new
