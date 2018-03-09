//
//  circle_physics.swift
//  first_game
//
//  Created by Scott Burnette on 3/8/18.
//  Copyright © 2018 Scott Burnette. All rights reserved.
//

import Foundation


class CirclePhysics {
    var id : Int
    var x : Double
    var y : Double
    var v_x : Double
    var v_y : Double
    
    init(x : Double, y : Double, id : Int) {
        self.id = id
        self.x = x
        self.y = y
        self.v_x = 0
        self.v_y = 0
    }
    
    func rotateVelocity(velocity: [String : Double], angle : Double) -> [String : Double] {
        let rotatedVelocity : [String : Double] = [
            "x": velocity["x"]! * cos(angle) - velocity["y"]! * sin(angle),
            "y": velocity["x"]! * sin(angle) + velocity["y"]! * cos(angle)
        ]
        return rotatedVelocity;
    }
    
    func resolveCollision(otherCircle : CirclePhysics) {
        var xVelocityDiff = self.v_x - otherCircle.v_x;
        var yVelocityDiff = self.v_y - otherCircle.v_y;
    
        var xDist = otherCircle.x - self.x;
        var yDist = otherCircle.y - self.y;
    
        if (xVelocityDiff * xDist + yVelocityDiff * yDist >= 0) {
            var angle = -1 * atan2(otherCircle.y - self.y, otherCircle.x - self.x);
        
            var m1 = 1;
            var m2 = 1;
        
            var u1 = rotateVelocity(velocity: [ "x": self.v_x, "y": self.v_y ], angle: angle);
            var u2 = rotateVelocity(velocity: [ "x": otherCircle.v_x, "y": otherCircle.v_y ], angle: angle);
        
            var v1 = [ "x": u1["x"] * (m1 - m2) / (m1 + m2) + u2["x"] * 2 * m2 / (m1 + m2), "y": u1["y"] ];
            var v2 = [ "x": u2["x"] * (m1 - m2) / (m1 + m2) + u1["x"] * 2 * m2 / (m1 + m2), "y": u2["y"] ];
        
            var finalV1 = rotateVelocity(velocity: v1, angle: -1 * angle);
            var finalV2 = rotateVelocity(velocity: v2, angle: -1 * angle);
        
            self.v_x = finalV1["x"]
            self.v_y = finalV1["y"]
        
            otherCircle.v_x = finalV2.x
            otherCircle.v_y = finalV2.y
        }
    }
}
