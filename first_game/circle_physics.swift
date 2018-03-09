//
//  circle_physics.swift
//  first_game
//
//  Created by Scott Burnette on 3/8/18.
//  Copyright © 2018 Scott Burnette. All rights reserved.
//

import Foundation


class CirclePhysics {
    
    let MAX_THETA : Double = 2 * Double.pi
    
    var id : Int
    var x : Double
    var y : Double
    var v_x : Double
    var v_y : Double
    var m : Double
    var friction : Double
    
    init(x : Double, y : Double, m : Double, id : Int) {
        self.id = id
        self.x = x
        self.y = y
        self.m = m
        self.v_x = 0.0
        self.v_y = 0.0
        self.friction = 0.999
    }
    
    func applyGravitationalForce(angle: [String : Double]) {
        self.v_x = self.v_x + (angle["x"]! / MAX_THETA * 1.0)
        self.v_y = self.v_y + (angle["y"]! / MAX_THETA * 1.0)
    }
    
    func rotateVelocity(velocity: [String : Double], angle : Double) -> [String : Double] {
        let rotatedVelocity : [String : Double] = [
            "x": velocity["x"]! * cos(angle) - velocity["y"]! * sin(angle),
            "y": velocity["x"]! * sin(angle) + velocity["y"]! * cos(angle)
        ]
        return rotatedVelocity;
    }
    
    func applyFriction() {
        self.v_x = self.v_x * self.friction
        self.v_y = self.v_y * self.friction
    }
    
    func resolveCollision(otherCircle : CirclePhysics) {
        let xVelocityDiff = self.v_x - otherCircle.v_x;
        let yVelocityDiff = self.v_y - otherCircle.v_y;
    
        let xDist = otherCircle.x - self.x;
        let yDist = otherCircle.y - self.y;
    
        if (xVelocityDiff * xDist + yVelocityDiff * yDist >= 0) {
            let angle = -1 * atan2(otherCircle.y - self.y, otherCircle.x - self.x);
            
            var u1 : [String : Double] = rotateVelocity(velocity: [ "x": self.v_x, "y": self.v_y ], angle: angle);
            var u2 : [String : Double] = rotateVelocity(velocity: [ "x": otherCircle.v_x, "y": otherCircle.v_y ], angle: angle);
            
            
            let v1_x : Double = u1["x"]! * (self.m - otherCircle.m) / (self.m + otherCircle.m) + u2["x"]! * 2 * otherCircle.m / (self.m + otherCircle.m)
            let v2_x : Double = u2["x"]! * (self.m - otherCircle.m) / (self.m + otherCircle.m) + u1["x"]! * 2 * self.m / (self.m + otherCircle.m)
            
            let v1 = [ "x": v1_x, "y": u1["y"] ];
            let v2 = [ "x": v2_x, "y": u2["y"] ];
        
            var finalV1 = rotateVelocity(velocity: v1 as! [String : Double], angle: -1 * angle);
            var finalV2 = rotateVelocity(velocity: v2 as! [String : Double], angle: -1 * angle);
        
            self.v_x = finalV1["x"]!
            self.v_y = finalV1["y"]!
        
            otherCircle.v_x = finalV2["x"]!
            otherCircle.v_y = finalV2["y"]!
        }
    }
}
