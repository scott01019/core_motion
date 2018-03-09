//
//  motion_detector.swift
//  first_game
//
//  Created by Scott Burnette on 3/8/18.
//  Copyright © 2018 Scott Burnette. All rights reserved.
//

import Foundation
import CoreMotion

class MotionDetector {
    var motionManager = CMMotionManager()
    let opQueue = OperationQueue()
    var angle : [String : Double] = [ "x": 0.0, "y": 0.0 ]
    
    
    init() {
        if motionManager.isDeviceMotionAvailable {
            print("We can detect device motion")
            startReadingMotionData()
        }
        else {
            print("We cannot detect device motion")
        }
    }
    
    func startReadingMotionData() {
        motionManager.deviceMotionUpdateInterval = 0.2
        motionManager.startDeviceMotionUpdates(to: opQueue) {
            (data: CMDeviceMotion?, error: Error?) in
            
            if let mydata = data {
                self.angle["x"]! = mydata.gravity.x
                self.angle["y"]! = mydata.gravity.y
                //                print("pitch raw", mydata.attitude.pitch)
                //                print("pitch", self.degrees(mydata.attitude.pitch))
            }
        }
    }
    
    func getAngle() -> [String : Double] { return angle }
}
