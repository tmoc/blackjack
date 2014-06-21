class window.Hand extends Backbone.Collection

  model: Card

  initialize: (array, @deck, @isDealer) ->
    @winCount = 0

  hit: ->
    @add(@deck.pop()).last()

  stand: ->
    @trigger 'stand'

  scores: ->
    # The scores are an array of potential scores.
    # Usually, that array contains one element. That is the only score.
    # when there is an ace, it offers you two scores - the original score, and score + 10.
    hasAce = @reduce (memo, card) ->
      memo or card.get('value') is 1
    , false
    score = @reduce (score, card) ->
      score + if card.get 'revealed' then card.get 'value' else 0
    , 0
    if hasAce then [score, score + 10] else [score]

  trueScores: ->
    # doesn't ignore the flipped cards
    hasAce = @reduce (memo, card) ->
      memo or card.get('value') is 1
    , false
    score = @reduce (score, card) ->
      score + card.get 'value'
    , 0
    if hasAce then [score, score + 10] else [score]

  bestScore: ->
    scores = @trueScores()
    if scores.length > 1
      if scores[1] > 21
        scores[0]
      else
        scores[1]
    else
      scores[0]

  bestVisibleScore: ->
    scores = @scores()
    if scores.length > 1
      if scores[1] > 21
        scores[0]
      else
        scores[1]
    else
      scores[0]

  shouldHit: ->
    if @bestScore() > 21
      no
    else if @bestScore() < 17
      yes
    else
      no
