define ['box2d', 'spaceship', 'math_helpers'], (B2D, Spaceship, MathHelpers)->
  describe "Spaceship", ->
    beforeEach ->
      @cannonHeatRate = 0.01
      @cannonCooldownRate = 0.05
      @spaceship = new Spaceship
        speed: 10
        angularSpeed: 10
        width: 20
        length: 30
        cannonHeatRate: @cannonHeatRate
        cannonCooldownRate: @cannonCooldownRate

      @world = new B2D.World(new B2D.Vec2(0, 0),  true)

      fixtureDef =  @spaceship.getEntityDef().fixtureDef
      bodyDef = @spaceship.getEntityDef().bodyDef

      @body = @world.CreateBody bodyDef
      @body.CreateFixture fixtureDef

      @spaceship.setBody @body

    describe "getVertices", ->
      it "returns the vertices of the spaceship", ->
        vertices = @spaceship.getVertices()
        expect(vertices[0]).toBeVector new B2D.Vec2(-15, -10)
        expect(vertices[1]).toBeVector new B2D.Vec2(15, 0)
        expect(vertices[2]).toBeVector new B2D.Vec2(-15, 10)

    describe "fire main thrusters", ->
      it "turns on main thrusters", ->
        @spaceship.fireMainThrusters()
        expect(@spaceship.thrusters.main).toBe 'on'

    describe "fire left thruster", ->
      it "turns on left thrusters", ->
        @spaceship.fireLeftThrusters()
        expect(@spaceship.thrusters.left).toBe 'on'

    describe "fire right thruster", ->
      it "turns on right thrusters", ->
        @spaceship.fireRightThrusters()
        expect(@spaceship.thrusters.right).toBe 'on'

    describe "turn main thrusters off", ->
      it "turns off main thrusters", ->
        @spaceship.turnMainThrustersOff()
        expect(@spaceship.thrusters.main).toBe 'off'

    describe "turn left thrusters off", ->
      it "turns off left thrusters", ->
        @spaceship.turnLeftThrustersOff()
        expect(@spaceship.thrusters.left).toBe 'off'

    describe "turn right thrusters off", ->
      it "turns off right thrusters", ->
        @spaceship.turnRightThrustersOff()
        expect(@spaceship.thrusters.right).toBe 'off'

    describe "update", ->
      describe "main thrusters are on", ->
        it "a force is applied forwards", ->
          @spaceship.body.ApplyForce = jasmine.createSpy('applyForce')
          @spaceship.body.GetAngle = jasmine.createSpy('getAngle').andReturn(0)
          @spaceship.fireMainThrusters()
          @spaceship.update()
          expect(@spaceship.body.ApplyForce.mostRecentCall.args[0]).toBeVector(new B2D.Vec2(10,0))

      describe "left thrusters are on", ->
        it "a toruqe is applied to the left", ->
          @spaceship.body.GetAngle = jasmine.createSpy('getAngle').andReturn(0)
          @spaceship.body.ApplyTorque = jasmine.createSpy('ApplyTorque')
          @spaceship.fireLeftThrusters()
          @spaceship.update()
          expect(@spaceship.body.ApplyTorque).toHaveBeenCalledWith(-10)

      describe "right thrusters are on", ->
        it "a toruqe is applied to the right", ->
          @spaceship.body.GetAngle = jasmine.createSpy('getAngle').andReturn(0)
          @spaceship.body.ApplyTorque = jasmine.createSpy('ApplyTorque')
          @spaceship.fireRightThrusters()
          @spaceship.update()
          expect(@spaceship.body.ApplyTorque).toHaveBeenCalledWith(10)

      describe "both right and main thrusters are on", ->
        it "applies a force forwards and a toruqe to the right", ->
          @spaceship.body.GetAngle = jasmine.createSpy('getAngle').andReturn(0)
          @spaceship.body.ApplyTorque = jasmine.createSpy('ApplyTorque')
          @spaceship.body.ApplyForce = jasmine.createSpy('ApplyForce')
          @spaceship.fireMainThrusters()
          @spaceship.fireRightThrusters()
          @spaceship.update()
          expect(@spaceship.body.ApplyForce.mostRecentCall.args[0]).toBeVector new B2D.Vec2(10,0)
          expect(@spaceship.body.ApplyTorque).toHaveBeenCalledWith(10)

      describe "auto pilot is on", ->
        beforeEach ->
          position = new B2D.Vec2(0,0)
          @spaceship.setPosition position
          @spaceship.setAngle 0

        it "turns the spaceship left when the target in left to the spaceship", ->
          target = new B2D.Vec2(0,1)
          @spaceship.setAutoPilotTarget target
          @spaceship.update()

          expect(@spaceship.thrusters.right).toBe "on"
          expect(@spaceship.thrusters.left).toBe "off"

        it "turns the spaceship right when the target in right to the spaceship", ->
          target = new B2D.Vec2(0, -1)
          @spaceship.setAutoPilotTarget target
          @spaceship.update()

          expect(@spaceship.thrusters.left).toBe "on"
          expect(@spaceship.thrusters.right).toBe "off"

        it "does not turn the spaceship when the target is directly infornt of it", ->
          target = new B2D.Vec2(2, 0)
          @spaceship.setAutoPilotTarget target
          @spaceship.update()

          expect(@spaceship.thrusters.left).toBe "off"
          expect(@spaceship.thrusters.right).toBe "off"

        it "fires main thrusters when the target is directly infornt of the ship", ->
          target = new B2D.Vec2(2, 0)
          @spaceship.setAutoPilotTarget target
          @spaceship.update()

          expect(@spaceship.thrusters.main).toBe "on"

        xit "does not fire main thrusters when the target is directly behind of the ship", ->
          target = new B2D.Vec2(-2, 0)
          @spaceship.setAutoPilotTarget target
          @spaceship.update()

          expect(@spaceship.thrusters.main).toBe "off"

