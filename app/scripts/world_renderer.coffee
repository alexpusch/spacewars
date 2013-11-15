define ->
  class WorldRenderer
    constructor: (options) ->
      @renderersTypes = {}
      @renderers = {}

    setupRenderer: (options) ->
      @stage = new PIXI.Stage(0xFFFFFF, true) 
      @stage.setInteractive(false)

      width = options.container.width()
      height = options.container.height()

      @renderer = PIXI.autoDetectRenderer(width, height, null, false, true)
      options.container.append(@renderer.view)

    registerRenderer: (type, renderer) ->
      @renderersTypes[type] = renderer

    render: (world) ->
      _.each world.getEntities(), (entity) =>
        @getRenderer(entity).render(entity)

      @renderer?.render(@stage);

    getRendererType: (type) ->
      @renderersTypes[type]

    getRenderer: (entity) ->
      unless @renderers[entity.toString()]?
        @renderers[entity.toString()] = new (@getRendererType(entity.type))(@stage, entity)

      @renderers[entity.toString()]


