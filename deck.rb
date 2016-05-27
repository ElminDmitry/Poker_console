class Deck

  def initialize
    @deck = []
  end

  def create_deck
    suits = %w[clubs diamonds spades hearts]
    ranks = ['A', *2..9, 'T',  'J', 'Q', 'K']
    @deck = ranks.product(suits).shuffle!
  end

  def get_card(count)
    @deck.pop(count)
  end
end
