define ->
  class ScoreRenderer
    constructor: (@stage, @score) ->
      @text = new PIXI.Text(@score.getScore())

    render: ->
      @text.setText @score.getScore()
      @text.position.x = 50
      @text.position.y = 50

      @stage.addChild @text