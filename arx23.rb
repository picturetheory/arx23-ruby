####################################################################
#  Modified from BlackJack game implementation by Catharina Torok  #
#  https://gist.github.com/ctorok/4243004                          #  
#  Two players, Player and Dealer.                                 #
#  Player gets to hit or stay. Dealer only gets dealt two cards.   #
####################################################################

Suits = ["Flasks","Sabers","Staves","Coins"]
Ranks = ["1","2","3","4","5","6","7","8","9","10","11","12","13","14","15"]
$d = [] # Creates the global "d" array for the deck

class Card
  include Enumerable 
    # class variables (private)
    @@suit_value = Hash[ Suits.each_with_index.to_a ]
    @@rank_value = Hash[ Ranks.each_with_index.to_a ]
 
    attr_reader :rank, :suit
    attr_accessor :value
 
    def initialize(rank, suit)
        @rank = rank
        @suit = suit
    end

    def value 
      value = @rank.to_i # Sets value to card's "rank", as integer
    end

    def display_rank
      case @rank
        when "12"
          "Commander"
        when "13"
          "Knight"
        when "14"
          "Master"
        when "15"
          "Ace"
        else
          @rank
        end
    end

    def to_s
      "{display_rank} of {@suit}, value {value}"
    end
end

class Deck
  attr_accessor :cards
  def initialize
    @cards = [] # Creates the @cards array
    Suits.each do |suit| # For each suit, do this
      Ranks.each do |rank| # For each rank (value), do this
        @cards << Card.new(rank, suit) # Array to hold cards
      end
    end
  end
  def shuffle!
    @cards.shuffle! # Shuffles the @card array (you don't say?)
  end
  def draw
    @cards.pop # Remove last element of array, return removed element
  end
  def remaining
    @cards.length
  end
end

# d.cards.each do |card|
#   puts card.to_s
# end

class Player
  attr_accessor :hand, :hand_value
  def initialize
      @hand = []
      @hand_value = 0
      2.times do
        card = $d.draw
        @hand_value == 0 ? @hand_value = card.value.to_i : @hand_value += card.value.to_i
        @hand << card
      end
  end

  def hit
    card = $d.draw
    @hand_value == 0 ? @hand_value = card.value.to_i : @hand_value += card.value.to_i
    @hand << card
  end

  #def switch_ace
  #  while @hand_value > 21
  #    @ace_count -= 1
  #    @hand_value -= 10
  #  end
  #end

  def to_s
    puts "#{@hand.to_s}, total value #{@hand_value}"
  end
end
#########################################################################

# Testing the code
$d = Deck.new
$d.shuffle!
puts "A new deck has been shuffled and there are #{$d.remaining} cards"

player = Player.new
puts "Player's hand:"
puts player.to_s
dealer = Player.new

if player.hand_value == 23
  puts "Player wins with 23!"
  puts "Dealer's hand:"
  puts dealer.to_s    
else
  until player.hand_value > 23 
    # player.switch_ace # Commenting this out for now, could be useful if I ever implement that one value-switching card
    puts "Do you want to hit(h) or stay(s)?"
    action = $stdin.gets.chomp
    if action == "h" 
      puts "You chose to hit, here's your new hand"
      player.hit
      puts player.to_s
    else
      puts "You chose to stay, here's your final hand"
      puts player.to_s
      break
    end
  end

  puts "Dealer's hand:"
  puts dealer.to_s

  if player.hand_value <= 23
    if player.hand_value > dealer.hand_value
      puts "Player wins"
    elsif player.hand_value == dealer.hand_value
      puts "Dealer and Player tied"
    else
      puts "Dealer wins"
    end
  else
    puts "Player busts. Dealer wins"
  end
end

puts "There are #{$d.remaining} cards in the deck"

  