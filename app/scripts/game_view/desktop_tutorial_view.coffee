define ['view', 'math_helpers', 'pixi_animator'], (View, MathHelpers, Animator) ->
  class DesktopTutorialView extends View
    constructor: (container, stage) ->
      super container, stage

    createGraphics: ->
      graphics = new PIXI.Graphics()

      cellSize = 30
      padding = 5
      gridUnit = cellSize + padding

      x = gridUnit
      y = @container.height/2

      @keysTutorialContainter = new PIXI.Graphics()
      @_drawMovmentTutorial @keysTutorialContainter, x, y, cellSize, padding
      @_drawCannonTutorial @keysTutorialContainter, x, y, cellSize, padding

      @keysTutorialContainter.alpha = 0

      @objectiveTutorialContainer = new PIXI.Graphics()
      @_drawObjectiveTutorial @objectiveTutorialContainer, x, y, cellSize, padding
      @objectiveTutorialContainer.alpha = 0

      graphics.addChild @keysTutorialContainter
      graphics.addChild @objectiveTutorialContainer

      graphics

    onAppearance: ->
      (new Animator(@keysTutorialContainter).animate [
        type: 'fadeIn'
        duration: 1000
      ,
        type: 'stay'
        duration: 1000
      ,
        type: 'fadeOut'
        duration: 1000
      ,
        type: 'stay'
        duration: 1000
      ,
      ]).then =>
        new Animator(@objectiveTutorialContainer).animate [
          type: 'fadeIn'
          duration: 1000
        ,
          type: 'stay'
          duration: 1000
        ,
          type: 'fadeOut'
          duration: 1000
        ]

    _drawMovmentTutorial: (graphics, x, y, cellSize, padding)->
      gridUnit = cellSize + padding
      @_drawArrowGraphcis graphics,
        position: new PIXI.Point(x,y - cellSize),
        keysize: cellSize
        charSet: ["A", "D", "W"]
        padding: 5

      @_drawArrowGraphcis graphics,
        position: new PIXI.Point(x + gridUnit * 4, y - cellSize),
        keysize: cellSize
        charSet: ["⬅",  "➡", "⬆"]
        padding: 5

      orGraphics = new PIXI.Text "/",
        font: "12pt Helvetica"
        fill: "#EEEEEE"
        align: "center"

      orGraphics.position = new PIXI.Point x + gridUnit * 3.5 , y
      orGraphics.anchor = new PIXI.Point 0.5,0.5
      graphics.addChild orGraphics

    _drawArrowGraphcis: (graphics, options) ->
      {position, keysize, charSet, padding} = options

      padding = 5

      drawKey = (char, x, y) =>
        @_drawKey graphics, x, y, keysize, keysize, char

      drawKey charSet[0], position.x, position.y
      drawKey charSet[1], position.x + (padding + keysize) * 2, position.y
      drawKey charSet[2], position.x + padding + keysize , position.y - padding - keysize

    _drawCannonTutorial: (graphics, x, y, cellSize, padding) ->
      gridUnit = cellSize + padding
      @_drawKey graphics, x, y + gridUnit * 1, gridUnit * 7 - padding, cellSize , "SPACE"

    _drawKey: (graphics, x, y, width,height, text) ->
      graphics.lineStyle 2, 0xEEEEEE, 0.7
      graphics.beginFill 0x122a39
      graphics.drawRect x, y, width, height
      graphics.endFill()

      text = new PIXI.Text text,
        font: "12pt DroidSans"
        fill: "white"
        align: "center"

      text.position = new PIXI.Point(x + width / 2, y + height / 2)
      text.anchor = new PIXI.Point 0.5,0.5

      graphics.addChild text

    _drawObjectiveTutorial: (graphics, x, y, cellSize, padding) ->
      gridUnit = cellSize + padding
      graphics.lineStyle 3, 0xDDDDDD, 1

      [startX, startY] =  [x + gridUnit, y]

      graphics.drawCircle startX, startY , cellSize

      drawSwiftLine = (angle, length) =>
        @_drawSwiftLine graphics, startX, startY, cellSize, length, angle

      drawSwiftLine 90, 30
      drawSwiftLine 145, 20
      drawSwiftLine 180, 20
      drawSwiftLine 215, 20
      drawSwiftLine 270, 30


      distance = 30
      graphics.drawCircle startX + gridUnit + distance , startY , 5
      graphics.drawCircle startX + gridUnit + distance * 2 , startY , 5
      graphics.drawCircle startX + gridUnit + distance * 3 , startY , 5

      shipHeight = 20
      shipWidth = 30

      graphics.moveTo startX + gridUnit * 3 + distance * 3, startY - shipHeight/2
      graphics.lineTo startX + gridUnit * 3 + distance * 3, startY + shipHeight/2
      graphics.lineTo startX + gridUnit * 3 + distance * 3 - shipWidth, startY
      graphics.lineTo startX + gridUnit * 3 + distance * 3, startY - shipHeight/2
      graphics.endFill()

    _drawSwiftLine: (graphics, x, y, r, length, angle) ->
      startPoint = @_getPointOnCircle(x, y , r, angle)
      graphics.moveTo startPoint.x, startPoint.y
      graphics.lineTo startPoint.x - length, startPoint.y

    _getPointOnCircle: (centerX, centerY, r, angle) ->
      new PIXI.Point( centerX + Math.cos(MathHelpers.d2r angle) * r , centerY + Math.sin(MathHelpers.d2r angle) * r)