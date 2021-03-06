define ['box2d'], (B2D) ->
  
  class VectorHelpers
    @rotate: (vector, angle) ->
      rotationMatrix = B2D.Mat22.FromAngle angle
      result = vector.Copy()  
      result.MulM rotationMatrix
  
      result

    @createDirectionVector: (angle) ->
      v = new B2D.Vec2 1, 0
      VectorHelpers.rotate v, angle
