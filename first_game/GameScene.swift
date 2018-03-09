//
//  GameScene.swift
//  first_game
//
//  Created by Scott Burnette on 3/8/18.
//  Copyright © 2018 Scott Burnette. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    let motionDetector : MotionDetector = MotionDetector()
    let RADIUS : Double = 70.0
    let WIDTH : Double = Double(UIScreen.main.bounds.width)
    let HEIGHT : Double = Double(UIScreen.main.bounds.height)
    private var circles : [CirclePhysics] = [CirclePhysics]()
    private var circleMap : [Int : SKShapeNode] = [Int : SKShapeNode]()
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
    override func didMove(to view: SKView) {
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            self.circles.append(CirclePhysics(x: Double(pos.x), y: Double(pos.y), m: 2.0, id: self.circles.count))
            
            var Circle = SKShapeNode(circleOfRadius: CGFloat(RADIUS) ) // Size of Circle = Radius setting.
            Circle.position = pos  //touch location passed from touchesBegan.
            Circle.strokeColor = UIColor.white
            Circle.glowWidth = 1.0
            Circle.fillColor = UIColor(red:   CGFloat(Float(arc4random()) / Float(UINT32_MAX)),
                                       green: CGFloat(Float(arc4random()) / Float(UINT32_MAX)),
                                       blue:  CGFloat(Float(arc4random()) / Float(UINT32_MAX)),
                                       alpha: 1.0)
            
            if let cir = self.circles.last {
                self.circleMap[cir.id] = Circle
            }
            
            self.addChild(Circle)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        for circle in self.circles {
            for otherCircle in self.circles {
                let d : Double = sqrt(pow(circle.x - otherCircle.x, 2) + pow(circle.y - otherCircle.y, 2))
                if d <= RADIUS * 2 {
                    circle.resolveCollision(otherCircle: otherCircle)
                }
            }
            
            if circle.x + RADIUS > WIDTH || circle.x - RADIUS < -1 * WIDTH {
                circle.v_x = (circle.v_x) * -1
            }
            if circle.y + RADIUS > HEIGHT || circle.y - RADIUS < -1 * HEIGHT {
                circle.v_y = (circle.v_y) * -1
            }
            
            circle.x = circle.x + circle.v_x * currentTime / 100000.0
            circle.y = circle.y + circle.v_y * currentTime / 100000.0
            circle.applyGravitationalForce(angle: self.motionDetector.getAngle())
            circle.applyFriction()
        }
        
        for circle in self.circles {
            if let drawableCircle = self.circleMap[circle.id] {
                drawableCircle.position.x = CGFloat(circle.x)
                drawableCircle.position.y = CGFloat(circle.y)
            }
        }
    }
}
