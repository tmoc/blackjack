#todo:
#
# handle if player has 21 after deal.. BLACKJACK!!
# make UI cool with cards, css and background
# switch out UI controls when a round ends, show "play again" & "restart game"
# restart game
# new round
#
# can get and set attributes on a collection, but it is not easy or recommended
  # http://stackoverflow.com/questions/5930656/setting-attributes-on-a-collection-backbone-js
class window.App extends Backbone.Model

  initialize: ->
    @set 'playerWins', 0
    @set 'dealerWins', 0
    @set 'deck', deck = new Deck()
    @set 'playerHand', deck.dealPlayer()
    @set 'dealerHand', deck.dealDealer()
    # listen to stand
    @get("playerHand").on "stand", =>
      @dealerPlays()
    # listen to playerHand
    @get("playerHand").on "add", =>
      if @playerOver21()
        @dealerWins()
    # listen to dealerHand
    @get("dealerHand").on "add", =>
      @dealerPlays()

  evalWinner: ->
    if @get('dealerHand').bestScore() > 21 or @get('playerHand').bestScore() > @get('dealerHand').bestScore()
      @playerWins()
    else
      @dealerWins()

  dealerWins: ->
    wins = @get 'dealerWins'
    @set 'dealerWins', wins + 1
    @endCurrentGame()

  playerWins: ->
    wins = @get 'playerWins'
    @set 'playerWins', wins + 1
    @endCurrentGame()

  endCurrentGame: ->
    dHand = @get('dealerHand')
    dHand.at(0).flip()
    # todo: prompt for new round or game

  dealerPlays: ->
    if @get('dealerHand').shouldHit()
      @get('dealerHand').hit()
    else
      @evalWinner()

  playerOver21: ->
    @get('playerHand').bestScore() > 21
