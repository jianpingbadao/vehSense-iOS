//
//  Gyroscope.swift
//  vehsense
//
//  Created by Brian Green on 6/27/18.
//  Copyright © 2018 Weida Zhong. All rights reserved.
//

import Foundation
import CoreMotion

class Gyroscope{
    
    static let shared = Gyroscope()
    
    var motionManager = CMMotionManager()
    
    let notificationName = Notification.Name.init(gyroscopeNotification)
    
    private init()
    {
        motionManager.gyroUpdateInterval = 0.2
        
    }
    
    func startGyroscope()
    {
        motionManager.startGyroUpdates(to: OperationQueue.current!) { (rawData, error) in
            if let gyroscopeData = rawData{
                let data = ["gyroData" : gyroscopeData]
                NotificationCenter.default.post(name: self.notificationName, object: nil, userInfo: data)
            }
        }
    }
    
    func stopGyroscope()
    {
        motionManager.stopGyroUpdates()
    }
}
