define ['entity'], (Entity) ->
  class Bullet extends Entity
    getEntityDef: ->
      bodyDef = new B2D.BodyDef
      bodyDef.type = B2D.Body.b2_dynamicBody
      bodyDef.position = new B2D.Vec2 0,0
      bodyDef.angularDamping = 5
      fixtureDef = new B2D.FixtureDef
      fixtureDef.mass = 1
      fixtureDef.density = 1
      fixtureDef.friction = 0
      fixtureDef.shape = new B2D.CircleShape 1


      # fixtureDef.shape.SetAsBox(1, 1)
      bodyDef: bodyDef
      fixtureDef: fixtureDef