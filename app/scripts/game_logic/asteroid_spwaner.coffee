define ['typed_object', 'planet', 'wave', 'events', 'math_helpers'], (TypedObject, Planet, Wave, Events, MathHelpers) ->
  class AsteroidSpwaner extends TypedObject
    constructor: (options) ->
      super "asteroidSpwaner"
      @width = options.width
      @height = options.height
      @waveIndex = 0
      @events = new Events()

      @options =
        sizeRange:
          min: 3
          max: 4
        timeOffset:
          min: 1000
          max: 3000
          range: 1000
          step: 200
        density:
          min: 1
          max: 9
          step: 0.2
          range: 0.4

    startSpwaning: ->
      @startNextWave(0)

    startNextWave: (waveIndex) ->
      wavePlan = @generageWavePlan(waveIndex)
      @events.trigger "newWave", waveIndex
      @currentWave = new Wave wavePlan

      @currentWave.events.on "newAsteroid", (asteroid) =>
        @events.trigger "newAsteroid", asteroid

      @waveDestroyedCallback = =>
        @waveIndex++

        @startNextWave(@waveIndex)

      @currentWave.events.on 'waveDestroyed', @waveDestroyedCallback

      @currentWave.start()

    generageWavePlan: (waveIndex)->
      @currentWaveCount = @_getRandomAsteroidsCount waveIndex
      wavePlan = []
      for i in [0..@currentWaveCount]
        wavePlan.push @_generageRandomAsteroidPlan waveIndex

      wavePlan

    getWaveNumber: ->
      @waveIndex

    pause: ->
      @currentWave.pause()

    resume: ->
      @currentWave.resume()

    destroy: ->
      @currentWave.events.off "waveDestroyed", @waveDestroyedCallback
      @currentWave.destroy()

    _generageRandomAsteroidPlan: (waveIndex) ->
      radius = @_getRandomRadius()

      asteroidPlan =
        radius: radius
        position: @_getRandomPosition radius
        offset: @_getRandomTimeOffset waveIndex
        density: @_getRandomDensity waveIndex

      asteroidPlan

    _getRandomAsteroidsCount: (waveIndex) ->
      3 + Math.floor(Math.pow((waveIndex + 1), 1.2))

    _getRandomRadius: ->
      MathHelpers.random @options.sizeRange.min, @options.sizeRange.max

    _getRandomDensity: (waveIndex) ->
      densityMin = Math.min(@options.density.min + @options.density.step * waveIndex, @options.density.max)
      densityMax = Math.min(densityMin + @options.density.range, @options.density.max)
      density = MathHelpers.random densityMin, densityMax

      density

    _getRandomTimeOffset: (waveIndex) ->
      offsetMax = Math.max(@options.timeOffset.max - @options.timeOffset.step * waveIndex, @options.timeOffset.min)
      offsetMin = Math.max(offsetMax - @options.timeOffset.range, @options.timeOffset.min)
      offset = MathHelpers.random offsetMin, offsetMax

      offset

    _getRandomPosition: (asteroidRadius) ->
      side = _.random 3, 4

      randomY = _.random -@height/2, @height/2
      randomX = _.random -@width/2, @width/2

      offset = 0.1
      switch side
        # top
        when 1
          x: randomX
          y: -@height/2 -asteroidRadius + offset
        # bottom
        when 2
          x: randomX
          y: @height/2 + asteroidRadius - offset
        # left
        when 3
          x: -@width/2 - asteroidRadius + offset
          y: randomY
        # right
        when 4
          x: @width/2 + asteroidRadius - offset
          y: randomY

